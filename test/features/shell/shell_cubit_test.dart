import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_cubit.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_state.dart';
import 'package:movie_ticket_mobile/features/shell/model/home_summary.dart';
import 'package:movie_ticket_mobile/features/shell/model/shell_repository.dart';

class _MockShellRepository extends Mock implements ShellRepository {}

void main() {
  late _MockShellRepository repository;
  const summary = HomeSummary(nowShowingCount: 4, comingSoonCount: 2, cinemaCount: 1);

  setUp(() => repository = _MockShellRepository());

  blocTest<ShellCubit, ShellState>(
    'emits loading then ready when the API answers',
    setUp: () => when(() => repository.fetchHome()).thenAnswer((_) async => const Ok(summary)),
    build: () => ShellCubit(repository),
    act: (cubit) => cubit.pingRequested(),
    expect: () => const [ShellState.loading(), ShellState.ready(summary)],
  );

  blocTest<ShellCubit, ShellState>(
    'emits loading then failure when the API is unreachable',
    setUp: () => when(() => repository.fetchHome())
        .thenAnswer((_) async => const Err(ApiFailure.network())),
    build: () => ShellCubit(repository),
    act: (cubit) => cubit.pingRequested(),
    expect: () => const [ShellState.loading(), ShellState.failure(ApiFailure.network())],
  );
}
