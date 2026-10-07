import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../model/home_summary.dart';

part 'shell_state.freezed.dart';

@freezed
sealed class ShellState with _$ShellState {
  const factory ShellState.initial() = ShellInitial;
  const factory ShellState.loading() = ShellLoading;
  /// [savedAt] is set when the server could not be reached and [summary] is the
  /// copy saved on this phone (sprint 21): Home is showing saved data.
  const factory ShellState.ready(HomeSummary summary, {DateTime? savedAt}) = ShellReady;
  const factory ShellState.failure(ApiFailure failure) = ShellFailure;
}
