import { MigrationInterface, QueryRunner } from "typeorm";

export class ExtendUserAndCreateWakmeTables1776840390766 implements MigrationInterface {
    name = 'ExtendUserAndCreateWakmeTables1776840390766'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`posts\` (\`id\` varchar(36) NOT NULL, \`userId\` varchar(40) NOT NULL COMMENT '用户ID', \`content\` text NOT NULL COMMENT '内容', \`tags\` text NULL COMMENT '话题标签', \`purpose\` varchar(50) NOT NULL COMMENT '交友目的', \`visibility\` varchar(50) NOT NULL COMMENT '可见范围 public/friends/only_me' DEFAULT 'public', \`images\` text NULL COMMENT '图片列表', \`likeCount\` int NOT NULL COMMENT '点赞数' DEFAULT '0', \`commentCount\` int NOT NULL COMMENT '评论数' DEFAULT '0', \`status\` varchar(20) NOT NULL COMMENT '状态 pending/approved/rejected' DEFAULT 'pending', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`IDX_da5be4fcaa8c60cd94c7339ecc\` (\`visibility\`, \`status\`, \`createdAt\`), INDEX \`IDX_c2abd733c649dedcfa533c2c6c\` (\`purpose\`, \`status\`, \`createdAt\`), INDEX \`IDX_d5c404ce74b775e290b4514085\` (\`userId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`swipes\` (\`id\` varchar(36) NOT NULL, \`userId\` varchar(40) NOT NULL COMMENT '用户ID', \`targetId\` varchar(40) NOT NULL COMMENT '目标用户ID', \`action\` varchar(20) NOT NULL COMMENT '操作 like/dislike/rewind', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), INDEX \`IDX_34154e5365ffae8b0234ee29b5\` (\`userId\`, \`targetId\`), INDEX \`IDX_52a47aec3f190cf8b9b7d38eb0\` (\`userId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`friendships\` (\`id\` varchar(36) NOT NULL, \`userId\` varchar(40) NOT NULL COMMENT '用户ID', \`friendId\` varchar(40) NOT NULL COMMENT '好友ID', \`status\` varchar(20) NOT NULL COMMENT '状态 pending/accepted/blocked' DEFAULT 'pending', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`IDX_79319c79ccb0d109db66e5faaf\` (\`userId\`, \`friendId\`), INDEX \`IDX_b53aab231bc99ac9f0874df751\` (\`userId\`, \`status\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`messages\` (\`id\` varchar(36) NOT NULL, \`senderId\` varchar(40) NOT NULL COMMENT '发送者ID', \`receiverId\` varchar(40) NOT NULL COMMENT '接收者ID', \`type\` varchar(20) NOT NULL COMMENT '类型 text/image/audio/video/gift', \`content\` text NOT NULL COMMENT '内容', \`status\` varchar(20) NOT NULL COMMENT '状态 sent/delivered/read' DEFAULT 'sent', \`isBlocked\` tinyint NOT NULL COMMENT '是否被拦截 0:否 1:是' DEFAULT '0', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), INDEX \`IDX_469a4b15dcd7f880773bbf9f34\` (\`receiverId\`, \`status\`, \`createdAt\`), INDEX \`IDX_73c2a0e66a81607fa3055f99e6\` (\`senderId\`, \`receiverId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`call_records\` (\`id\` varchar(36) NOT NULL, \`callerId\` varchar(40) NOT NULL COMMENT '呼叫者ID', \`calleeId\` varchar(40) NOT NULL COMMENT '被叫者ID', \`type\` varchar(20) NOT NULL COMMENT '类型 voice/video', \`roomId\` varchar(100) NOT NULL COMMENT '房间ID', \`status\` varchar(20) NOT NULL COMMENT '状态 initiated/connected/ended/missed', \`duration\` int NOT NULL COMMENT '通话时长(秒)' DEFAULT '0', \`costMinutes\` int NOT NULL COMMENT '消耗时长(分钟)' DEFAULT '0', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`IDX_2878570a5f9edd80b729b1cd79\` (\`calleeId\`, \`createdAt\`), INDEX \`IDX_952752e844ceb871c7107f603a\` (\`callerId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`vip_subscriptions\` (\`id\` varchar(36) NOT NULL, \`userId\` varchar(40) NOT NULL COMMENT '用户ID', \`productId\` varchar(50) NOT NULL COMMENT '产品ID', \`subscriptionId\` varchar(100) NOT NULL COMMENT '订阅ID', \`type\` varchar(20) NOT NULL COMMENT '类型 weekly/monthly', \`status\` varchar(20) NOT NULL COMMENT '状态 active/expired/cancelled', \`startDate\` datetime NOT NULL COMMENT '开始时间', \`expireDate\` datetime NOT NULL COMMENT '过期时间', \`autoRenew\` tinyint NOT NULL COMMENT '是否自动续订 0:否 1:是' DEFAULT '1', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`IDX_5e6ea17151efc70ab1b951f5a0\` (\`subscriptionId\`), INDEX \`IDX_d0c7c5b2bbd06d85892195e37c\` (\`userId\`, \`status\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`call_minutes\` (\`id\` varchar(36) NOT NULL, \`userId\` varchar(40) NOT NULL COMMENT '用户ID', \`type\` varchar(20) NOT NULL COMMENT '类型 voice/video', \`totalMinutes\` int NOT NULL COMMENT '总时长(分钟)' DEFAULT '0', \`usedMinutes\` int NOT NULL COMMENT '已使用时长(分钟)' DEFAULT '0', \`remainingMinutes\` int NOT NULL COMMENT '剩余时长(分钟)' DEFAULT '0', \`expireDate\` datetime NULL COMMENT '过期时间', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`IDX_06ef0828c69ac911ecd33eb1af\` (\`userId\`, \`type\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`gifts\` (\`id\` varchar(36) NOT NULL, \`name\` varchar(100) NOT NULL COMMENT '名称', \`icon\` varchar(225) NOT NULL COMMENT '图标', \`animation\` varchar(225) NULL COMMENT '动画', \`price\` int NOT NULL COMMENT '价格(钻石)', \`status\` varchar(20) NOT NULL COMMENT '状态 active/inactive' DEFAULT 'active', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`gift_records\` (\`id\` varchar(36) NOT NULL, \`senderId\` varchar(40) NOT NULL COMMENT '赠送者ID', \`receiverId\` varchar(40) NOT NULL COMMENT '接收者ID', \`giftId\` varchar(40) NOT NULL COMMENT '礼物ID', \`price\` int NOT NULL COMMENT '价格(钻石)', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), INDEX \`IDX_b51505f7955885c70b59117694\` (\`receiverId\`, \`createdAt\`), INDEX \`IDX_ea21c77692d90e38b3d5eca079\` (\`senderId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`reports\` (\`id\` varchar(36) NOT NULL, \`reporterId\` varchar(40) NOT NULL COMMENT '举报者ID', \`reportedId\` varchar(40) NOT NULL COMMENT '被举报者ID', \`type\` varchar(50) NOT NULL COMMENT '类型 harassment/threats/sexual_content/hate_speech/violence/spam/privacy/underage/copyright/other', \`description\` text NULL COMMENT '描述', \`screenshots\` text NULL COMMENT '截图列表', \`status\` varchar(20) NOT NULL COMMENT '状态 pending/processing/resolved/rejected' DEFAULT 'pending', \`result\` varchar(20) NULL COMMENT '处理结果 warning/temp_ban/permanent_ban/content_removed', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), \`updatedAt\` datetime(6) NOT NULL COMMENT '更新时间' DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), INDEX \`IDX_bc4ce93d025c500b0b835530dc\` (\`reportedId\`, \`status\`), INDEX \`IDX_040aeac2d9bcc1e38874ce2201\` (\`reporterId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`blocks\` (\`id\` varchar(36) NOT NULL, \`userId\` varchar(40) NOT NULL COMMENT '用户ID', \`blockedId\` varchar(40) NOT NULL COMMENT '被拉黑用户ID', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), INDEX \`IDX_085b3c49e18df24b6d86e3b897\` (\`userId\`, \`createdAt\`), INDEX \`IDX_cbc0364331d4d20470825f9d99\` (\`userId\`, \`blockedId\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`view_records\` (\`id\` varchar(36) NOT NULL, \`viewerId\` varchar(40) NOT NULL COMMENT '浏览者ID', \`viewedId\` varchar(40) NOT NULL COMMENT '被浏览者ID', \`createdAt\` datetime(6) NOT NULL COMMENT '创建时间' DEFAULT CURRENT_TIMESTAMP(6), INDEX \`IDX_08bada3fd20514486a352b2740\` (\`viewerId\`, \`viewedId\`), INDEX \`IDX_28443c2e7e43fbd8a920172b68\` (\`viewedId\`, \`createdAt\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`gender\` enum ('male', 'female', 'non_binary', 'prefer_not_say') NULL COMMENT '性别'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`birthDate\` date NULL COMMENT '出生日期'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`country\` varchar(100) NULL COMMENT '国家'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`language\` varchar(100) NULL COMMENT '语言'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`occupation\` varchar(100) NULL COMMENT '职业'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`interests\` text NULL COMMENT '兴趣爱好'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`personality\` text NULL COMMENT '性格标签'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`chatPurpose\` text NULL COMMENT '聊天目的'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`communicationStyle\` text NULL COMMENT '沟通风格'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`status\` varchar(500) NULL COMMENT '一句话状态'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`isVIP\` tinyint NOT NULL COMMENT '是否VIP 0:否 1:是' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`vipExpireTime\` datetime NULL COMMENT 'VIP过期时间'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`privacySettings\` text NULL COMMENT '隐私设置'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`googleId\` varchar(225) NULL COMMENT 'Google用户ID'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`appleId\` varchar(225) NULL COMMENT 'Apple用户ID'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`deviceId\` varchar(225) NULL COMMENT '设备ID'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`dailySwipeCount\` int NOT NULL COMMENT '今日滑动次数' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`dailyMessageCount\` int NOT NULL COMMENT '今日消息次数' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`dailyApplyCount\` int NOT NULL COMMENT '今日申请次数' DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`lastSwipeResetTime\` datetime NULL COMMENT '上次滑动重置时间'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`lastMessageResetTime\` datetime NULL COMMENT '上次消息重置时间'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`lastApplyResetTime\` datetime NULL COMMENT '上次申请重置时间'`);
        await queryRunner.query(`ALTER TABLE \`app_users\` ADD \`blockedWords\` text NULL COMMENT '自定义屏蔽词'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`blockedWords\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`lastApplyResetTime\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`lastMessageResetTime\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`lastSwipeResetTime\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`dailyApplyCount\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`dailyMessageCount\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`dailySwipeCount\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`deviceId\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`appleId\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`googleId\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`privacySettings\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`vipExpireTime\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`isVIP\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`status\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`communicationStyle\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`chatPurpose\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`personality\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`interests\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`occupation\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`language\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`country\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`birthDate\``);
        await queryRunner.query(`ALTER TABLE \`app_users\` DROP COLUMN \`gender\``);
        await queryRunner.query(`DROP INDEX \`IDX_28443c2e7e43fbd8a920172b68\` ON \`view_records\``);
        await queryRunner.query(`DROP INDEX \`IDX_08bada3fd20514486a352b2740\` ON \`view_records\``);
        await queryRunner.query(`DROP TABLE \`view_records\``);
        await queryRunner.query(`DROP INDEX \`IDX_cbc0364331d4d20470825f9d99\` ON \`blocks\``);
        await queryRunner.query(`DROP INDEX \`IDX_085b3c49e18df24b6d86e3b897\` ON \`blocks\``);
        await queryRunner.query(`DROP TABLE \`blocks\``);
        await queryRunner.query(`DROP INDEX \`IDX_040aeac2d9bcc1e38874ce2201\` ON \`reports\``);
        await queryRunner.query(`DROP INDEX \`IDX_bc4ce93d025c500b0b835530dc\` ON \`reports\``);
        await queryRunner.query(`DROP TABLE \`reports\``);
        await queryRunner.query(`DROP INDEX \`IDX_ea21c77692d90e38b3d5eca079\` ON \`gift_records\``);
        await queryRunner.query(`DROP INDEX \`IDX_b51505f7955885c70b59117694\` ON \`gift_records\``);
        await queryRunner.query(`DROP TABLE \`gift_records\``);
        await queryRunner.query(`DROP TABLE \`gifts\``);
        await queryRunner.query(`DROP INDEX \`IDX_06ef0828c69ac911ecd33eb1af\` ON \`call_minutes\``);
        await queryRunner.query(`DROP TABLE \`call_minutes\``);
        await queryRunner.query(`DROP INDEX \`IDX_d0c7c5b2bbd06d85892195e37c\` ON \`vip_subscriptions\``);
        await queryRunner.query(`DROP INDEX \`IDX_5e6ea17151efc70ab1b951f5a0\` ON \`vip_subscriptions\``);
        await queryRunner.query(`DROP TABLE \`vip_subscriptions\``);
        await queryRunner.query(`DROP INDEX \`IDX_952752e844ceb871c7107f603a\` ON \`call_records\``);
        await queryRunner.query(`DROP INDEX \`IDX_2878570a5f9edd80b729b1cd79\` ON \`call_records\``);
        await queryRunner.query(`DROP TABLE \`call_records\``);
        await queryRunner.query(`DROP INDEX \`IDX_73c2a0e66a81607fa3055f99e6\` ON \`messages\``);
        await queryRunner.query(`DROP INDEX \`IDX_469a4b15dcd7f880773bbf9f34\` ON \`messages\``);
        await queryRunner.query(`DROP TABLE \`messages\``);
        await queryRunner.query(`DROP INDEX \`IDX_b53aab231bc99ac9f0874df751\` ON \`friendships\``);
        await queryRunner.query(`DROP INDEX \`IDX_79319c79ccb0d109db66e5faaf\` ON \`friendships\``);
        await queryRunner.query(`DROP TABLE \`friendships\``);
        await queryRunner.query(`DROP INDEX \`IDX_52a47aec3f190cf8b9b7d38eb0\` ON \`swipes\``);
        await queryRunner.query(`DROP INDEX \`IDX_34154e5365ffae8b0234ee29b5\` ON \`swipes\``);
        await queryRunner.query(`DROP TABLE \`swipes\``);
        await queryRunner.query(`DROP INDEX \`IDX_d5c404ce74b775e290b4514085\` ON \`posts\``);
        await queryRunner.query(`DROP INDEX \`IDX_c2abd733c649dedcfa533c2c6c\` ON \`posts\``);
        await queryRunner.query(`DROP INDEX \`IDX_da5be4fcaa8c60cd94c7339ecc\` ON \`posts\``);
        await queryRunner.query(`DROP TABLE \`posts\``);
    }

}
