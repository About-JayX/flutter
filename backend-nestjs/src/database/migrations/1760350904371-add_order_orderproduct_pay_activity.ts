import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOrderOrderproductPayActivity1760350904371 implements MigrationInterface {
    name = 'AddOrderOrderproductPayActivity1760350904371'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_product\` (\`create_time\` timestamp(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`update_time\` timestamp(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`delete_time\` timestamp(0) NULL COMMENT '删除时间', \`id\` int NOT NULL AUTO_INCREMENT COMMENT '商品ID', \`product_sku_id\` int NOT NULL COMMENT '商品SKU ID', \`product_type\` varchar(255) NOT NULL COMMENT '商品类型' DEFAULT 'all', \`product_type_name\` varchar(255) NOT NULL COMMENT '商品类型' DEFAULT '全品类', \`product_name\` varchar(255) NOT NULL COMMENT '商品名称', \`product_des\` varchar(500) NULL COMMENT '商品描述', \`product_attrs\` json NULL COMMENT '商品属性', \`product_price\` decimal(10,2) NOT NULL COMMENT '商品单价', \`product_image\` varchar(500) NULL COMMENT '商品图片', PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`bussinesstype\` text NOT NULL COMMENT '业务类型来源，比如petihope代表业务类型来源为：请愿'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`bussinessid\` bigint NOT NULL COMMENT '业务类型来源ID'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`receiver_addr\` varchar(500) NOT NULL COMMENT '收货地址' DEFAULT '地球'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`valid_time\` timestamp(2) NOT NULL COMMENT '订单有效时间'`);
        await queryRunner.query(`ALTER TABLE \`app_activity\` ADD \`bussinesstype\` text NOT NULL COMMENT '业务类型来源，比如petihope代表业务类型来源为：请愿'`);
        await queryRunner.query(`ALTER TABLE \`app_activity\` ADD \`bussinessid\` bigint NOT NULL COMMENT '业务类型来源ID'`);
        await queryRunner.query(`ALTER TABLE \`app_order_product\` CHANGE \`create_time\` \`create_time\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_order_product\` CHANGE \`update_time\` \`update_time\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`create_time\` \`create_time\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`update_time\` \`update_time\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`create_time\` \`create_time\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`update_time\` \`update_time\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`update_time\` \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`create_time\` \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`update_time\` \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`create_time\` \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_order_product\` CHANGE \`update_time\` \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_order_product\` CHANGE \`create_time\` \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_activity\` DROP COLUMN \`bussinessid\``);
        await queryRunner.query(`ALTER TABLE \`app_activity\` DROP COLUMN \`bussinesstype\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`valid_time\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`receiver_addr\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`bussinessid\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`bussinesstype\``);
        await queryRunner.query(`DROP TABLE \`app_product\``);
    }

}
