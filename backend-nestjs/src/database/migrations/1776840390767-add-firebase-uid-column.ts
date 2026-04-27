import { MigrationInterface, QueryRunner } from "typeorm";

export class AddFirebaseUidColumn1776840390767 implements MigrationInterface {
    name = 'AddFirebaseUidColumn1776840390767'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`firebaseUid\` varchar(225) NULL COMMENT 'Firebase用户ID'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`firebaseUid\``);
    }
}