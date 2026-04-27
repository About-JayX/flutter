import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateNews1770022686546 implements MigrationInterface {
    name = 'UpdateNews1770022686546'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`FK_1931795e90b6e25ed7700816a98\` ON \`app_news_status_user_unread_level\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` DROP COLUMN \`level_code\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` DROP COLUMN \`level_name\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` DROP COLUMN \`biz_id\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` DROP COLUMN \`biz_type\``);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` ADD \`biz_type\` varchar(32) NOT NULL COMMENT '业务类型（chat/group/order）'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` ADD \`biz_id\` varchar(64) NOT NULL COMMENT '业务ID（与message_core.biz_id一致）'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` ADD \`level_name\` varchar(64) NOT NULL COMMENT '层级名称'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread\` ADD \`level_code\` varchar(64) NOT NULL COMMENT '层级唯一编码' DEFAULT ''`);
        await queryRunner.query(`CREATE INDEX \`FK_1931795e90b6e25ed7700816a98\` ON \`app_news_status_user_unread_level\` (\`level_id\`)`);
    }

}
