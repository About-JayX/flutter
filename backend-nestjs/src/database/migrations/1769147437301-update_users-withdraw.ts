import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateUsersWithdraw1769147437301 implements MigrationInterface {
    name = 'UpdateUsersWithdraw1769147437301'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`alipay_openphone_encrypted\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_withdraw\` ADD \`channel_opendid\` varchar(64) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_withdraw\` ADD \`channel_openphone_encrypted\` varchar(255) NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_withdraw\` DROP COLUMN \`channel_openphone_encrypted\``);
        await queryRunner.query(`ALTER TABLE \`app_withdraw\` DROP COLUMN \`channel_opendid\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`alipay_openphone_encrypted\``);
    }

}
