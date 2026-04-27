import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOoFunEtcAndUpdateOoPriEtc1764159824081 implements MigrationInterface {
    name = 'AddOoFunEtcAndUpdateOoPriEtc1764159824081'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`app_oo_fun\` (\`create_time\` timestamp(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`update_time\` timestamp(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`delete_time\` timestamp(0) NULL COMMENT '删除时间', \`id\` int NOT NULL AUTO_INCREMENT COMMENT '功能ID', \`unique_id\` varchar(255) NOT NULL, \`show\` tinyint NOT NULL COMMENT '是否显示或运用，1：是，0:隐藏' DEFAULT '1', \`type\` varchar(255) NOT NULL COMMENT '功能类型' DEFAULT 'all', \`name\` varchar(255) NOT NULL COMMENT '功能名称,字母小写', \`title\` varchar(255) NOT NULL COMMENT '功能标题, 本地化名称', \`des\` varchar(500) NULL COMMENT '功能描述', \`image\` varchar(500) NULL COMMENT '功能图片，可为空', PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_news_status\` (\`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`uniqid\` char(40) NULL, \`type\` varchar(5000) NOT NULL, \`typesource\` varchar(225) NOT NULL, \`userid\` bigint UNSIGNED NOT NULL, \`objid\` bigint NULL, \`readsourceidlist\` longtext NULL, \`isread\` int UNSIGNED NOT NULL DEFAULT '0', \`createtime\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`updatetime\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \`readtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, \`readid\` bigint UNSIGNED NULL, \`status\` int NOT NULL DEFAULT '1', PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_oo_news\` (\`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`uniqid\` char(40) NULL, \`oid\` bigint UNSIGNED NOT NULL, \`type\` varchar(500) NOT NULL DEFAULT 'oernews', \`con\` longtext NOT NULL, \`top\` int UNSIGNED NOT NULL DEFAULT '0', \`createtime\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, \`updatetime\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`app_user_first_action\` (\`id\` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \`user_id\` bigint UNSIGNED NOT NULL, \`action_type\` varchar(64) NOT NULL COMMENT '第一次的各种类型，字母小写', \`createtime\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (\`id\`, \`action_type\`)) ENGINE=InnoDB`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_nick_name\` varchar(25) NULL COMMENT '成员进入现场自定义称呼'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_phone\` bigint UNSIGNED NULL COMMENT '成员进入现场联系方式'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` ADD \`post_scene_des\` longtext NULL COMMENT '成员进入现场描述'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`auto_response\` \`auto_response\` tinyint UNSIGNED NOT NULL COMMENT '是否开启自动响应，0: 不开启，1: 开启' DEFAULT '1'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`auto_response\` \`auto_response\` tinyint UNSIGNED NOT NULL COMMENT '是否开启自动响应，0: 不开启，1: 开启' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_des\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_phone\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` DROP COLUMN \`post_scene_nick_name\``);
        await queryRunner.query(`DROP TABLE \`app_user_first_action\``);
        await queryRunner.query(`DROP TABLE \`app_oo_news\``);
        await queryRunner.query(`DROP TABLE \`app_news_status\``);
        await queryRunner.query(`DROP TABLE \`app_oo_fun\``);
    }

}
