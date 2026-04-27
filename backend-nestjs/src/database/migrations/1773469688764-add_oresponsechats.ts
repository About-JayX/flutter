import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOresponsechats1773469688764 implements MigrationInterface {
    name = 'AddOresponsechats1773469688764'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_o_response_chats\` (\`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`oid\` bigint UNSIGNED NOT NULL, \`send_user_id\` bigint UNSIGNED NOT NULL, \`accept_user_id\` bigint UNSIGNED NOT NULL, \`match_code\` bigint UNSIGNED NOT NULL COMMENT '等于发送方的ID', \`chat\` longtext CHARACTER SET "utf8mb4" COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '标题，解析emoji版本', \`location\` json NULL COMMENT ' 现场的地址地图，结构: {longitude, latitude, province, city, ...}', \`createtime\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`updatetime\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`version\` int NOT NULL, PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE \`app_o_response_chats\``);
    }

}
