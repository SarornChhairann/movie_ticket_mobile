import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/result.dart';
import '../model/shell_repository.dart';
import 'shell_state.dart';

/// Tracks API connectivity for the home shell. Locale is owned by
/// EasyLocalization, not duplicated here.
class ShellCubit extends Cubit<ShellState> {
  ShellCubit(this._repository) : super(const ShellState.initial());

  final ShellRepository _repository;

  Future<void> pingRequested() async {
    emit(const ShellState.loading());
    final result = await _repository.fetchHome();
    emit(switch (result) {
      Ok(:final value) => ShellState.ready(value),
      Err(:final failure) => ShellState.failure(failure),
    });
  }
}
