import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateFollowsReportdbReportuser1768190589169 implements MigrationInterface {
    name = 'CreateFollowsReportdbReportuser1768190589169'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_follows\` CHANGE \`createtime\` \`createtime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_follows\` CHANGE \`updatetime\` \`updatetime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_report_db\` CHANGE \`type\` \`type\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_report_db\` CHANGE \`createtime\` \`createtime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_report_db\` CHANGE \`updatetime\` \`updatetime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`userid\` \`userid\` bigint UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`status\` \`status\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`createtime\` \`createtime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`updatetime\` \`updatetime\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`status\` \`status\` int UNSIGNED NOT NULL COMMENT '0：未处理1：处理完成' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_report_user\` CHANGE \`userid\` \`userid\` bigint UNSIGNED NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_report_db\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_report_db\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_report_db\` CHANGE \`type\` \`type\` int UNSIGNED NOT NULL COMMENT '举报的类型 0代表内容' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_follows\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_follows\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
    }

}
