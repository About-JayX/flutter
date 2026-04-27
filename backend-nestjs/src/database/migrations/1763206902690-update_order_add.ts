import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrderAdd1763206902690 implements MigrationInterface {
    name = 'UpdateOrderAdd1763206902690'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`valid_pay_time\` timestamp(2) NOT NULL COMMENT '订单支付的有效时间,第三方支付订单过期时间'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`manual_review\` tinyint NOT NULL DEFAULT 0`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`order_error_remark\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`wait_check_retry_count\` int NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`last_wait_check_at\` datetime NULL`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`close_attempted\` tinyint NOT NULL DEFAULT 0`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`close_attempted\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`last_wait_check_at\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`wait_check_retry_count\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`order_error_remark\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`manual_review\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`valid_pay_time\``);
    }

}
