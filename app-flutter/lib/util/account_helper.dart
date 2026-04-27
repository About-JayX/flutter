import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/net/model/account.dart';

class AccountHelper {
  static late AccountHelper instance;
  Account? _account;

  Account? get account => _account;
  set account(Account? value) {
    _account = value;
    _setAccount(value);
  }

  static Future<void> init() async {
    instance = AccountHelper._();
    await instance._initAccount();
  }

  AccountHelper._();

  Future<void> _initAccount() async {
    try {
      final accountStr = Configs.instance.account.value;
      account = Account.fromJson(
          await compute((str) => const JsonDecoder().convert(str), accountStr));
    } catch (e) {}
  }

  void _setAccount(Account? account) async {
    try {
      final accountStr = account == null
          ? ""
          : await compute(
              (a) => const JsonEncoder().convert(a.toJson()), account);
      Configs.instance.account.value = accountStr;
    } catch (e) {}
  }
}
