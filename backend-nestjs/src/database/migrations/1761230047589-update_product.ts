import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateProduct1761230047589 implements MigrationInterface {
    name = 'UpdateProduct1761230047589'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_type\` \`product_type\` varchar(255) NOT NULL COMMENT '商品类型,all指全品类' DEFAULT 'all'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_product\` CHANGE \`product_type\` \`product_type\` varchar(255) COLLATE "utf8mb4_unicode_ci" NOT NULL COMMENT '商品类型' DEFAULT 'all'`);
    }

}
