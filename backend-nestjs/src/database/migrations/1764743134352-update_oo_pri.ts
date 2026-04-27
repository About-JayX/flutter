import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOoPri1764743134352 implements MigrationInterface {
    name = 'UpdateOoPri1764743134352'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_location\` json NULL COMMENT '申请进入现场的详细地址'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_distance\` decimal(10,2) NULL COMMENT '申请进入现场时的距离（单位：米），null 表示未记录'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_res_time\` timestamp(3) NULL COMMENT '成员申请进入现场发起人回应时间'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_res_des\` longtext NULL COMMENT '成员申请进入现场发起人回应内容'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_res_valid_time\` timestamp(3) NULL COMMENT '发起人回应有效时间'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_res_valid_time\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_res_des\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_res_time\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_distance\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_location\``);
    }

}
