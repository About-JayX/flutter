import { MigrationInterface, QueryRunner } from "typeorm";

export class AddNewsStatusFourTables1769587232232 implements MigrationInterface {
    name = 'AddNewsStatusFourTables1769587232232'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_news_status_main\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '消息唯一主键ID', \`biz_type\` varchar(32) NOT NULL COMMENT '业务类型：chat-一对一、group-群聊、order-订单', \`biz_id\` varchar(64) NOT NULL COMMENT '业务ID：与biz_type配合唯一标识业务实体', \`title\` varchar(128) NOT NULL COMMENT '消息标题' DEFAULT '', \`content\` text NOT NULL COMMENT '消息内容', \`sender_id\` varchar(64) NOT NULL COMMENT '发送方唯一标识', \`is_publish\` tinyint NOT NULL COMMENT '是否发布：0-未发布，1-已发布' DEFAULT '1', \`send_time\` datetime NOT NULL COMMENT '消息发送时间' DEFAULT CURRENT_TIMESTAMP, \`create_time\` datetime(6) NOT NULL COMMENT '记录创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '记录更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`idx_biz_type\` (\`biz_type\`), INDEX \`idx_biz_id\` (\`biz_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB COMMENT="消息主表-存储全局唯一消息本体，所有设备/用户共享"`);
        await queryRunner.query(`CREATE TABLE \`app_news_status_user\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '触达记录唯一主键ID', \`message_id\` bigint NOT NULL COMMENT '关联message_core的主键ID', \`user_id\` varchar(64) NOT NULL COMMENT '用户唯一标识ID', \`read_status\` tinyint NOT NULL COMMENT '触达状态：0-未读，1-已读' DEFAULT '0', \`read_time\` datetime NULL COMMENT '消息标记已读时间（NULL表示未读）', \`reach_time\` datetime NOT NULL COMMENT '消息触达用户时间' DEFAULT CURRENT_TIMESTAMP, \`create_time\` datetime(6) NOT NULL COMMENT '记录创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '记录更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`idx_user_read_status\` (\`user_id\`, \`read_status\`), UNIQUE INDEX \`idx_msg_user\` (\`message_id\`, \`user_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB COMMENT="消息-用户触达记录表-记录消息对用户的触达状态（未读/已读）"`);
        await queryRunner.query(`CREATE TABLE \`app_news_status_user_unread\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '层级唯一主键ID', \`user_id\` varchar(64) NOT NULL COMMENT '用户唯一标识ID', \`level_name\` varchar(64) NOT NULL COMMENT '层级名称', \`level_code\` varchar(64) NOT NULL COMMENT '层级唯一编码' DEFAULT '', \`parent_level_id\` bigint NULL COMMENT '父层级ID：顶级为NULL', \`unread_count\` int NOT NULL COMMENT '层级未读消息总数' DEFAULT '0', \`create_time\` datetime(6) NOT NULL COMMENT '记录创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '记录更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`idx_user_code\` (\`user_id\`, \`level_code\`), INDEX \`idx_user_parent\` (\`user_id\`, \`parent_level_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB COMMENT="用户层级式未读数量表-按用户管理层级关系+未读总数"`);
        await queryRunner.query(`CREATE TABLE \`app_news_status_user_unread_level\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '映射记录唯一主键ID', \`user_id\` varchar(64) NOT NULL COMMENT '用户唯一标识ID', \`biz_type\` varchar(32) NOT NULL COMMENT '业务类型（chat/group/order）', \`biz_id\` varchar(64) NOT NULL COMMENT '业务ID（与message_core.biz_id一致）', \`level_id\` bigint NOT NULL COMMENT '关联message_unread_level的叶子层级主键ID', \`create_time\` datetime(6) NOT NULL COMMENT '记录创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '记录更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), UNIQUE INDEX \`idx_user_biz_level\` (\`user_id\`, \`biz_type\`, \`biz_id\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB COMMENT="用户-业务层级映射表-建立业务与用户叶子层级的唯一映射"`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user\` ADD CONSTRAINT \`FK_09bbe1328ffcb34db8228ecbd34\` FOREIGN KEY (\`message_id\`) REFERENCES \`app_news_status_main\`(\`id\`) ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` ADD CONSTRAINT \`FK_1931795e90b6e25ed7700816a98\` FOREIGN KEY (\`level_id\`) REFERENCES \`app_news_status_user_unread\`(\`id\`) ON DELETE CASCADE ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` DROP FOREIGN KEY \`FK_1931795e90b6e25ed7700816a98\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user\` DROP FOREIGN KEY \`FK_09bbe1328ffcb34db8228ecbd34\``);
        await queryRunner.query(`DROP INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\``);
        await queryRunner.query(`DROP TABLE \`app_news_status_user_unread_level\``);
        await queryRunner.query(`DROP INDEX \`idx_user_parent\` ON \`app_news_status_user_unread\``);
        await queryRunner.query(`DROP INDEX \`idx_user_code\` ON \`app_news_status_user_unread\``);
        await queryRunner.query(`DROP TABLE \`app_news_status_user_unread\``);
        await queryRunner.query(`DROP INDEX \`idx_msg_user\` ON \`app_news_status_user\``);
        await queryRunner.query(`DROP INDEX \`idx_user_read_status\` ON \`app_news_status_user\``);
        await queryRunner.query(`DROP TABLE \`app_news_status_user\``);
        await queryRunner.query(`DROP INDEX \`idx_biz_id\` ON \`app_news_status_main\``);
        await queryRunner.query(`DROP INDEX \`idx_biz_type\` ON \`app_news_status_main\``);
        await queryRunner.query(`DROP TABLE \`app_news_status_main\``);
    }

}
