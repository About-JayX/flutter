import { MigrationInterface, QueryRunner } from "typeorm";

export class AddDivideUpdateActivities1760685731262 implements MigrationInterface {
    name = 'AddDivideUpdateActivities1760685731262'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_divide_summary\` (\`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`unique_id\` varchar(255) NOT NULL, \`business_id\` bigint NOT NULL COMMENT '业务类型来源ID，名称为businessType指定的表对应的：id', \`business_type\` varchar(255) NOT NULL COMMENT '业务类型来源，名称为表名' DEFAULT 'app_oo', \`userId\` varchar(255) NOT NULL, \`totalSourceAmount\` decimal(12,2) NOT NULL, \`divideRatio\` decimal(5,4) NOT NULL, \`totalDivideAmount\` decimal(12,2) NOT NULL, \`platformAmount\` decimal(12,2) NOT NULL DEFAULT '0.00', \`status\` varchar(255) NOT NULL DEFAULT 'success', \`divideTime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), \`updateTime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), \`remark\` text NULL, \`isDeleted\` tinyint NOT NULL DEFAULT 0, INDEX \`IDX_d5fb8d72af7a8bcfc35e36a784\` (\`business_id\`), INDEX \`IDX_4efac52d41820607c5c239b96e\` (\`business_type\`), INDEX \`IDX_d25f2ddfaa75081c2593e03b0b\` (\`userId\`), INDEX \`IDX_40e2166cc321d7ded51f5e380d\` (\`status\`), UNIQUE INDEX \`IDX_67a68e699b0284e2313460d988\` (\`business_type\`, \`business_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_divide_record\` (\`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`unique_id\` varchar(255) NOT NULL, \`business_id\` bigint NOT NULL COMMENT '业务类型来源ID，名称为businessType指定的表对应的：id', \`business_type\` varchar(255) NOT NULL COMMENT '业务类型来源，名称为表名' DEFAULT 'app_oo', \`userId\` varchar(255) NOT NULL, \`orderId\` varchar(255) NULL, \`payId\` varchar(255) NULL, \`originAmount\` decimal(10,2) NOT NULL, \`divideRatio\` decimal(5,4) NOT NULL, \`divideAmount\` decimal(10,2) NOT NULL, \`platformAmount\` decimal(10,2) NOT NULL, \`status\` varchar(255) NOT NULL DEFAULT 'success', \`divideTime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), \`remark\` text NULL, \`isDeleted\` tinyint NOT NULL DEFAULT 0, INDEX \`IDX_a5ef4834efdc9f0e5145763e6a\` (\`business_id\`), INDEX \`IDX_7ba4856d0c517f67d5a37d3797\` (\`business_type\`), INDEX \`IDX_4fe2c62fd0c30dfe6aef659d84\` (\`userId\`), INDEX \`IDX_041c6e9b46f24ef2651100044d\` (\`orderId\`), INDEX \`IDX_9bbe809ee8b8bd3aa8e2eeee6e\` (\`payId\`), INDEX \`IDX_d6710de322df942e3979b7508d\` (\`status\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`ALTER TABLE \`app_product\` ADD \`unique_id\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` ADD \`unique_id\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`unique_id\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_activities\` CHANGE \`bussiness_id\` \`bussiness_id\` bigint NOT NULL COMMENT '业务类型来源ID，名称为bussinessType指定的表对应的：id'`);
        await queryRunner.query(`ALTER TABLE \`app_activities\` CHANGE \`bussiness_type\` \`bussiness_type\` varchar(255) NOT NULL COMMENT '业务类型来源，名称为表名' DEFAULT 'app_oo'`);
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`pay_method\` \`pay_method\` varchar(20) NOT NULL COMMENT '支付方式: alipay:支付宝；wechat: 微信支付' DEFAULT 'alipay'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_pay\` CHANGE \`pay_method\` \`pay_method\` varchar(20) NOT NULL COMMENT '支付方式'`);
        await queryRunner.query(`ALTER TABLE \`app_activities\` CHANGE \`bussiness_type\` \`bussiness_type\` varchar(255) NOT NULL COMMENT '业务类型来源，例子：petihope_end_time'`);
        await queryRunner.query(`ALTER TABLE \`app_activities\` CHANGE \`bussiness_id\` \`bussiness_id\` bigint NOT NULL COMMENT '业务类型来源ID'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`unique_id\``);
        await queryRunner.query(`ALTER TABLE \`app_pay\` DROP COLUMN \`unique_id\``);
        await queryRunner.query(`ALTER TABLE \`app_product\` DROP COLUMN \`unique_id\``);
        await queryRunner.query(`DROP INDEX \`IDX_d6710de322df942e3979b7508d\` ON \`app_divide_record\``);
        await queryRunner.query(`DROP INDEX \`IDX_9bbe809ee8b8bd3aa8e2eeee6e\` ON \`app_divide_record\``);
        await queryRunner.query(`DROP INDEX \`IDX_041c6e9b46f24ef2651100044d\` ON \`app_divide_record\``);
        await queryRunner.query(`DROP INDEX \`IDX_4fe2c62fd0c30dfe6aef659d84\` ON \`app_divide_record\``);
        await queryRunner.query(`DROP INDEX \`IDX_7ba4856d0c517f67d5a37d3797\` ON \`app_divide_record\``);
        await queryRunner.query(`DROP INDEX \`IDX_a5ef4834efdc9f0e5145763e6a\` ON \`app_divide_record\``);
        await queryRunner.query(`DROP TABLE \`app_divide_record\``);
        await queryRunner.query(`DROP INDEX \`IDX_67a68e699b0284e2313460d988\` ON \`app_divide_summary\``);
        await queryRunner.query(`DROP INDEX \`IDX_40e2166cc321d7ded51f5e380d\` ON \`app_divide_summary\``);
        await queryRunner.query(`DROP INDEX \`IDX_d25f2ddfaa75081c2593e03b0b\` ON \`app_divide_summary\``);
        await queryRunner.query(`DROP INDEX \`IDX_4efac52d41820607c5c239b96e\` ON \`app_divide_summary\``);
        await queryRunner.query(`DROP INDEX \`IDX_d5fb8d72af7a8bcfc35e36a784\` ON \`app_divide_summary\``);
        await queryRunner.query(`DROP TABLE \`app_divide_summary\``);
    }

}
