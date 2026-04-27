import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateAppRefundEtc1760924411552 implements MigrationInterface {
    name = 'UpdateAppRefundEtc1760924411552'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_refund\` ADD UNIQUE INDEX \`IDX_2e9c70acfc0de53a17e94cf85f\` (\`order_sn\`)`);
        await queryRunner.query(`DROP INDEX \`IDX_67a68e699b0284e2313460d988\` ON \`app_divide_summary\``);
        await queryRunner.query(`ALTER TABLE \`app_divide_summary\` CHANGE \`business_type\` \`business_type\` varchar(255) NOT NULL COMMENT '业务类型来源' DEFAULT 'petihope'`);
        await queryRunner.query(`ALTER TABLE \`app_divide_record\` CHANGE \`business_type\` \`business_type\` varchar(255) NOT NULL COMMENT '业务类型来源' DEFAULT 'petihope'`);
        await queryRunner.query(`ALTER TABLE \`app_activities\` CHANGE \`bussiness_type\` \`bussiness_type\` varchar(255) NOT NULL COMMENT '业务类型来源' DEFAULT 'petihope'`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`IDX_67a68e699b0284e2313460d988\` ON \`app_divide_summary\` (\`business_type\`, \`business_id\`)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_67a68e699b0284e2313460d988\` ON \`app_divide_summary\``);
        await queryRunner.query(`ALTER TABLE \`app_activities\` CHANGE \`bussiness_type\` \`bussiness_type\` varchar(255) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '业务类型来源，名称为表名' DEFAULT 'app_oo'`);
        await queryRunner.query(`ALTER TABLE \`app_divide_record\` CHANGE \`business_type\` \`business_type\` varchar(255) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '业务类型来源，名称为表名' DEFAULT 'app_oo'`);
        await queryRunner.query(`ALTER TABLE \`app_divide_summary\` CHANGE \`business_type\` \`business_type\` varchar(255) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '业务类型来源，名称为表名' DEFAULT 'app_oo'`);
        await queryRunner.query(`CREATE UNIQUE INDEX \`IDX_67a68e699b0284e2313460d988\` ON \`app_divide_summary\` (\`business_id\`, \`business_type\`)`);
        await queryRunner.query(`ALTER TABLE \`app_refund\` DROP INDEX \`IDX_2e9c70acfc0de53a17e94cf85f\``);
    }

}
