import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateProductImage1761385398741 implements MigrationInterface {
    name = 'UpdateProductImage1761385398741'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_image\` \`product_image\` varchar(500) NULL COMMENT '商品图片，可为空'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_image\` \`product_image\` varchar(500) COLLATE "utf8mb4_unicode_ci" NULL COMMENT '商品图片'`);
    }

}
