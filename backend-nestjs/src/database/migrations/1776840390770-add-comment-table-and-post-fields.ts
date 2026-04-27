import { MigrationInterface, QueryRunner } from "typeorm";

export class AddCommentTableAndPostFields1776840390770 implements MigrationInterface {
    name = 'AddCommentTableAndPostFields1776840390770'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`comments\` (
            \`id\` varchar(36) NOT NULL,
            \`postId\` varchar(36) NOT NULL COMMENT '帖子ID',
            \`userId\` varchar(40) NOT NULL COMMENT '用户ID',
            \`content\` text NOT NULL COMMENT '内容',
            \`parentId\` varchar(36) NULL COMMENT '父评论ID',
            \`status\` varchar(20) NOT NULL COMMENT '状态 approved/rejected' DEFAULT 'approved',
            \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6),
            \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
            INDEX \`IDX_comments_postId\` (\`postId\`, \`createdAt\`),
            INDEX \`IDX_comments_userId\` (\`userId\`, \`createdAt\`),
            PRIMARY KEY (\`id\`)
        ) ENGINE=InnoDB`);

        await queryRunner.query(`ALTER TABLE \`posts\` 
            ADD \`isAnonymous\` tinyint NOT NULL COMMENT '是否匿名 0:否 1:是' DEFAULT '0',
            ADD \`moderationReason\` varchar(225) NULL COMMENT '审核原因',
            ADD \`moderatedAt\` datetime NULL COMMENT '审核时间',
            ADD \`moderatedBy\` varchar(40) NULL COMMENT '审核人ID'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_comments_postId\` ON \`comments\``);
        await queryRunner.query(`DROP INDEX \`IDX_comments_userId\` ON \`comments\``);
        await queryRunner.query(`DROP TABLE \`comments\``);

        await queryRunner.query(`ALTER TABLE \`posts\` 
            DROP COLUMN \`isAnonymous\`,
            DROP COLUMN \`moderationReason\`,
            DROP COLUMN \`moderatedAt\`,
            DROP COLUMN \`moderatedBy\``);
    }
}
