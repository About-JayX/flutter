import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOrderProductSkuId1760540446677 implements MigrationInterface {
    name = 'UpdateOrderProductSkuId1760540446677'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` ADD \`product_sku_id\` int NULL COMMENT '订单的商品skuID'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_order\` DROP COLUMN \`product_sku_id\``);
    }

}
