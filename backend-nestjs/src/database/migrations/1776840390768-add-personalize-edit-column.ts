import { MigrationInterface, QueryRunner } from "typeorm";

export class AddPersonalizeEditColumn1776840390768 implements MigrationInterface {
    name = 'AddPersonalizeEditColumn1776840390768'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`personalize_edit\` int UNSIGNED NOT NULL DEFAULT '0' COMMENT '个性化编辑状态：0=未完成，1=已完成'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`personalize_edit\``);
    }
}
