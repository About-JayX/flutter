import { MigrationInterface, QueryRunner } from "typeorm";

export class AddNewsConSystem1769591340326 implements MigrationInterface {
    name = 'AddNewsConSystem1769591340326'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_news_con_system\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '系统消息唯一主键ID', \`title\` varchar(128) NOT NULL COMMENT '系统消息标题', \`des\` text NOT NULL COMMENT '系统消息描述/详细内容', \`msg_type\` varchar(32) NOT NULL COMMENT '消息类型：announcement-系统公告、update-版本更新、notice-全局通知' DEFAULT 'announcement', \`send_time\` datetime NOT NULL COMMENT '消息发送/发布时间（支持定时推送）' DEFAULT CURRENT_TIMESTAMP, \`is_enable\` tinyint NOT NULL COMMENT '是否启用：0-禁用（不展示），1-启用（展示）' DEFAULT '1', \`push_scope\` varchar(16) NOT NULL COMMENT '推送范围：all-全用户，partial-定向用户' DEFAULT 'all', \`jump_url\` varchar(255) NOT NULL COMMENT '消息跳转链接（可选）' DEFAULT '', \`create_time\` datetime(6) NOT NULL COMMENT '记录创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '记录更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`idx_type_status\` (\`msg_type\`, \`is_enable\`), INDEX \`idx_send_time\` (\`send_time\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB COMMENT="系统消息主表-存储全局系统消息本体"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`idx_send_time\` ON \`app_news_con_system\``);
        await queryRunner.query(`DROP INDEX \`idx_type_status\` ON \`app_news_con_system\``);
        await queryRunner.query(`DROP TABLE \`app_news_con_system\``);
    }

}
