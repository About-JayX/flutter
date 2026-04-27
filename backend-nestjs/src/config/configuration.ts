import databaseConfig from './database.config';
import redisConfig from './redis.config';

export default () => ({
  // 数据库配置
  ...databaseConfig(),
  
  // Redis配置
  ...redisConfig(),
  
  // 其他全局配置...
  app: {
    name: process.env.APP_NAME || 'MyApp',
    port: parseInt(process.env.PORT || '0', 10) || 3000,
    environment: process.env.NODE_ENV || 'dev',
  },
});