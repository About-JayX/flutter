import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOoApp1761479500487 implements MigrationInterface {
    name = 'AddOoApp1761479500487'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`location_map\` json NULL COMMENT ' 现场的地址地图，结构: {longitude, latitude, province, city, ...}'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`address\` longtext NULL COMMENT '用户自定义详细地址精确到小区，公寓，门牌号'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`nickname\` varchar(25) NOT NULL COMMENT '发起人自定义称呼' DEFAULT '发起人'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`contact\` json NULL COMMENT '发起人联系方式'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`oerid\` \`oerid\` int(11) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`people_with_me_number\` \`people_with_me_number\` int(8) UNSIGNED NOT NULL COMMENT '参与的用户数上限' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`publicstatus\` \`publicstatus\` int(10) UNSIGNED NOT NULL COMMENT '0:私密 1：表示公开' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`obackid\` \`obackid\` int(11) NOT NULL DEFAULT '17'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`obacktype\` \`obacktype\` int(10) UNSIGNED NOT NULL COMMENT '0:代表系统壁纸 1：代表上传壁纸' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`push\` \`push\` int(11) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`enablepicwalls\` \`enablepicwalls\` int(10) UNSIGNED NULL COMMENT '0:私密 1：表示公开' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`newstop\` \`newstop\` bigint(20) UNSIGNED NULL COMMENT '置顶消息id'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`newsnum\` \`newsnum\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`endtimemorecount\` \`endtimemorecount\` int(11) NOT NULL DEFAULT '5'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`endtimestatus\` \`endtimestatus\` int(11) NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`end\` \`end\` int(10) UNSIGNED NOT NULL COMMENT '1：行动被删除了0：未被删除' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`close\` \`close\` int(11) NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`deletedestroy\` \`deletedestroy\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`hot\` \`hot\` int(10) UNSIGNED NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`xiangyinstatus\` \`xiangyinstatus\` int(11) NOT NULL DEFAULT '3'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`refusexiangyinanimaid\` \`refusexiangyinanimaid\` int(10) UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`sceneusernums\` \`sceneusernums\` int(11) NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`service\` \`service\` longtext NULL COMMENT '服务'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`oerinfos\` \`oerinfos\` longtext NULL COMMENT '发起者们'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`oerinfos\` \`oerinfos\` longtext CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NOT NULL COMMENT '发起者们'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`service\` \`service\` longtext CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NOT NULL COMMENT '服务'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`sceneusernums\` \`sceneusernums\` int NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`refusexiangyinanimaid\` \`refusexiangyinanimaid\` int UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`xiangyinstatus\` \`xiangyinstatus\` int NOT NULL DEFAULT '3'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`hot\` \`hot\` int UNSIGNED NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`deletedestroy\` \`deletedestroy\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`close\` \`close\` int NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`end\` \`end\` int UNSIGNED NOT NULL COMMENT '1：行动被删除了0：未被删除' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`endtimestatus\` \`endtimestatus\` int NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`endtimemorecount\` \`endtimemorecount\` int NOT NULL DEFAULT '5'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`newsnum\` \`newsnum\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`newstop\` \`newstop\` bigint UNSIGNED NULL COMMENT '置顶消息id'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`enablepicwalls\` \`enablepicwalls\` int UNSIGNED NULL COMMENT '0:私密 1：表示公开' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`push\` \`push\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`obacktype\` \`obacktype\` int UNSIGNED NOT NULL COMMENT '0:代表系统壁纸 1：代表上传壁纸' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`obackid\` \`obackid\` int NOT NULL DEFAULT '17'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`publicstatus\` \`publicstatus\` int UNSIGNED NOT NULL COMMENT '0:私密 1：表示公开' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`people_with_me_number\` \`people_with_me_number\` int UNSIGNED NOT NULL COMMENT '参与的用户数上限' DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`oerid\` \`oerid\` int NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`contact\``);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`nickname\``);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`address\``);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`location_map\``);
    }

}
