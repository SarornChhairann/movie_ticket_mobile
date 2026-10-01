import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../model/home_summary.dart';

part 'shell_state.freezed.dart';

@freezed
sealed class ShellState with _$ShellState {
  const factory ShellState.initial() = ShellInitial;
  const factory ShellState.loading() = ShellLoading;
  const factory ShellState.ready(HomeSummary summary) = ShellReady;
  const factory ShellState.failure(ApiFailure failure) = ShellFailure;
}
