import { MigrationInterface, QueryRunner } from "typeorm";

export class AddWithdraw1761003696179 implements MigrationInterface {
    name = 'AddWithdraw1761003696179'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_withdraw\` (\`create_time\` timestamp(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`update_time\` timestamp(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`delete_time\` timestamp(0) NULL COMMENT '删除时间', \`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`unique_id\` varchar(255) NOT NULL, \`withdraw_sn\` varchar(64) NOT NULL COMMENT '提现流水号/订单号', \`user_id\` bigint NOT NULL COMMENT '用户id', \`user_uni_id\` varchar(64) NOT NULL COMMENT '用户唯一编号', \`amount\` decimal(10,2) NOT NULL, \`actual_amount\` decimal(10,2) NOT NULL, \`withdraw_ratio\` decimal(5,4) NOT NULL DEFAULT '0.0000', \`status\` varchar(20) NOT NULL DEFAULT 'pending', \`channel\` varchar(20) NOT NULL DEFAULT 'alipay', \`transaction_id\` varchar(64) NULL COMMENT '第三方交易号，第三方唯一编号', \`account_no_encrypted\` varchar(100) NULL, \`account_no_masked\` varchar(100) NULL, \`account_name\` varchar(50) NULL, \`fail_reason\` varchar(500) NULL, INDEX \`IDX_1e967a4268e5e9fd7be494fb63\` (\`user_id\`), UNIQUE INDEX \`IDX_8818996b9f6438f8f85704033e\` (\`withdraw_sn\`), UNIQUE INDEX \`IDX_3c68fe0fdb9b7c34f1f262ff39\` (\`transaction_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_3c68fe0fdb9b7c34f1f262ff39\` ON \`app_withdraw\``);
        await queryRunner.query(`DROP INDEX \`IDX_8818996b9f6438f8f85704033e\` ON \`app_withdraw\``);
        await queryRunner.query(`DROP INDEX \`IDX_1e967a4268e5e9fd7be494fb63\` ON \`app_withdraw\``);
        await queryRunner.query(`DROP TABLE \`app_withdraw\``);
    }

}
