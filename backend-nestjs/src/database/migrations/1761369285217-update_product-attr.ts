import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateProductAttr1761369285217 implements MigrationInterface {
    name = 'UpdateProductAttr1761369285217'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` DROP COLUMN \`product_attrs\``);
        await queryRunner.query(`ALTER TABLE \`app_product\` ADD \`product_attrs\` json NULL COMMENT '商品属性，默认为空'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` DROP COLUMN \`product_attrs\``);
        await queryRunner.query(`ALTER TABLE \`app_product\` ADD \`product_attrs\` longtext COLLATE "utf8mb4_bin" NULL COMMENT '商品属性'`);
    }

}
