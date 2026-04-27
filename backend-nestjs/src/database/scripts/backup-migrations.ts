// src/database/scripts/backup-migrations.ts
import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';
import { spawn } from 'child_process';

// 环境映射
const ENV_FILE_MAP: { [key: string]: string } = {
    dev: '../../../.env.dev',
    stage: '../../../.env.stage',
    prod: '../../../.env.prod',
};

// 解析命令行参数
const args = process.argv.slice(2);
let envName = 'dev';

if (args.includes('--stage')) envName = 'stage';
else if (args.includes('--prod')) envName = 'prod';

const envFile = ENV_FILE_MAP[envName];

// 检查 .env 文件是否存在
const envPath = path.join(__dirname, envFile);
if (!fs.existsSync(envPath)) {
  console.error(`❌ 环境文件不存在: ${envPath}`);
  process.exit(1);
}

// 加载环境变量
dotenv.config({ path: envPath });

// 读取数据库配置
const DB_HOST = process.env.DB_HOST;
const DB_PORT = process.env.DB_PORT || '3306';
const DB_USERNAME = process.env.DB_USERNAME;
const DB_PASSWORD = process.env.DB_PASSWORD;
const DB_NAME = process.env.DB_NAME;

// 验证必要字段
if (!DB_HOST || !DB_USERNAME || !DB_PASSWORD || !DB_NAME) {
  console.error('❌ 错误: .env 文件中缺少必要的数据库配置');
  console.error('需要: DB_HOST, DB_PORT, DB_USERNAME, DB_PASSWORD, DB_NAME');
  process.exit(1);
}

// 备份目录
const backupDir = path.join(__dirname, '../backup');
if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
}

// 获取本地日期时间并格式化为 YYYYMMDDHHMMSS
const now = new Date();
const pad = (n: number) => n.toString().padStart(2, '0');
const year = now.getFullYear();
const month = pad(now.getMonth() + 1); // getMonth() 返回 0-11
const day = pad(now.getDate());
const hour = pad(now.getHours());
const minute = pad(now.getMinutes());
const second = pad(now.getSeconds());

const timestamp = `${year}${month}${day}${hour}${minute}${second}`; // YYYYMMDDHHMMSS

// 转换数据库名为小写
const dbNameLower = DB_NAME.toLowerCase();

// 查找同时间戳的已有文件，计算序号
const existingFiles = fs
  .readdirSync(backupDir)
  .filter(f => 
    f.startsWith(`${dbNameLower}-${timestamp}-`) && 
    f.endsWith('.sql')
  );

const nextIndex = existingFiles.length + 1;
const backupFileName = `${dbNameLower}-${timestamp}-${nextIndex}.sql`;
const backupFilePath = path.join(backupDir, backupFileName);

console.log(`=> 正在备份数据库: ${DB_NAME}`);
console.log(`=> 环境: ${envName}`);
console.log(`=> 主机: ${DB_HOST}:${DB_PORT}`);
console.log(`=> 备份路径: ${backupFilePath}`);

// 构建 mysqldump 命令参数
const dumpArgs = [
  `--host=${DB_HOST}`,
  `--port=${DB_PORT}`,
  `--user=${DB_USERNAME}`,
  `--password=${DB_PASSWORD}`,
  '--single-transaction',
  '--routines',
  '--triggers',
  '--hex-blob',
  DB_NAME,
];

// 执行 mysqldump
const dump = spawn('mysqldump', dumpArgs);

// 捕获输出
const chunks: Buffer[] = [];
dump.stdout.on('data', (chunk) => {
  chunks.push(chunk);
});

dump.stderr.on('data', (chunk) => {
  const msg = chunk.toString();
  if (msg.toLowerCase().includes('error')) {
    console.error(`❌ mysqldump 错误: ${msg}`);
  } else {
    console.warn(`⚠️ mysqldump 警告: ${msg}`);
  }
});

dump.on('close', (code) => {
  if (code !== 0) {
    console.error(`❌ 数据库备份失败，mysqldump 退出码: ${code}`);
    process.exit(1);
  }

  // 写入文件
  try {
    const fullBuffer = Buffer.concat(chunks);
    fs.writeFileSync(backupFilePath, fullBuffer);
    console.log(`✅ 数据库备份成功: ${backupFilePath}`);
    process.exit(0);
  } catch (err) {
    console.error(`❌ 写入备份文件失败: ${err.message}`);
    process.exit(1);
  }
});

// 处理 spawn 错误
dump.on('error', (err) => {
  if (err.message.includes('ENOENT')) {
    console.error('❌ 错误: 未找到 mysqldump 命令，请确保已安装 MySQL 客户端工具');
    console.error('安装方式:');
    console.error('  - Ubuntu: sudo apt-get install mysql-client');
    console.error('  - macOS: brew install mysql-client');
    console.error('  - Windows: 安装 MySQL Installer 并添加到 PATH');
  } else {
    console.error(`❌ 执行 mysqldump 时出错: ${err.message}`);
  }
  process.exit(1);
});