import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrder1760496459968 implements MigrationInterface {
    name = 'UpdateOrder1760496459968'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_activities\` DROP COLUMN \`title\``);
        await queryRunner.query(`ALTER TABLE \`app_activities\` ADD \`title\` varchar(768) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`user_id\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`user_id\` bigint NOT NULL COMMENT '用户ID'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`user_id\``);
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`user_id\` int NOT NULL COMMENT '用户ID'`);
        await queryRunner.query(`ALTER TABLE \`app_activities\` DROP COLUMN \`title\``);
        await queryRunner.query(`ALTER TABLE \`app_activities\` ADD \`title\` varchar(100) NOT NULL`);
    }

}
