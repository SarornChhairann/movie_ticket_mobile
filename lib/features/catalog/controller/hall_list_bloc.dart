import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/hall.dart';
import '../model/hall_repository.dart';

part 'hall_list_bloc.freezed.dart';

sealed class HallListEvent {
  const HallListEvent();
}

final class LoadRequested extends HallListEvent {
  const LoadRequested();
}

/// Pull to refresh: the rows stay on screen while it runs.
final class RefreshRequested extends HallListEvent {
  const RefreshRequested();
}

/// City filter on the loaded halls; `null` is All. No API call.
final class HallCitySelected extends HallListEvent {
  const HallCitySelected(this.city);

  final String? city;
}

/// Type filter on the loaded halls; `null` is All. No API call.
final class HallTypeSelected extends HallListEvent {
  const HallTypeSelected(this.type);

  final String? type;
}

/// Flips "Dolby Atmos only".
final class HallDolbyToggled extends HallListEvent {
  const HallDolbyToggled();
}

/// Flips "ScreenX only".
final class HallScreenXToggled extends HallListEvent {
  const HallScreenXToggled();
}

/// City, type, Dolby, and ScreenX back to All / off. No API call.
final class HallFiltersCleared extends HallListEvent {
  const HallFiltersCleared();
}

/// Every case carries the hall filters, so they survive loading and refresh.
@freezed
sealed class HallListState with _$HallListState {
  const HallListState._();

  const factory HallListState.initial({
    String? city,
    String? type,
    @Default(false) bool dolbyOnly,
    @Default(false) bool screenXOnly,
  }) = HallListInitial;

  const factory HallListState.loading({
    String? city,
    String? type,
    @Default(false) bool dolbyOnly,
    @Default(false) bool screenXOnly,
  }) = HallListLoading;

  const factory HallListState.ready(
    List<Hall> halls, {
    String? city,
    String? type,
    @Default(false) bool dolbyOnly,
    @Default(false) bool screenXOnly,
  }) = HallListReady;

  const factory HallListState.failure(
    ApiFailure failure, {
    String? city,
    String? type,
    @Default(false) bool dolbyOnly,
    @Default(false) bool screenXOnly,
  }) = HallListFailure;

  /// Distinct cities on the loaded halls, A–Z ignoring case; the selected one is kept.
  List<String> get cities => _choices((h) => h.city, city);

  /// Distinct types on the loaded halls, A–Z ignoring case; the selected one is kept.
  List<String> get types => _choices((h) => h.type, type);

  /// Hall filters that are not All / off (for the tune badge).
  int get activeFilterCount => [city != null, type != null, dolbyOnly, screenXOnly].where((on) => on).length;

  /// [halls] after [search] and every hall filter in this state.
  List<Hall> visible(List<Hall> halls, String search) => filterHalls(halls, search,
      city: city, type: type, dolbyOnly: dolbyOnly, screenXOnly: screenXOnly);

  List<String> _choices(String? Function(Hall) field, String? selected) {
    final s = this;
    final set = <String>{
      if (s is HallListReady)
        for (final h in s.halls)
          if (field(h) != null && field(h)!.trim().isNotEmpty) field(h)!.trim(),
      ?selected,
    };
    return set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }
}

/// Home's **Halls** section. Independent of the movie list, so either can fail alone.
class HallListBloc extends Bloc<HallListEvent, HallListState> {
  HallListBloc(this._repository) : super(const HallListState.initial()) {
    on<LoadRequested>((_, emit) => _load(emit));
    on<RefreshRequested>((_, emit) => _load(emit));
    on<HallCitySelected>((event, emit) => emit(state.copyWith(city: event.city)));
    on<HallTypeSelected>((event, emit) => emit(state.copyWith(type: event.type)));
    on<HallDolbyToggled>((_, emit) => emit(state.copyWith(dolbyOnly: !state.dolbyOnly)));
    on<HallScreenXToggled>((_, emit) => emit(state.copyWith(screenXOnly: !state.screenXOnly)));
    on<HallFiltersCleared>(
      (_, emit) => emit(state.copyWith(city: null, type: null, dolbyOnly: false, screenXOnly: false)),
    );
  }

  final HallRepository _repository;

  Future<void> _load(Emitter<HallListState> emit) async {
    if (state is! HallListReady) {
      emit(HallListState.loading(
          city: state.city, type: state.type, dolbyOnly: state.dolbyOnly, screenXOnly: state.screenXOnly));
    }
    final result = await _repository.fetchHalls();
    // Filters are read now: they may have changed while loading.
    switch (result) {
      case Ok(:final value):
        emit(HallListState.ready(value,
            city: state.city, type: state.type, dolbyOnly: state.dolbyOnly, screenXOnly: state.screenXOnly));
      case Err(:final failure):
        // A failed refresh keeps the rows already shown.
        if (state is! HallListReady) {
          emit(HallListState.failure(failure,
              city: state.city, type: state.type, dolbyOnly: state.dolbyOnly, screenXOnly: state.screenXOnly));
        }
    }
  }
}
