import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateProductPrice1761378457251 implements MigrationInterface {
    name = 'UpdateProductPrice1761378457251'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_price\` \`product_price\` decimal(10,2) NOT NULL COMMENT '商品单价,保留两位数'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_price\` \`product_price\` decimal(10,2) NOT NULL COMMENT '商品单价'`);
    }

}
