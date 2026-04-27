import { MigrationInterface, QueryRunner } from 'typeorm';

export class RemoveAlipay1745731200000 implements MigrationInterface {
  name = 'RemoveAlipay1745731200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // 1. 移除用户表支付宝字段
    await queryRunner.query(`ALTER TABLE app_users DROP COLUMN alipay_opendid`);
    await queryRunner.query(
      `ALTER TABLE app_users DROP COLUMN alipay_opendid_hash`,
    );
    await queryRunner.query(
      `ALTER TABLE app_users DROP COLUMN alipay_openphone_encrypted`,
    );

    // 2. 更新 pay_method 默认值（alipay → free）
    await queryRunner.query(
      `ALTER TABLE app_pay ALTER COLUMN pay_method SET DEFAULT 'free'`,
    );

    // 3. 更新现有数据
    await queryRunner.query(
      `UPDATE app_pay SET pay_method = 'free' WHERE pay_method = 'alipay'`,
    );

    // 4. 更新提现渠道默认值
    await queryRunner.query(
      `ALTER TABLE app_withdraw ALTER COLUMN channel SET DEFAULT 'bank'`,
    );
    await queryRunner.query(
      `UPDATE app_withdraw SET channel = 'bank' WHERE channel = 'alipay'`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // 恢复用户表支付宝字段
    await queryRunner.query(
      `ALTER TABLE app_users ADD COLUMN alipay_opendid varchar(64) NULL`,
    );
    await queryRunner.query(
      `ALTER TABLE app_users ADD COLUMN alipay_opendid_hash char(64) NULL`,
    );
    await queryRunner.query(
      `ALTER TABLE app_users ADD COLUMN alipay_openphone_encrypted text NULL`,
    );

    // 恢复默认值
    await queryRunner.query(
      `ALTER TABLE app_pay ALTER COLUMN pay_method SET DEFAULT 'alipay'`,
    );
    await queryRunner.query(
      `ALTER TABLE app_withdraw ALTER COLUMN channel SET DEFAULT 'alipay'`,
    );
  }
}
