import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOResponseChats1774331721776 implements MigrationInterface {
    name = 'UpdateOResponseChats1774331721776'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_o_response_chats\` DROP COLUMN \`match_code\``);
        await queryRunner.query(`ALTER TABLE \`app_o_response_chats\` ADD \`match_code\` char(40) NOT NULL COMMENT '等于发送方的ID'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_o_response_chats\` DROP COLUMN \`match_code\``);
        await queryRunner.query(`ALTER TABLE \`app_o_response_chats\` ADD \`match_code\` bigint UNSIGNED NOT NULL COMMENT '等于发送方的ID'`);
    }

}
