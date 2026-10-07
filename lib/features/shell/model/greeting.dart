import '../../../core/format/cinema_clock.dart';

/// Home's time-of-day greeting (sprint 22, H9), by the cinema's clock rather
/// than the phone's zone: morning before 12:00, afternoon before 18:00, then evening.
enum DayPart { morning, afternoon, evening }

DayPart dayPartAt(DateTime instant) => switch (CinemaClock.now(instant).hour) {
      < 12 => DayPart.morning,
      < 18 => DayPart.afternoon,
      _ => DayPart.evening,
    };

/// The first word of the profile name, or null when there is none.
String? firstName(String? name) {
  final first = name?.trim().split(RegExp(r'\s+')).first ?? '';
  return first.isEmpty ? null : first;
}

/// The translation key for [part], with the name (`.named`) or without (`.plain`).
String greetingKey(DayPart part, {required bool named}) => 'home.greeting.${part.name}.${named ? 'named' : 'plain'}';
