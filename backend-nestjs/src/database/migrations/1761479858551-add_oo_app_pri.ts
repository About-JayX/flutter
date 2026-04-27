import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOoAppPri1761479858551 implements MigrationInterface {
    name = 'AddOoAppPri1761479858551'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`UK_oo_pri\` ON \`app_oo_pri\``);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`oerid\` \`oerid\` bigint(20) UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`status\` \`status\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`wand\` \`wand\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`joinin\` \`joinin\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`firenum\` \`firenum\` int(10) UNSIGNED NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`isdoor\` \`isdoor\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`collapsecompass\` \`collapsecompass\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`collapsecompassid\` \`collapsecompassid\` bigint(20) UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`sence\` \`sence\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`morelife\` \`morelife\` int(10) UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`cardphone\` \`cardphone\` bigint(20) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`cardupdatetime\` \`cardupdatetime\` int(11) NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`res\` \`res\` int(11) NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`xiangyinstatus\` \`xiangyinstatus\` int(10) UNSIGNED NOT NULL COMMENT 'x1:响应2:拒绝响应 3：失去响应【创建时间大于现在5min 默认' DEFAULT '3'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`refusexiangyinanimaid\` \`refusexiangyinanimaid\` int(10) UNSIGNED NULL DEFAULT '1'`);
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
        await queryRunner.query(`CREATE UNIQUE INDEX \`IDX_fc151b46bb16e0d23689090f09\` ON \`app_oo_pri\` (\`joinuserid\`, \`oid\`)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_fc151b46bb16e0d23689090f09\` ON \`app_oo_pri\``);
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
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`refusexiangyinanimaid\` \`refusexiangyinanimaid\` int UNSIGNED NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`xiangyinstatus\` \`xiangyinstatus\` int UNSIGNED NOT NULL COMMENT 'x1:响应2:拒绝响应 3：失去响应【创建时间大于现在5min 默认' DEFAULT '3'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`res\` \`res\` int NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`cardupdatetime\` \`cardupdatetime\` int NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`cardphone\` \`cardphone\` bigint NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`morelife\` \`morelife\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`sence\` \`sence\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`collapsecompassid\` \`collapsecompassid\` bigint UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`collapsecompass\` \`collapsecompass\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`isdoor\` \`isdoor\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`firenum\` \`firenum\` int UNSIGNED NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`joinin\` \`joinin\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`wand\` \`wand\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`status\` \`status\` int UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`oerid\` \`oerid\` bigint UNSIGNED NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_oo_pri\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`UK_oo_pri\` ON \`app_oo_pri\` (\`joinuserid\`, \`oid\`)`);
    }

}
