import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateNewsuserunreadlevel1770024781243 implements MigrationInterface {
    name = 'UpdateNewsuserunreadlevel1770024781243'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` ADD \`biz_type\` varchar(32) NOT NULL COMMENT '业务类型（chat/group/order）'`);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` ADD \`biz_id\` varchar(64) NOT NULL COMMENT '业务ID（与message_core.biz_id一致）'`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\` (\`user_id\`, \`biz_type\`, \`biz_id\`)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` DROP COLUMN \`biz_id\``);
        await queryRunner.query(`ALTER TABLE \`app_news_status_user_unread_level\` DROP COLUMN \`biz_type\``);
        await queryRunner.query(`CREATE UNIQUE INDEX \`idx_user_biz_level\` ON \`app_news_status_user_unread_level\` (\`user_id\`, \`level_id\`)`);
    }

}
