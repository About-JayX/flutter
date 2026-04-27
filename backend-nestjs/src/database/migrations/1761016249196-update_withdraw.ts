import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateWithdraw1761016249196 implements MigrationInterface {
    name = 'UpdateWithdraw1761016249196'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE INDEX \`IDX_591bb30bc5f571aac64dcd0647\` ON \`app_withdraw\` (\`user_id\`, \`status\`)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_591bb30bc5f571aac64dcd0647\` ON \`app_withdraw\``);
    }

}
