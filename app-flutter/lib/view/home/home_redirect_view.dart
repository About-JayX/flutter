import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/provider/locale_provider.dart';
import 'package:mobisen_app/view/home/home_tabs_view.dart';
import 'package:mobisen_app/view/home/locale_picker_view.dart';

class HomeRedirectView extends StatelessWidget {
  const HomeRedirectView({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    if (localeProvider.locale == null) {
      return const LocalePickerView();
    }
    return const HomeTabsView();
  }
}
