import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateUserPhonenum1767257667789 implements MigrationInterface {
    name = 'UpdateUserPhonenum1767257667789'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`phonenum\` \`phonenum\` bigint UNSIGNED NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`phonenum\` \`phonenum\` bigint UNSIGNED NOT NULL`);
    }

}
