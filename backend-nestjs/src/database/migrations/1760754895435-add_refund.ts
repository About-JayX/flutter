import { MigrationInterface, QueryRunner } from "typeorm";

export class AddRefund1760754895435 implements MigrationInterface {
    name = 'AddRefund1760754895435'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_refund\` (\`create_time\` timestamp(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`update_time\` timestamp(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`delete_time\` timestamp(0) NULL COMMENT '删除时间', \`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`refund_no\` varchar(64) NOT NULL COMMENT '退款单号，系统生成，唯一标识', \`order_sn\` varchar(64) NOT NULL COMMENT '关联的订单编号', \`user_id\` bigint NOT NULL COMMENT '退款用户ID', \`refund_amount\` decimal(10,2) NOT NULL COMMENT '总退款金额（单位：元），精确到分', \`product_amount\` decimal(10,2) NULL COMMENT '商品退款金额', \`shipping_amount\` decimal(10,2) NULL COMMENT '运费退款金额', \`discount_refunded\` decimal(10,2) NOT NULL COMMENT '退还的优惠金额（如优惠券、积分等）' DEFAULT '0.00', \`refund_type\` tinyint UNSIGNED NOT NULL COMMENT '退款类型: 0=全额, 1=部分' DEFAULT '0', \`status\` tinyint UNSIGNED NOT NULL COMMENT '退款状态: 0=待处理, 1=已同意, 2=已拒绝, 3=已退款, 4=失败, 5=已取消' DEFAULT '0', \`reason\` varchar(100) NOT NULL COMMENT '退款原因（如：商品损坏、不想要了等）', \`description\` text NULL COMMENT '用户提交的退款说明或描述', \`admin_remark\` text NULL COMMENT '管理员/客服备注', \`evidence_images\` json NULL COMMENT '退款凭证图片链接数组，如 ["https://...", "..."]', \`refund_method\` tinyint UNSIGNED NOT NULL COMMENT '退款方式: 0=原路退回, 1=退回钱包, 2=银行转账' DEFAULT '0', \`channel_refund_no\` varchar(128) NULL COMMENT '第三方渠道退款单号（如微信 refund_id）', \`channel_response\` text NULL COMMENT '第三方退款接口原始响应（用于排查问题）', \`applied_time\` timestamp(3) NULL COMMENT '用户申请退款时间', \`approved_time\` timestamp(3) NULL COMMENT '审核通过时间', \`refunded_time\` timestamp(3) NULL COMMENT '实际退款成功时间（第三方回调）', UNIQUE INDEX \`IDX_c56505303e9d1e42a4b3539283\` (\`refund_no\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_c56505303e9d1e42a4b3539283\` ON \`app_refund\``);
        await queryRunner.query(`DROP TABLE \`app_refund\``);
    }

}
