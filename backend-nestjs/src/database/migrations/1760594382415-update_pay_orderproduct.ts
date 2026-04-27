import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdatePayOrderproduct1760594382415 implements MigrationInterface {
    name = 'UpdatePayOrderproduct1760594382415'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_pay\` ADD UNIQUE INDEX \`IDX_3fe86622650a06e79d05215c1e\` (\`transaction_id\`)`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`IDX_a6f72d5f142a2e09ccfaad65ab\` ON \`app_order_product\` (\`order_id\`, \`product_id\`)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_a6f72d5f142a2e09ccfaad65ab\` ON \`app_order_product\``);
        await queryRunner.query(`ALTER TABLE \`app_pay\` DROP INDEX \`IDX_3fe86622650a06e79d05215c1e\``);
    }

}
