import 'package:intl/intl.dart';

/// Display-only money formatting in [locale] (prices are USD). Never use the
/// result for arithmetic; totals come from the server.
String formatMoney(num amount, {String locale = 'en'}) =>
    NumberFormat.currency(locale: locale, symbol: r'$', decimalDigits: 2).format(amount);
