import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrderAddr1760503912312 implements MigrationInterface {
    name = 'UpdateOrderAddr1760503912312'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`receiver_address\``);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`receiver_address\` text NOT NULL COMMENT '收货地址'`);
    }

}
