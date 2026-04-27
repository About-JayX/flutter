import { MigrationInterface, QueryRunner } from "typeorm";

export class AddProfileFields1776840390769 implements MigrationInterface {
    name = 'AddProfileFields1776840390769'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`is_status_public\` tinyint NOT NULL DEFAULT '1' COMMENT '状态是否公开 0:否 1:是'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`blur_profile_card\` tinyint NOT NULL DEFAULT '0' COMMENT '是否模糊资料卡 0:否 1:是'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`blur_profile_card\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`is_status_public\``);
    }
}
