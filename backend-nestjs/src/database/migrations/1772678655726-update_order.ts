import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrder1772678655726 implements MigrationInterface {
    name = 'UpdateOrder1772678655726'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`receiver_phone_encrypted\` varchar(255) NULL COMMENT '收货人电话Encrypted'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`receiver_name\` \`receiver_name\` varchar(50) CHARACTER SET "utf8mb4" COLLATE "utf8mb4_unicode_ci" NULL COMMENT '收货人姓名'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`receiver_phone\` \`receiver_phone\` varchar(20) NULL COMMENT '收货人电话'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`receiver_phone\` \`receiver_phone\` varchar(20) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '收货人电话'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` CHANGE \`receiver_name\` \`receiver_name\` varchar(50) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '收货人姓名'`);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`receiver_phone_encrypted\``);
    }

}
