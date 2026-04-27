// src/common/transformers/decimal.transformer.ts

import { ValueTransformer } from 'typeorm';

/**
 * 创建用于 DECIMAL 字段的通用 transformer
 * @param scale 小数位数，默认 2（人民币）
 * @param allowNullable 是否允许 null，默认 true
 */
export function createDecimalTransformer(
  scale: number = 2,
  allowNullable: boolean = true,
): ValueTransformer {
  return {
    /**
     * 从实体（JS） → 数据库（string）
     */
    to(entityValue: number | null | undefined): string | null {
      if (entityValue == null) {
        if (!allowNullable) {
          throw new Error('Decimal field is required but got null/undefined');
        }
        return null;
      }

      if (typeof entityValue !== 'number' || isNaN(entityValue)) {
        throw new Error(`Invalid decimal value: ${entityValue}`);
      }

      // 检查是否超出小数位（可选）
      const str = entityValue.toString();
      const decimalIndex = str.indexOf('.');
      if (decimalIndex !== -1 && str.length - decimalIndex - 1 > scale) {
        // 可选择四舍五入或报错，这里建议报错以保证精度可控
        throw new Error(
          `Decimal value ${entityValue} exceeds scale ${scale}. Use .toFixed(${scale}) before assignment.`,
        );
      }

      return entityValue.toFixed(scale);
    },

    /**
     * 从数据库（string） → 实体（JS number）
     */
    from(databaseValue: string | null | undefined): number | null {
      if (databaseValue == null || databaseValue.trim() === '') {
        if (!allowNullable) {
          throw new Error('Decimal field is required but DB returned null/empty');
        }
        return null;
      }

      const num = Number(databaseValue);
      if (!isFinite(num)) {
        throw new Error(`Invalid decimal from DB: "${databaseValue}"`);
      }

      return num;
    },
  };
}