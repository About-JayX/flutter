import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOrderOrderproductPayActivity1760334571878 implements MigrationInterface {
    name = 'AddOrderOrderproductPayActivity1760334571878'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_order_product\` (\`id\` int NOT NULL AUTO_INCREMENT COMMENT '订单商品ID', \`order_id\` int NOT NULL COMMENT '订单ID', \`product_id\` int NOT NULL COMMENT '商品ID', \`product_sku_id\` int NOT NULL COMMENT '商品SKU ID', \`product_name\` varchar(255) NOT NULL COMMENT '商品名称', \`product_attrs\` json NULL COMMENT '商品属性', \`product_price\` decimal(10,2) NOT NULL COMMENT '商品单价', \`quantity\` int NOT NULL COMMENT '购买数量', \`total_price\` decimal(10,2) NOT NULL COMMENT '商品总价', \`product_image\` varchar(500) NULL COMMENT '商品图片', \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_pay\` (\`id\` int NOT NULL AUTO_INCREMENT COMMENT '支付ID', \`order_id\` int NOT NULL COMMENT '订单ID', \`pay_sn\` varchar(64) NOT NULL COMMENT '支付流水号', \`transaction_id\` varchar(64) NULL COMMENT '第三方交易号', \`pay_amount\` decimal(10,2) NOT NULL COMMENT '支付金额', \`pay_method\` varchar(20) NOT NULL COMMENT '支付方式', \`pay_status\` tinyint NOT NULL COMMENT '支付状态' DEFAULT '0', \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), \`pay_time\` datetime NULL COMMENT '支付时间', \`refund_id\` varchar(64) NULL COMMENT '退款交易号', \`refund_amount\` decimal(10,2) NOT NULL COMMENT '退款金额' DEFAULT '0.00', \`refund_time\` datetime NULL COMMENT '退款时间', UNIQUE INDEX \`IDX_8c4b6b1678c2a251c4364bf8db\` (\`pay_sn\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_order\` (\`id\` int NOT NULL AUTO_INCREMENT COMMENT '订单ID', \`order_sn\` varchar(64) NOT NULL COMMENT '订单编号', \`user_id\` int NOT NULL COMMENT '用户ID', \`order_status\` tinyint NOT NULL COMMENT '订单状态' DEFAULT '0', \`pay_status\` tinyint NOT NULL COMMENT '支付状态' DEFAULT '0', \`after_sales_status\` tinyint NOT NULL COMMENT '售后状态' DEFAULT '0', \`total_amount\` decimal(10,2) NOT NULL COMMENT '订单总金额', \`discount_amount\` decimal(10,2) NOT NULL COMMENT '优惠金额' DEFAULT '0.00', \`shipping_fee\` decimal(10,2) NOT NULL COMMENT '运费' DEFAULT '0.00', \`actual_amount\` decimal(10,2) NOT NULL COMMENT '实付金额', \`currency\` varchar(10) NOT NULL COMMENT '币种' DEFAULT 'CNY', \`receiver_name\` varchar(50) NOT NULL COMMENT '收货人姓名', \`receiver_phone\` varchar(20) NOT NULL COMMENT '收货人电话', \`receiver_address\` text NOT NULL COMMENT '收货地址', \`user_remark\` text NULL COMMENT '用户备注', \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), \`pay_time\` datetime NULL COMMENT '支付时间', \`cancel_time\` datetime NULL COMMENT '取消时间', \`complete_time\` datetime NULL COMMENT '完成时间', UNIQUE INDEX \`IDX_5bbec726f95bc952ad6a18740c\` (\`order_sn\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_activity\` (\`identity\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`id\` varchar(255) NOT NULL, \`title\` varchar(255) NOT NULL, \`description\` text NOT NULL, \`bussinestype\` text NOT NULL, \`bussinesid\` bigint NOT NULL, \`endTime\` timestamp NOT NULL, \`status\` enum ('pending', 'ongoing', 'completed', 'cancelled') NOT NULL DEFAULT 'pending', \`createdAt\` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP, \`updatedAt\` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (\`identity\`)) ENGINE=InnoDB`);
        await queryRunner.query(`ALTER TABLE \`app_order_product\` ADD CONSTRAINT \`FK_da3ad797bbf9e099be11b0e79a7\` FOREIGN KEY (\`order_id\`) REFERENCES \`app_order\`(\`id\`) ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` ADD CONSTRAINT \`FK_044cea23eab242633313b900ff0\` FOREIGN KEY (\`order_id\`) REFERENCES \`app_order\`(\`id\`) ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_pay\` DROP FOREIGN KEY \`FK_044cea23eab242633313b900ff0\``);
        await queryRunner.query(`ALTER TABLE \`app_order_product\` DROP FOREIGN KEY \`FK_da3ad797bbf9e099be11b0e79a7\``);
        await queryRunner.query(`DROP TABLE \`app_activity\``);
        await queryRunner.query(`DROP INDEX \`IDX_5bbec726f95bc952ad6a18740c\` ON \`app_order\``);
        await queryRunner.query(`DROP TABLE \`app_order\``);
        await queryRunner.query(`DROP INDEX \`IDX_8c4b6b1678c2a251c4364bf8db\` ON \`app_pay\``);
        await queryRunner.query(`DROP TABLE \`app_pay\``);
        await queryRunner.query(`DROP TABLE \`app_order_product\``);
    }

}
