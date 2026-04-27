import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface PurchaseVerification {
  valid: boolean;
  productId: string;
  subscriptionId: string;
  expiresDate: Date | null;
  status: string;
}

export interface SubscriberStatus {
  hasActiveSubscription: boolean;
  subscriptions: Array<{
    productId: string;
    expiresDate: Date | null;
    status: string;
  }>;
  entitlements: string[];
}

export interface RevenueCatWebhookPayload {
  event: RevenueCatEvent;
}

export interface RevenueCatEvent {
  type: string;
  app_user_id: string;
  product_id: string;
  expires_at?: string;
  unsubscribe_detected_at?: string;
  [key: string]: any;
}

@Injectable()
export class RevenueCatService {
  private readonly logger = new Logger(RevenueCatService.name);
  private readonly apiKey: string;
  private readonly webhookSecret: string;

  constructor(private readonly configService: ConfigService) {
    this.apiKey = this.configService.get('REVENUECAT_API_KEY') || '';
    this.webhookSecret =
      this.configService.get('REVENUECAT_WEBHOOK_SECRET') || '';
  }

  async verifyPurchase(
    userId: string,
    receipt: string,
    platform: 'ios' | 'android',
  ): Promise<PurchaseVerification> {
    try {
      const response = await fetch('https://api.revenuecat.com/v1/receipts', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.apiKey}`,
          'X-Platform': platform,
        },
        body: JSON.stringify({
          app_user_id: userId,
          fetch_token: receipt,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Receipt verification failed');
      }

      const subscription = data.subscriber?.subscriptions?.[data.product_id];

      return {
        valid: true,
        productId: data.product_id,
        subscriptionId: subscription?.purchase_token || '',
        expiresDate: subscription?.expires_date
          ? new Date(subscription.expires_date)
          : null,
        status: this.mapSubscriptionStatus(subscription),
      };
    } catch (error) {
      this.logger.error('RevenueCat verification failed', error);
      throw new BadRequestException('购买验证失败');
    }
  }

  async getSubscriberStatus(userId: string): Promise<SubscriberStatus> {
    try {
      const response = await fetch(
        `https://api.revenuecat.com/v1/subscribers/${userId}`,
        {
          headers: {
            Authorization: `Bearer ${this.apiKey}`,
          },
        },
      );

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Failed to get subscriber status');
      }

      const subscriptions = data.subscriber?.subscriptions || {};
      const entitlements = data.subscriber?.entitlements || {};

      return {
        hasActiveSubscription: Object.values(subscriptions).some(
          (sub: any) =>
            sub.expires_date && new Date(sub.expires_date) > new Date(),
        ),
        subscriptions: Object.entries(subscriptions).map(
          ([productId, sub]: [string, any]) => ({
            productId,
            expiresDate: sub.expires_date ? new Date(sub.expires_date) : null,
            status: this.mapSubscriptionStatus(sub),
          }),
        ),
        entitlements: Object.keys(entitlements),
      };
    } catch (error) {
      this.logger.error('Failed to get subscriber status', error);
      throw new BadRequestException('获取订阅状态失败');
    }
  }

  async handleWebhook(payload: RevenueCatWebhookPayload): Promise<void> {
    const { event } = payload;

    this.logger.log(`Received RevenueCat webhook event: ${event.type}`);

    switch (event.type) {
      case 'INITIAL_PURCHASE':
        await this.handleInitialPurchase(event);
        break;
      case 'RENEWAL':
        await this.handleRenewal(event);
        break;
      case 'CANCELLATION':
        await this.handleCancellation(event);
        break;
      case 'EXPIRATION':
        await this.handleExpiration(event);
        break;
      case 'REFUND':
        await this.handleRefund(event);
        break;
      default:
        this.logger.warn(`Unhandled RevenueCat event type: ${event.type}`);
    }
  }

  private async handleInitialPurchase(event: RevenueCatEvent): Promise<void> {
    this.logger.log(
      `Initial purchase for user ${event.app_user_id}, product ${event.product_id}`,
    );
  }

  private async handleRenewal(event: RevenueCatEvent): Promise<void> {
    this.logger.log(
      `Renewal for user ${event.app_user_id}, product ${event.product_id}`,
    );
  }

  private async handleCancellation(event: RevenueCatEvent): Promise<void> {
    this.logger.log(`Cancellation for user ${event.app_user_id}`);
  }

  private async handleExpiration(event: RevenueCatEvent): Promise<void> {
    this.logger.log(`Expiration for user ${event.app_user_id}`);
  }

  private async handleRefund(event: RevenueCatEvent): Promise<void> {
    this.logger.log(`Refund for user ${event.app_user_id}`);
  }

  private mapSubscriptionStatus(subscription: any): string {
    if (!subscription) return 'expired';

    const expiresDate = subscription.expires_date
      ? new Date(subscription.expires_date)
      : null;

    if (!expiresDate || expiresDate <= new Date()) {
      return 'expired';
    }

    if (subscription.unsubscribe_detected_at) {
      return 'cancelled';
    }

    return 'active';
  }

  getSubscriptionType(productId: string): string {
    if (productId.includes('weekly') || productId.includes('week')) {
      return 'weekly';
    }
    if (productId.includes('monthly') || productId.includes('month')) {
      return 'monthly';
    }
    return 'unknown';
  }
}
