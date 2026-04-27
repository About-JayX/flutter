import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/log.dart';

mixin UserMembershipMixin {
  void updateUserMembershipAction(AccountProvider accountProvider,
      {Function? onSubscriptionExpired}) async {
    LogD("UserMembershipMixin-updateUserMembershipAction");
    try {
      if (!await Purchases.isConfigured) {
        return;
      }
      CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
      bool isPro = (accountProvider.account?.user.membership?.level ?? 0) != 0;
      LogD(
          "UserMembershipMixin-updateUserMembershipAction-purchaserInfo:\n${purchaserInfo.entitlements.active.isNotEmpty}");
      LogD("UserMembershipMixin-updateUserMembershipAction-isPro:\n$isPro");
      if (!purchaserInfo.entitlements.active.isNotEmpty && isPro) {
        accountProvider.updateAccountProfile();
        onSubscriptionExpired?.call(true);
      }
    } catch (e) {
      LogE("_updateUserMembershipAction():\n$e");
    }
  }
}
