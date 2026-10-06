import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/payway.dart';

part 'payway_state.freezed.dart';

@freezed
abstract class PaywayState with _$PaywayState {
  const factory PaywayState({
    required PaywayLaunch launch,

    /// Polls that failed in a row; the message shows from the third.
    @Default(0) int failures,

    /// Server or network message after three failures in a row; the page stays open.
    String? message,

    /// The close call is running.
    @Default(false) bool closing,

    /// Set once; the view pops with it.
    PaywayOutcome? outcome,
  }) = _PaywayState;
}
