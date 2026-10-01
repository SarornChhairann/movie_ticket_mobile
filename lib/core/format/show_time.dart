import 'package:intl/intl.dart';

/// `showDate` (ISO date, cinema zone) as a localized date, e.g. `Wed, Oct 7, 2026`.
/// Never converted with the device zone. Falls back to the raw value.
String formatShowDate(String isoDate, {String locale = 'en'}) {
  final date = DateTime.tryParse(isoDate);
  return date == null ? isoDate : DateFormat.yMMMEd(locale).format(date);
}

/// `HH:mm[:ss]` → `HH:mm`.
String formatShowTime(String time) => time.length < 5 ? time : time.substring(0, 5);

/// `Hall · date · HH:mm`, skipping missing parts.
String formatShowLine({String? hallName, String? showDate, String? showTime, String locale = 'en'}) => [
      if (hallName != null && hallName.isNotEmpty) hallName,
      if (showDate != null && showDate.isNotEmpty) formatShowDate(showDate, locale: locale),
      if (showTime != null && showTime.isNotEmpty) formatShowTime(showTime),
    ].join(' · ');
