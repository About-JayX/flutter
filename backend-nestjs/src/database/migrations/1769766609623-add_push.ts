import { MigrationInterface, QueryRunner } from "typeorm";

export class AddPush1769766609623 implements MigrationInterface {
    name = 'AddPush1769766609623'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_user_push_config\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID', \`user_id\` bigint NOT NULL COMMENT '关联用户主键ID', \`user_tags\` json NULL COMMENT '用户级标签（JSON数组，如["VIP","北京","90后"]）', \`push_switch\` tinyint NOT NULL COMMENT '全局推送开关：1-开启，0-关闭' DEFAULT '1', \`disturb_start\` varchar(8) NOT NULL COMMENT '免打扰开始时间' DEFAULT '23:00', \`disturb_end\` varchar(8) NOT NULL COMMENT '免打扰结束时间' DEFAULT '07:00', \`msg_push\` tinyint NOT NULL COMMENT '消息推送开关' DEFAULT '1', \`notice_push\` tinyint NOT NULL COMMENT '通知推送开关' DEFAULT '1', \`activity_push\` tinyint NOT NULL COMMENT '活动推送开关' DEFAULT '1', \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), UNIQUE INDEX \`IDX_3c9b60e886419a48d0dae788e0\` (\`user_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_user_push_device\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID', \`user_id\` bigint NOT NULL COMMENT '关联用户主键ID', \`rid\` varchar(64) NOT NULL COMMENT '设备推送唯一标识rid', \`alias\` varchar(64) NOT NULL COMMENT '设备推送别名（极光/个推alias）' DEFAULT '', \`tags\` json NULL COMMENT '设备级标签（JSON数组）', \`device_type\` tinyint NOT NULL COMMENT '设备类型', \`device_name\` varchar(64) NOT NULL COMMENT '设备名称' DEFAULT '', \`device_code\` varchar(128) NOT NULL COMMENT '设备唯一标识' DEFAULT '', \`push_channel\` tinyint NOT NULL COMMENT '推送渠道' DEFAULT '1', \`is_valid\` tinyint NOT NULL COMMENT '设备有效性' DEFAULT '1', \`invalid_time\` datetime NULL COMMENT '失效时间', \`create_time\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`idx_user_id\` (\`user_id\`), INDEX \`idx_rid\` (\`rid\`), INDEX \`idx_is_valid\` (\`is_valid\`), UNIQUE INDEX \`IDX_2f976bac107574694ad0a28b53\` (\`alias\`), UNIQUE INDEX \`IDX_b095b0e44cb6459a40157ef024\` (\`user_id\`, \`rid\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_b095b0e44cb6459a40157ef024\` ON \`app_user_push_device\``);
        await queryRunner.query(`DROP INDEX \`IDX_2f976bac107574694ad0a28b53\` ON \`app_user_push_device\``);
        await queryRunner.query(`DROP INDEX \`idx_is_valid\` ON \`app_user_push_device\``);
        await queryRunner.query(`DROP INDEX \`idx_rid\` ON \`app_user_push_device\``);
        await queryRunner.query(`DROP INDEX \`idx_user_id\` ON \`app_user_push_device\``);
        await queryRunner.query(`DROP TABLE \`app_user_push_device\``);
        await queryRunner.query(`DROP INDEX \`IDX_3c9b60e886419a48d0dae788e0\` ON \`app_user_push_config\``);
        await queryRunner.query(`DROP TABLE \`app_user_push_config\``);
    }

}
