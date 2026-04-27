import { MigrationInterface, QueryRunner } from "typeorm";

export class InitSchema1760334410000 implements MigrationInterface {
    name = 'InitSchema1760334410000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_dau\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`daunum\` bigint NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`uptime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_discathot\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`catid\` bigint unsigned NOT NULL,
              \`location\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`post\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`actimes\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` varchar(125) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`close\` int NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_discohotcon\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`faith\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`des\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`tagssys\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`location\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`limitarea\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'city',
              \`sort\` int NOT NULL DEFAULT '1',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_dms\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`usernum\` bigint unsigned NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`uptime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_exportsort\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`sort\` longtext COLLATE utf8mb3_unicode_ci,
              \`level\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_fun\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`con\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`type\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`upd\` varchar(1) COLLATE utf8mb3_unicode_ci DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_intromodel\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`modelname\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'basic',
              \`introwords\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '以一种有趣的方式，和这个世界动起来',
              \`unicodewords\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`unicodeimage\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`modelhead\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`modelfront\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`unicodeback\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0',
              \`cometruemodel\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_invitecode\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`code\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`state\` int DEFAULT '0',
              \`createtime\` datetime DEFAULT CURRENT_TIMESTAMP,
              \`updtime\` datetime DEFAULT CURRENT_TIMESTAMP,
              \`type\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`arr\` bigint NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_manager\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`phonenum\` bigint NOT NULL,
              \`mcode\` bigint DEFAULT NULL,
              \`mcodetime\` bigint DEFAULT NULL,
              \`username\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'SUPER',
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`power\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'super',
              \`fire\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'fire-wood',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_mau\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`maunum\` bigint NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`uptime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_notice\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`notice\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`type\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT 'all',
              \`createtime\` datetime DEFAULT CURRENT_TIMESTAMP,
              \`endtime\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_oodiscomodule\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`name\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`title\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`getotype\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'allid',
              \`oid\` bigint DEFAULT NULL,
              \`oodiscoorder\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '{publicstatus:1,like:[‘updatetime’]}',
              \`city\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`citycode\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_searchrecommend\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`name\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`con\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_soft\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`fun\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`soft\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`upd\` varchar(1) COLLATE utf8mb3_unicode_ci DEFAULT '0',
              \`url\` longtext COLLATE utf8mb3_unicode_ci,
              \`urlios\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`urlandroid\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`info\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime DEFAULT CURRENT_TIMESTAMP,
              \`qrcode\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              \`updtype\` varchar(5) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0' COMMENT '更新类型，软件更新，后台更新',
              \`updversion\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '更新版本',
              \`urltips\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`urliostips\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`urlandroidtips\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_system\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`fun\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'oo功能接口数据',
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`admin_wau\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`waunum\` bigint NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`uptime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_332friend\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`userid\` int NOT NULL,
              \`relation\` int DEFAULT '1',
              \`berelation\` int DEFAULT '1',
              \`star\` int DEFAULT '0',
              \`othername\` varchar(25) DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_332oo\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`oid\` int NOT NULL,
              \`oerid\` int NOT NULL,
              \`fire\` varchar(225) NOT NULL,
              \`isfire\` int DEFAULT '0',
              \`otype\` int NOT NULL DEFAULT '2',
              \`firetime\` timestamp NULL DEFAULT NULL,
              \`fireall\` longtext,
              \`faith\` varchar(25) NOT NULL,
              \`oevent\` varchar(225) DEFAULT NULL,
              \`createdatetime\` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              \`push\` int DEFAULT NULL,
              \`addstate\` int NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_510oosingal\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`oid\` int NOT NULL,
              \`userid\` int NOT NULL,
              \`type\` varchar(25) NOT NULL,
              \`con\` varchar(225) NOT NULL,
              \`sender\` varchar(225) NOT NULL,
              \`userat\` varchar(225) DEFAULT NULL,
              \`createtime\` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              \`titatime\` varchar(225) NOT NULL DEFAULT '300',
              \`uniqid\` char(40) NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_avatar\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`name\` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`imagename\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_back\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`name\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`imagename\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`imagesmall\` longtext COLLATE utf8mb3_unicode_ci,
              \`imagepre\` longtext COLLATE utf8mb3_unicode_ci,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`sort\` int unsigned NOT NULL DEFAULT '1',
              \`hidden\` int NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_category\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`importid\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`tag\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`othersname\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`parentid\` bigint unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`icon\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`iconlink\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`image\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`sort\` int unsigned NOT NULL DEFAULT '1',
              \`hidden\` int NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_category_record\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`catid\` int unsigned NOT NULL,
              \`count\` bigint unsigned NOT NULL DEFAULT '1',
              \`provicecount\` bigint unsigned NOT NULL DEFAULT '1',
              \`citycount\` bigint unsigned NOT NULL DEFAULT '1',
              \`country\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`province\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`city\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_companyauthe\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`personautheid\` bigint unsigned NOT NULL,
              \`companytype\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`companytotalname\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`companytotalid\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`authename\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`authetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`authenamehis\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`companytotalidcardimage\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`manageridcardfrontimage\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`manageridcardbackimage\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`manageruserwithidcardimage\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`manageruserspeakvideo\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`manageruserfacetestvideo\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_compass\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`unqidfromclient\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`type\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'cover//封面 空或normal//一般的指的是文字图片内容',
              \`title\` varchar(25) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` longtext COLLATE utf8mb3_unicode_ci,
              \`componenttype\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'module time location',
              \`componentorder\` int unsigned DEFAULT NULL,
              \`moduleid\` bigint unsigned DEFAULT NULL,
              \`imagetype\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'image',
              \`images\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`orderkey\` int unsigned NOT NULL DEFAULT '0',
              \`videos\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`location\` int DEFAULT '0',
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              \`hotnum\` bigint unsigned NOT NULL DEFAULT '0',
              \`readedmembers\` longtext COLLATE utf8mb3_unicode_ci COMMENT '已查看指南的成员',
              \`likemember\` longtext COLLATE utf8mb3_unicode_ci,
              \`likenum\` int NOT NULL DEFAULT '0',
              \`collectmember\` longtext COLLATE utf8mb3_unicode_ci,
              \`collectnum\` int NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=479 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_compass_con\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`compassid\` bigint unsigned NOT NULL,
              \`orderkey\` int unsigned NOT NULL DEFAULT '0',
              \`type\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT 'normal' COMMENT 'cover normal',
              \`imagetype\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'image',
              \`images\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`title\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`componenttype\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'location time module',
              \`componentorder\` int unsigned DEFAULT NULL,
              \`moduleid\` bigint unsigned DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updateversion\` int unsigned NOT NULL DEFAULT '1',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=320 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_country\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`chname\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`enname\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`ennamesimple\` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=451 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_fire\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`fire\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`code\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT '00001',
              \`name\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`image\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`sort\` int DEFAULT '1',
              \`url\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`dir\` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_follows\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`followid\` bigint unsigned NOT NULL,
              \`followerid\` bigint unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2386 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_friend_verify\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`inviteuserid\` bigint unsigned NOT NULL,
              \`inviteduserid\` bigint unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`invitedes\` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`othername\` varchar(25) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`seeenabled\` int NOT NULL DEFAULT '1',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_friends\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`userid\` bigint unsigned NOT NULL,
              \`friendid\` bigint unsigned NOT NULL,
              \`othername\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`relation\` int unsigned NOT NULL DEFAULT '1' COMMENT '1:默认，2：星标',
              \`status\` int unsigned NOT NULL DEFAULT '1' COMMENT '1：好友 2：拉黑，3：删除',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_friends_chats\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`senduserid\` bigint unsigned NOT NULL,
              \`acceptuserid\` bigint unsigned NOT NULL,
              \`uniqidsame\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`text\` longtext COLLATE utf8mb3_unicode_ci,
              \`image\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`contype\` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'text',
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              \`timeforcon\` int unsigned NOT NULL DEFAULT '0',
              \`clienttime\` datetime NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=642 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_importmachineimageerror\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`imagename\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`imagefullpath\` varchar(5555) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`imageusetype\` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_level_gravitation\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`oid\` bigint NOT NULL,
              \`uniqid\` varchar(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`title\` varchar(2250) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` longtext COLLATE utf8mb3_unicode_ci,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_level_gravitation_check\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`oid\` bigint NOT NULL,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`gravitationid\` bigint NOT NULL,
              \`checkuserid\` bigint NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_level_pictureswall_pri\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`pictureswallid\` bigint NOT NULL,
              \`memberuserid\` bigint NOT NULL,
              \`islike\` int unsigned NOT NULL DEFAULT '0' COMMENT '1表示喜欢',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_levelmessage\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`uniqidsame\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`text\` longtext COLLATE utf8mb3_unicode_ci,
              \`image\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`contype\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'text',
              \`timeforcon\` int unsigned NOT NULL DEFAULT '0' COMMENT '0代表不打印时间',
              \`clienttime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=1140 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_levelmodules\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_levelmodulesdb\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`levelname\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`title\` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`icon\` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`image\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
              \`link\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`sort\` bigint unsigned NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`),
              UNIQUE KEY \`levelname\` (\`levelname\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_levelpictureswall\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL DEFAULT '280',
              \`userid\` bigint unsigned NOT NULL,
              \`memberuserid\` bigint unsigned NOT NULL,
              \`picurl\` longtext COLLATE utf8mb3_unicode_ci,
              \`image\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`likenum\` bigint unsigned NOT NULL DEFAULT '0',
              \`commentnum\` bigint unsigned NOT NULL DEFAULT '0',
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '9ae567e0ed4b3fdf09a5172ea68e371b4aa1c946',
              \`des\` longtext COLLATE utf8mb3_unicode_ci,
              \`keywords\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`desunicode\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_levelpictureswalllike\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`pid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_newfriendsverify\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`requestid\` bigint NOT NULL,
              \`berequestedid\` bigint NOT NULL,
              \`verifymessage\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`username\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`friend\` tinyint(1) NOT NULL DEFAULT '0',
              \`push\` tinyint(1) NOT NULL DEFAULT '0',
              \`avatar\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_news\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`type\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'oernews',
              \`con\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`top\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=380 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_news1\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`type\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`typesource\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`objid\` bigint DEFAULT NULL,
              \`readtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`isread\` int unsigned NOT NULL DEFAULT '0',
              \`readsourceidlist\` longtext COLLATE utf8mb3_unicode_ci,
              \`readid\` bigint unsigned DEFAULT NULL,
              \`status\` int NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=941 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_newsbyfollow\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`senderuserid\` bigint NOT NULL,
              \`accepteruserid\` bigint NOT NULL,
              \`msgtype\` int NOT NULL DEFAULT '1',
              \`text\` longtext COLLATE utf8mb3_unicode_ci,
              \`richtext\` longtext COLLATE utf8mb3_unicode_ci,
              \`image\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`audio\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`video\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_newsbyfriend\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`newssourceid\` bigint unsigned NOT NULL,
              \`isread\` int unsigned NOT NULL DEFAULT '0',
              \`unreadnums\` int unsigned NOT NULL DEFAULT '1',
              \`userid\` bigint unsigned NOT NULL,
              \`type\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'chat',
              \`senderuserid\` bigint unsigned NOT NULL,
              \`accepteruserid\` bigint unsigned NOT NULL,
              \`msgtype\` int unsigned NOT NULL DEFAULT '1' COMMENT '1:表示纯文本',
              \`text\` longtext COLLATE utf8mb3_unicode_ci,
              \`richtext\` longtext COLLATE utf8mb3_unicode_ci,
              \`image\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`audio\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`video\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_newsbyo\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`type\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`onewsid\` bigint unsigned DEFAULT NULL,
              \`compassid\` bigint unsigned DEFAULT NULL,
              \`ogravitationid\` bigint DEFAULT NULL,
              \`questionid\` bigint unsigned DEFAULT NULL,
              \`answerid\` bigint unsigned DEFAULT NULL,
              \`senderid\` bigint unsigned DEFAULT NULL,
              \`inviteduserid\` bigint unsigned DEFAULT NULL COMMENT '废弃',
              \`besenderid\` bigint unsigned NOT NULL,
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              \`status\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '00' COMMENT '00：全新 1：已读 01：被加载过',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=589 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_newsbysys\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`newssourceid\` bigint unsigned NOT NULL,
              \`isread\` int unsigned NOT NULL DEFAULT '0' COMMENT '0：未读 1：已读',
              \`unreadnums\` int unsigned NOT NULL DEFAULT '1',
              \`userid\` bigint unsigned NOT NULL,
              \`type\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '系统消息类型',
              \`typename\` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT '默认' COMMENT '系统消息类型名称',
              \`sendertype\` int NOT NULL DEFAULT '1' COMMENT '1:表示自动发送类型',
              \`title\` varchar(25) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_newssys\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`type\` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'normal',
              \`title\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_nicknames\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`name\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`nickname\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`),
              UNIQUE KEY \`name\` (\`name\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oentertools\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`oentertoolid\` bigint unsigned NOT NULL,
              \`name\` varchar(25) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0' COMMENT '1:必选；0：可选',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oo\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oerid\` int NOT NULL,
              \`opeopleid\` longtext COLLATE utf8mb3_unicode_ci,
              \`oback\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`post\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`obackid\` int NOT NULL DEFAULT '17',
              \`obacktype\` int unsigned NOT NULL DEFAULT '0' COMMENT '0:代表系统壁纸 1：代表上传壁纸',
              \`cover\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
              \`push\` int DEFAULT NULL,
              \`faith\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT '以一种有趣的方式动起来',
              \`fire\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '00001',
              \`activityorder\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` longtext COLLATE utf8mb3_unicode_ci,
              \`location\` longtext COLLATE utf8mb3_unicode_ci,
              \`country\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`province\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`city\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`district\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`cats\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '活动分类',
              \`tags\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`tools\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`tagssys\` longtext COLLATE utf8mb3_unicode_ci,
              \`theme\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`enablepicwalls\` int unsigned NOT NULL DEFAULT '1',
              \`publicstatus\` int unsigned NOT NULL DEFAULT '1' COMMENT '0:私密 1：表示公开',
              \`newstop\` bigint unsigned DEFAULT NULL COMMENT '置顶消息id',
              \`newsnum\` int unsigned NOT NULL DEFAULT '0',
              \`timeline\` longtext COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '时间线',
              \`time\` datetime DEFAULT CURRENT_TIMESTAMP,
              \`starttime\` datetime DEFAULT NULL,
              \`endtime\` datetime DEFAULT NULL,
              \`endtimemorecount\` int NOT NULL DEFAULT '5',
              \`endtimestatus\` int NOT NULL DEFAULT '0',
              \`end\` int unsigned NOT NULL DEFAULT '0' COMMENT '1：行动被删除了0：未被删除',
              \`close\` int NOT NULL DEFAULT '0',
              \`deletedestroy\` int unsigned NOT NULL DEFAULT '0',
              \`commentrate\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '5.0',
              \`hot\` int unsigned DEFAULT '0',
              \`friends\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`xiangyinstatus\` int NOT NULL DEFAULT '3',
              \`refusexiangyinanimaid\` int unsigned DEFAULT NULL,
              \`refusexiangyindes\` text COLLATE utf8mb3_unicode_ci,
              \`xiangyindes\` text COLLATE utf8mb3_unicode_ci,
              \`sceneusernums\` int NOT NULL DEFAULT '0',
              \`service\` longtext COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '服务',
              \`oerinfos\` longtext COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '发起者们',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=3676 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oo_comment\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`commentmemberuserid\` bigint unsigned NOT NULL,
              \`title\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`text\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`star\` int unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oo_compass\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`oerid\` bigint unsigned NOT NULL,
              \`message\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`odtime\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`odkeywords\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`preimage\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oo_fire\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`fireid\` int unsigned NOT NULL DEFAULT '1',
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oo_pri\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`oerid\` bigint unsigned NOT NULL,
              \`joinuserid\` bigint unsigned NOT NULL,
              \`usertype\` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0',
              \`wand\` int unsigned NOT NULL DEFAULT '0',
              \`joinin\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatecon\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`activitymodule\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`firenum\` int unsigned NOT NULL DEFAULT '1',
              \`isdoor\` int unsigned NOT NULL DEFAULT '0',
              \`compassreadidlist\` longtext COLLATE utf8mb3_unicode_ci,
              \`collapsecompass\` int unsigned NOT NULL DEFAULT '0',
              \`collapsecompassid\` bigint unsigned DEFAULT NULL,
              \`oqrcode\` longtext COLLATE utf8mb3_unicode_ci,
              \`sence\` int unsigned NOT NULL DEFAULT '0',
              \`morelife\` int unsigned NOT NULL DEFAULT '0',
              \`cardback\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`cardavatar\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`cardname\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`cardphone\` bigint DEFAULT NULL,
              \`carddes\` longtext COLLATE utf8mb3_unicode_ci,
              \`cardupdatetime\` int NOT NULL DEFAULT '1',
              \`res\` int NOT NULL DEFAULT '1',
              \`xiangyinstatus\` int unsigned NOT NULL DEFAULT '3' COMMENT 'x1:响应2:拒绝响应 3：失去响应【创建时间大于现在5min 默认',
              \`refusexiangyinanimaid\` int unsigned DEFAULT '1',
              \`refusexiangyindes\` text COLLATE utf8mb3_unicode_ci,
              \`xiangyindes\` text COLLATE utf8mb3_unicode_ci,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=6584 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oo_prires\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`resuserid\` bigint unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`res\` int NOT NULL DEFAULT '1',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=4981 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oosystem\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`fun\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'oo功能接口数据',
              \`con\` longtext COLLATE utf8mb3_unicode_ci,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oserviceanswer\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`questionid\` bigint unsigned NOT NULL,
              \`answeroneid\` bigint unsigned NOT NULL,
              \`parentid\` bigint unsigned NOT NULL DEFAULT '0',
              \`userid\` bigint unsigned NOT NULL,
              \`contype\` varchar(25) CHARACTER SET utf32 COLLATE utf32_unicode_ci NOT NULL DEFAULT 'text',
              \`timeforcon\` int unsigned NOT NULL DEFAULT '0',
              \`clienttime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`answer\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oserviceanswer_like\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`answerid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oserviceanswer_one\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`questionid\` bigint unsigned NOT NULL,
              \`end\` int unsigned NOT NULL DEFAULT '0',
              \`answer\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oservicequestion\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`question\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`beenanswer\` int NOT NULL DEFAULT '0',
              \`likecount\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_oservicequestion_like\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`questionid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_personauthe\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`usercitizenid\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`usercitizenname\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`idcardfrontimage\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`idcardbackimage\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`userwithidcardimage\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`userspeakvideo\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`userfacetestvideo\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0' COMMENT '0：审核中1：审核成功2：审核失败',
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=14584 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_professionalsauthe\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`personautheid\` bigint unsigned NOT NULL,
              \`type\` varchar(25) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`certificatetype\` int unsigned NOT NULL,
              \`certificateimage\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`certificatedes\` longtext COLLATE utf8mb3_unicode_ci,
              \`authename\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`authetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`authenamehis\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`status\` int unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_pushnewsmanage\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`type\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`compassid\` bigint unsigned DEFAULT NULL,
              \`questionid\` bigint unsigned DEFAULT NULL,
              \`answerid\` bigint unsigned DEFAULT NULL,
              \`senderid\` bigint unsigned DEFAULT NULL,
              \`inviteduserid\` bigint unsigned DEFAULT NULL COMMENT '废弃',
              \`besenderid\` bigint unsigned NOT NULL,
              \`con\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`status\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '00',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_qa_answer\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`userid\` bigint unsigned NOT NULL,
              \`qid\` bigint NOT NULL,
              \`oid\` bigint NOT NULL,
              \`answer\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`like\` longtext COLLATE utf8mb3_unicode_ci,
              \`likenum\` int unsigned NOT NULL DEFAULT '0',
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_qa_answer_like\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`oid\` bigint unsigned NOT NULL,
              \`qid\` int unsigned NOT NULL,
              \`aid\` int unsigned NOT NULL,
              \`userid\` int unsigned NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_qa_question\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`oid\` bigint unsigned NOT NULL,
              \`userid\` bigint unsigned NOT NULL,
              \`question\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`answernum\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_refusexiangyinanimadb\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`title\` varchar(12) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`anima\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`frame\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`name\` varchar(25) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`hidden\` int NOT NULL DEFAULT '0',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_report\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`userid\` bigint NOT NULL,
              \`beuserid\` bigint NOT NULL,
              \`beusername\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
              \`title\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
              \`des\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`check\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT ' 经审核，确定投诉对象存在违规行为',
              \`deal\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '已对其进行警告，感谢你的支持！',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_report_db\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`type\` int unsigned NOT NULL DEFAULT '0' COMMENT '举报的类型 0代表内容',
              \`con\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`level\` int unsigned NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_report_user\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`userid\` bigint unsigned NOT NULL,
              \`beuserid\` bigint unsigned DEFAULT NULL,
              \`reporttypeid\` int unsigned NOT NULL,
              \`reporttypedetail\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`reportsourceid\` bigint unsigned NOT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`status\` int unsigned NOT NULL DEFAULT '0' COMMENT '0：未处理1：处理完成',
              \`dealresultdes\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`dealresulttitle\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '举报结果反馈',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_search_history\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`userid\` int unsigned NOT NULL,
              \`con\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`isclear\` int unsigned NOT NULL DEFAULT '0',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_search_hot\` (
              \`id\` int unsigned NOT NULL AUTO_INCREMENT,
              \`title\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_search_record\` (
              \`id\` int NOT NULL AUTO_INCREMENT,
              \`con\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`location\` longtext COLLATE utf8mb3_unicode_ci,
              \`country\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`province\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`city\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`count\` bigint unsigned NOT NULL DEFAULT '1',
              \`provincecount\` bigint unsigned NOT NULL DEFAULT '1',
              \`citycount\` bigint unsigned NOT NULL DEFAULT '1',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=622 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_singal\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`type\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'text',
              \`con\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`sender\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`userat\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`titatime\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '300',
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_state\` (
              \`id\` bigint NOT NULL AUTO_INCREMENT,
              \`state\` varchar(225) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_tags\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`userid\` bigint unsigned NOT NULL,
              \`catid\` int unsigned DEFAULT NULL,
              \`con\` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_tags_kind\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`tag\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`parentid\` bigint unsigned NOT NULL DEFAULT '36',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`icon\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`image\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`des\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_tags_record\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`tag\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`count\` bigint unsigned NOT NULL DEFAULT '1',
              \`provicecount\` bigint unsigned NOT NULL DEFAULT '1',
              \`citycount\` bigint unsigned NOT NULL DEFAULT '1',
              \`country\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '中国',
              \`province\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '广东省',
              \`city\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '深圳',
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_userback\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`name\` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`imagename\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_usernames_db\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`username\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`usernickname\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`cat\` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`importid\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=50833 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_users\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`phonearea\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT '0086',
              \`phonenum\` bigint unsigned NOT NULL DEFAULT '0',
              \`mcode\` bigint DEFAULT '0',
              \`mcodetime\` bigint DEFAULT '0',
              \`username\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`usernickname\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`uniqid\` char(40) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`friend\` longtext COLLATE utf8mb3_unicode_ci,
              \`starfriend\` longtext COLLATE utf8mb3_unicode_ci,
              \`avatar\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`avatarabsolute\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`back\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`backabsolute\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`fire\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'fire-wood' COMMENT '火种',
              \`fireid\` int unsigned NOT NULL DEFAULT '1',
              \`mystate\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT '想动',
              \`mystatetime\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '状态保持时间包括起始于持续时间',
              \`push\` longtext COLLATE utf8mb3_unicode_ci,
              \`pushnum\` longtext COLLATE utf8mb3_unicode_ci,
              \`friendnum\` int NOT NULL DEFAULT '0',
              \`starfriendnum\` int NOT NULL DEFAULT '0',
              \`pushlast\` longtext COLLATE utf8mb3_unicode_ci,
              \`friendverifynum\` int NOT NULL DEFAULT '0',
              \`ootop\` bigint DEFAULT '0',
              \`backhead\` longtext COLLATE utf8mb3_unicode_ci,
              \`email\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`passw\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`userinvite\` longtext COLLATE utf8mb3_unicode_ci,
              \`oo\` int unsigned NOT NULL DEFAULT '0',
              \`onewest\` bigint unsigned DEFAULT NULL,
              \`opublicstatus\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
              \`searchhistory\` longtext COLLATE utf8mb3_unicode_ci,
              \`quserid\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`quserinfo\` varchar(500) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`appleuserinfo\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`appleuserid\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`updateapp\` int NOT NULL DEFAULT '1',
              \`updateserver\` int NOT NULL DEFAULT '1',
              \`serverversion\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1.5.7',
              \`style\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT 'orange',
              \`darkmode\` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT 'light',
              \`usernew\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`funnew\` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`useraction\` longtext COLLATE utf8mb3_unicode_ci NOT NULL,
              \`searchremcommend\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`herdes\` longtext COLLATE utf8mb3_unicode_ci,
              \`hertag\` varchar(5000) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`others\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`location\` longtext COLLATE utf8mb3_unicode_ci,
              \`mylocation\` longtext COLLATE utf8mb3_unicode_ci,
              \`avatar1\` longtext COLLATE utf8mb3_unicode_ci,
              \`authenticationstatus\` int unsigned NOT NULL DEFAULT '0' COMMENT '0：未验证2：验证中1：验证成功 3：验证失败',
              \`authenticationtype\` varchar(225) COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '                    personauthe:个人实名                     professionalsauthe：专业人士                     companyauthe：公司',
              \`mytags\` varchar(500) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
              \`importid\` varchar(5000) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'no',
              \`publicstatus\` int unsigned NOT NULL DEFAULT '0' COMMENT '0:私密 1：公开',
              \`guide\` longtext COLLATE utf8mb3_unicode_ci,
              \`usertype\` varchar(225) COLLATE utf8mb3_unicode_ci DEFAULT 'real',
              \`alipay_opendid\` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
              \`alipay_opendid_hash\` char(64) COLLATE utf8mb3_unicode_ci NOT NULL,
              PRIMARY KEY (\`id\`),
              UNIQUE KEY \`uniqid\` (\`uniqid\`),
              UNIQUE KEY \`username\` (\`username\`),
              KEY \`phonenum_2\` (\`phonenum\`),
              KEY \`phonenum_3\` (\`phonenum\`),
              KEY \`username_2\` (\`username\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=16101 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
            /*!40101 SET @saved_cs_client     = @@character_set_client */;
            /*!50503 SET character_set_client = utf8mb4 */;
            CREATE TABLE \`app_users_action_model\` (
              \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
              \`userid\` bigint unsigned NOT NULL,
              \`tag\` longtext COLLATE utf8mb3_unicode_ci,
              \`updatetime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              \`createtime\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB AUTO_INCREMENT=402 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
            /*!40101 SET character_set_client = @saved_cs_client */;
`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("DROP TABLE IF EXISTS \`app_users_action_model\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_users\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_usernames_db\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_userback\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_tags_record\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_tags_kind\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_tags\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_state\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_singal\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_search_record\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_search_hot\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_search_history\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_report_user\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_report_db\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_report\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_refusexiangyinanimadb\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_qa_question\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_qa_answer_like\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_qa_answer\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_pushnewsmanage\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_professionalsauthe\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_personauthe\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oservicequestion_like\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oservicequestion\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oserviceanswer_one\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oserviceanswer_like\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oserviceanswer\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oosystem\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oo_prires\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oo_pri\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oo_fire\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oo_compass\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oo_comment\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oo\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_oentertools\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_nicknames\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_newssys\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_newsbysys\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_newsbyo\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_newsbyfriend\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_newsbyfollow\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_news1\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_news\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_newfriendsverify\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_levelpictureswalllike\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_levelpictureswall\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_levelmodulesdb\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_levelmodules\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_levelmessage\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_level_pictureswall_pri\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_level_gravitation_check\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_level_gravitation\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_importmachineimageerror\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_friends_chats\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_friends\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_friend_verify\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_follows\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_fire\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_country\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_compass_con\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_compass\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_companyauthe\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_category_record\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_category\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_back\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_avatar\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_510oosingal\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_332oo\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`app_332friend\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_wau\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_system\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_soft\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_searchrecommend\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_oodiscomodule\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_notice\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_mau\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_manager\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_invitecode\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_intromodel\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_fun\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_exportsort\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_dms\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_discohotcon\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_discathot\`;");
        await queryRunner.query("DROP TABLE IF EXISTS \`admin_dau\`;");
    }
}
