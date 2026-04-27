import 'package:flutter/material.dart';
import 'package:mobisen_app/configs.dart';

class LocaleProvider extends ChangeNotifier {
  static Configs get _configs => Configs.instance;

  AppLocale? _locale = _findLocale(_configs.locale.value);

  Locale? get locale {
    return (_locale ?? AppLocale.en).locale;
  }

  void setLocale(AppLocale locale) {
    _locale = locale;
    _configs.locale.value = locale.name;
    notifyListeners();
  }

  static AppLocale? _findLocale(String name) {
    for (var style in AppLocale.values) {
      if (style.name == name) {
        return style;
      }
    }
    return null;
  }
}

enum AppLocale {
  en("English", Locale("en")),
  es("Español", Locale("es"));
  // pt("Português", Locale("pt"));

  final String displayName;
  final Locale locale;

  const AppLocale(this.displayName, this.locale);
}
