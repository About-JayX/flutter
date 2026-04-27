import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/provider/locale_provider.dart';

class LocalePickerView extends StatelessWidget {
  const LocalePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.app_name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.languages.image(width: 140, height: 140),
          const SizedBox(height: 8),
          Text(
            S.current.language,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            S.current.can_be_changed_in_settings,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          ...AppLocale.values.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                child: InkWell(
                  onTap: () {
                    localeProvider.setLocale(e);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        e.displayName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
