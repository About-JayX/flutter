import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateUsersAddLoction1762152925470 implements MigrationInterface {
    name = 'UpdateUsersAddLoction1762152925470'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`phonenum\` ON \`app_users\``);
        await queryRunner.query(`DROP INDEX \`uniqid\` ON \`app_users\``);
        await queryRunner.query(`DROP INDEX \`username\` ON \`app_users\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`current_location_map\` json NULL COMMENT '当前定位地址'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`my_location_map\` json NULL COMMENT '我的定位地址'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`people_less\` int UNSIGNED NOT NULL COMMENT '剩余可参与的用户数' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`version\` int NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`uniqid\` \`uniqid\` char(40) NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD UNIQUE INDEX \`IDX_6324a536d26e0ea92c7abcabdb\` (\`uniqid\`)`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`phonenum\` \`phonenum\` bigint UNSIGNED NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD UNIQUE INDEX \`IDX_e2fe0c133660e52efead6d15ff\` (\`phonenum\`)`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`username\` \`username\` varchar(500) NULL`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD UNIQUE INDEX \`IDX_5d67cc2e38c80255e768c2b76a\` (\`username\`)`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`divide_source_money\` \`divide_source_money\` decimal(10,2) UNSIGNED NOT NULL COMMENT '分成金额' DEFAULT '0.00'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`withdraw_source_money\` \`withdraw_source_money\` decimal(10,2) UNSIGNED NOT NULL COMMENT '提现金额' DEFAULT '0.00'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`phonearea\` \`phonearea\` varchar(225) NOT NULL DEFAULT '0086'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`authenticationstatus\` \`authenticationstatus\` int UNSIGNED NOT NULL COMMENT '0：未验证 2：验证中 1：验证成功 3：验证失败' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`authenticationtype\` \`authenticationtype\` varchar(225) NULL COMMENT 'personauthe:个人实名 professionalsauthe：专业人士 companyauthe：公司'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`usertype\` \`usertype\` varchar(225) NOT NULL DEFAULT 'real'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`usertype\` \`usertype\` varchar(225) CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NULL DEFAULT 'real'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`authenticationtype\` \`authenticationtype\` varchar(225) CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NULL COMMENT '                    personauthe:个人实名                     professionalsauthe：专业人士                     companyauthe：公司'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`authenticationstatus\` \`authenticationstatus\` int UNSIGNED NOT NULL COMMENT '0：未验证2：验证中1：验证成功 3：验证失败' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`phonearea\` \`phonearea\` varchar(225) CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NULL DEFAULT '0086'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`updatetime\` \`updatetime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`createtime\` \`createtime\` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`withdraw_source_money\` \`withdraw_source_money\` decimal(10,2) UNSIGNED NULL COMMENT '提现金额' DEFAULT '0.00'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`divide_source_money\` \`divide_source_money\` decimal(10,2) UNSIGNED NULL COMMENT '分成金额' DEFAULT '0.00'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP INDEX \`IDX_5d67cc2e38c80255e768c2b76a\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`username\` \`username\` varchar(500) CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NULL`);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP INDEX \`IDX_e2fe0c133660e52efead6d15ff\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`phonenum\` \`phonenum\` bigint UNSIGNED NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP INDEX \`IDX_6324a536d26e0ea92c7abcabdb\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` CHANGE \`uniqid\` \`uniqid\` char(40) CHARACTER SET "utf8mb3" COLLATE "utf8mb3_unicode_ci" NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`version\``);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`people_less\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`my_location_map\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`current_location_map\``);
        await queryRunner.query(`CREATE UNIQUE INDEX \`username\` ON \`app_users\` (\`username\`)`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`uniqid\` ON \`app_users\` (\`uniqid\`)`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`phonenum\` ON \`app_users\` (\`phonenum\`)`);
    }

}
