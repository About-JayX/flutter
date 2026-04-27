import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateUser1764581740698 implements MigrationInterface {
    name = 'UpdateUser1764581740698'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`account_type\` varchar(100) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`phone_hash\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`phone_encrypted\` varchar(255) NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`phone_encrypted\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`phone_hash\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`account_type\``);
    }

}
