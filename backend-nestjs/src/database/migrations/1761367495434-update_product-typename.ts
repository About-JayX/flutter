import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateProductTypename1761367495434 implements MigrationInterface {
    name = 'UpdateProductTypename1761367495434'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_type_name\` \`product_type_name\` varchar(255) NOT NULL COMMENT '商品类型,默认全品类' DEFAULT '全品类'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_type_name\` \`product_type_name\` varchar(255) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '商品类型' DEFAULT '全品类'`);
    }

}
