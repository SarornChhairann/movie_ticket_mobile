import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/l10n/app_locales.dart';

/// EN / ខ្មែរ switch. EasyLocalization persists the choice across restarts.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isKm = context.locale.languageCode == AppLocales.km.languageCode;
    return TextButton.icon(
      key: const Key('languageToggle'),
      onPressed: () => context.setLocale(isKm ? AppLocales.en : AppLocales.km),
      icon: const Icon(Icons.translate),
      label: Text(isKm ? 'ខ្មែរ' : 'EN'),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
