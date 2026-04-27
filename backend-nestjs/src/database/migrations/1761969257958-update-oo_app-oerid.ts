import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateOoAppOerid1761969257958 implements MigrationInterface {
    name = 'UpdateOoAppOerid1761969257958'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`oerid\` \`oerId\` int NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`oerId\``);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`oerId\` bigint UNSIGNED NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_oo\` DROP COLUMN \`oerId\``);
        await queryRunner.query(`ALTER TABLE \`app_oo\` ADD \`oerId\` int NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`app_oo\` CHANGE \`oerId\` \`oerid\` int NOT NULL`);
    }

}
