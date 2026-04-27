import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOoPriEtc1774317697197 implements MigrationInterface {
    name = 'UpdateOoPriEtc1774317697197'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`is_open_res_location\` tinyint UNSIGNED NOT NULL COMMENT '是否响应时添加当前位置: 1=是, 0=否' DEFAULT '1'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`is_open_res_location\``);
    }

}
