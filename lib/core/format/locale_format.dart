import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import 'money.dart';
import 'show_time.dart';

/// Formatting in the current app language. Reading `context.locale` subscribes the
/// widget, so a language switch on the shell reformats the screen.
extension LocaleFormat on BuildContext {
  String get _localeName => locale.toString();

  String money(num amount) => formatMoney(amount, locale: _localeName);

  String showLine({String? hallName, String? showDate, String? showTime}) =>
      formatShowLine(hallName: hallName, showDate: showDate, showTime: showTime, locale: _localeName);
}
