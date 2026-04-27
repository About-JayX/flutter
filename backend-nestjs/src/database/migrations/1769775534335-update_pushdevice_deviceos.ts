import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdatePushdeviceDeviceos1769775534335 implements MigrationInterface {
    name = 'UpdatePushdeviceDeviceos1769775534335'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_user_push_device\` ADD \`device_os\` varchar(64) NOT NULL COMMENT '操作系统' DEFAULT 'android'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_user_push_device\` DROP COLUMN \`device_os\``);
    }

}
