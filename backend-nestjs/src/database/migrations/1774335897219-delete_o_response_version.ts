import { MigrationInterface, QueryRunner } from "typeorm";

export class DeleteOResponseVersion1774335897219 implements MigrationInterface {
    name = 'DeleteOResponseVersion1774335897219'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_o_response_chats\` DROP COLUMN \`version\``);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_o_response_chats\` ADD \`version\` int NOT NULL`);
    }

}
