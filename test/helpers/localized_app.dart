import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/l10n/app_locales.dart';
import 'package:movie_ticket_mobile/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Call from `setUpAll` before pumping [localizedApp].
Future<void> initTestLocalization() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
}

/// [home] inside EasyLocalization ([locale], English by default) and a MaterialApp
/// with the app's dark theme. [onGenerateRoute] answers named pushes from [home].
Widget localizedApp(Widget home, {Locale locale = AppLocales.en, RouteFactory? onGenerateRoute}) => EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.en,
      startLocale: locale,
      saveLocale: false,
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.dark,
          home: home,
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );

/// Pumps [localizedApp] and waits for translations. The asset and the
/// Localizations delegate load with futures that only complete in real async,
/// so the first frames are built inside `runAsync`.
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget home, {
  Locale locale = AppLocales.en,
  RouteFactory? onGenerateRoute,
}) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(localizedApp(home, locale: locale, onGenerateRoute: onGenerateRoute));
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await tester.pump();
    }
  });
  // Not pumpAndSettle: a loading spinner never settles.
  await tester.pump();
}
