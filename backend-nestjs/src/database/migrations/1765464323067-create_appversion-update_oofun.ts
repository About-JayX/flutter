import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateAppversionUpdateOofun1765464323067 implements MigrationInterface {
    name = 'CreateAppversionUpdateOofun1765464323067'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_version\` (\`id\` int NOT NULL AUTO_INCREMENT, \`platform\` varchar(20) NOT NULL, \`update_mode\` tinyint NOT NULL DEFAULT '0', \`version\` varchar(50) NOT NULL, \`build_number\` int NULL, \`title\` varchar(50) NULL, \`message\` text NULL, \`link\` varchar(255) NULL, \`status\` enum ('draft', 'published', 'archived') NOT NULL DEFAULT 'published', \`create_time\` timestamp(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, UNIQUE INDEX \`IDX_6ae38cf5523e384ad9546d6520\` (\`platform\`, \`version\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`ALTER TABLE \`app_oo_fun\` ADD \`route\` varchar(255) NULL COMMENT '路由信息'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo_fun\` DROP COLUMN \`route\``);
        await queryRunner.query(`DROP INDEX \`IDX_6ae38cf5523e384ad9546d6520\` ON \`app_version\``);
        await queryRunner.query(`DROP TABLE \`app_version\``);
    }

}
