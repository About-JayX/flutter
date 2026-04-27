import 'package:flutter/material.dart';
import 'package:mobisen_app/configs.dart';

class ConfigsProvider extends ChangeNotifier {
  Configs configs = Configs.instance;

  void onConfigChanged() {
    notifyListeners();
  }
}
