import { MigrationInterface, QueryRunner } from "typeorm";

export class AddNewsStatusLevelUpdateMore1770021223334 implements MigrationInterface {
    name = 'AddNewsStatusLevelUpdateMore1770021223334'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_news_status_user\` DROP FOREIGN KEY \`FK_09bbe1328ffcb34db8228ecbd34\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` DROP FOREIGN KEY \`FK_1931795e90b6e25ed7700816a98\``);
        await queryRunner.query(`DROP INDEX \`idx_user_code\` ON \`app_news_status_user_unread\``);
        await queryRunner.query(`DROP INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\``);
        await queryRunner.query(`CREATE TABLE \`app_news_status_level\` (\`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '映射记录唯一主键ID', \`level_type\` varchar(32) NOT NULL COMMENT '层级类型（chat/group/order）', \`parent_id\` bigint NULL COMMENT '父层级ID：顶级为NULL', \`create_time\` datetime(6) NOT NULL COMMENT '记录创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`update_time\` datetime(6) NOT NULL COMMENT '记录更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), PRIMARY KEY (\`id\`)) ENGINE=InnoDB COMMENT="消息层级映射表-用户消息数量层级映射依据"`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_main\` ADD \`is_deleted\` tinyint NOT NULL COMMENT '软删除标记：1=有效（未删），0=失效（已删）' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_main\` ADD \`delete_time\` datetime NULL COMMENT '软删除时间'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` ADD \`level_id\` bigint NOT NULL COMMENT '关联消息层级表的主键ID'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` ADD \`is_deleted\` tinyint NOT NULL COMMENT '软删除标记：1=有效（未删），0=失效（已删）' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` ADD \`delete_time\` datetime NULL COMMENT '软删除时间'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` CHANGE \`level_id\` \`level_id\` bigint NOT NULL COMMENT '关联消息层级表的主键ID'`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\` (\`user_id\`, \`level_id\`)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` CHANGE \`level_id\` \`level_id\` bigint NOT NULL COMMENT '关联message_unread_level的叶子层级主键ID'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` DROP COLUMN \`delete_time\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` DROP COLUMN \`is_deleted\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` DROP COLUMN \`level_id\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_main\` DROP COLUMN \`delete_time\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_main\` DROP COLUMN \`is_deleted\``);
        await queryRunner.query(`DROP TABLE \`app_news_status_level\``);
        await queryRunner.query(`CREATE UNIQUE INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\` (\`user_id\`, \`biz_type\`, \`biz_id\`)`);
        await queryRunner.query(`CREATE INDEX \`idx_user_code\` ON \`app_news_status_user_unread\` (\`user_id\`, \`level_code\`)`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` ADD CONSTRAINT \`FK_1931795e90b6e25ed7700816a98\` FOREIGN KEY (\`level_id\`) REFERENCES \`app_news_status_user_unread\`(\`id\`) ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user\` ADD CONSTRAINT \`FK_09bbe1328ffcb34db8228ecbd34\` FOREIGN KEY (\`message_id\`) REFERENCES \`app_news_status_main\`(\`id\`) ON DELETE CASCADE ON UPDATE NO ACTION`);
    }

}
