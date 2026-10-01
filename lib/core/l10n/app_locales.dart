import 'package:flutter/widgets.dart';

abstract final class AppLocales {
  static const en = Locale('en');
  static const km = Locale('km');
  static const supported = [en, km];
  static const path = 'assets/translations';
}
