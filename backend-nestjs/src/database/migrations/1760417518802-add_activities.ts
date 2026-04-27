import { MigrationInterface, QueryRunner } from "typeorm";

export class AddActivities1760417518802 implements MigrationInterface {
    name = 'AddActivities1760417518802'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_activities\` (\`create_time\` timestamp(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`update_time\` timestamp(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`delete_time\` timestamp(0) NULL COMMENT '删除时间', \`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`unique_id\` varchar(255) NOT NULL, \`end_time\` timestamp(2) NOT NULL COMMENT '任务延迟的执行时间', \`bussiness_id\` bigint NOT NULL COMMENT '业务类型来源ID', \`bussiness_type\` varchar(255) NOT NULL COMMENT '业务类型来源，例子：petihope_end_time', \`status\` varchar(255) NOT NULL DEFAULT 'pending', \`title\` varchar(100) NOT NULL, \`desc\` varchar(500) NULL, PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
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
        await queryRunner.query(`DROP TABLE \`app_activities\``);
    }

}
