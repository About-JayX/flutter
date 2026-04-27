import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrderproduct1760689188033 implements MigrationInterface {
    name = 'UpdateOrderproduct1760689188033'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order_product\` ADD \`unique_id\` varchar(255) NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order_product\` DROP COLUMN \`unique_id\``);
    }

}
