import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrderValidPayTime1763279667190 implements MigrationInterface {
    name = 'UpdateOrderValidPayTime1763279667190'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`valid_pay_time\` \`valid_pay_time\` timestamp(2) NULL COMMENT '订单支付的有效时间,第三方支付订单过期时间'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`valid_pay_time\` \`valid_pay_time\` timestamp(2) NOT NULL COMMENT '订单支付的有效时间,第三方支付订单过期时间'`);
    }

}
