import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdatePayUniqueset1760596982043 implements MigrationInterface {
    name = 'UpdatePayUniqueset1760596982043'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_8c4b6b1678c2a251c4364bf8db\` ON \`app_pay\``);
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`transaction_id\` \`transaction_id\` varchar(64) NOT NULL COMMENT '第三方交易号'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`transaction_id\` \`transaction_id\` varchar(64) NULL COMMENT '第三方交易号'`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`IDX_8c4b6b1678c2a251c4364bf8db\` ON \`app_pay\` (\`pay_sn\`)`);
    }

}
