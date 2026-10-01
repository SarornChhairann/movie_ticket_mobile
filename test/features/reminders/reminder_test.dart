import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/reminders/controller/reminder_bloc.dart';
import 'package:movie_ticket_mobile/features/reminders/model/reminder_repository.dart';

import '../../helpers/fake_adapter.dart';

class _MockReminderRepository extends Mock implements ReminderRepository {}

void main() {
  group('ReminderBloc', () {
    late _MockReminderRepository repository;

    setUp(() => repository = _MockReminderRepository());

    void stub(Result<void, ReminderFailure> result) =>
        when(() => repository.subscribe(movieId: any(named: 'movieId'), email: any(named: 'email')))
            .thenAnswer((_) async => result);

    blocTest<ReminderBloc, ReminderState>(
      'success',
      setUp: () => stub(const Ok(null)),
      build: () => ReminderBloc(repository),
      act: (bloc) => bloc.add(const SubmitRequested(movieId: 7, email: 'dara@example.com')),
      expect: () => const [ReminderState.submitting(), ReminderState.success()],
      verify: (_) => verify(() => repository.subscribe(movieId: 7, email: 'dara@example.com')).called(1),
    );

    blocTest<ReminderBloc, ReminderState>(
      'REMINDER_EXISTS is alreadySubscribed, not a failure',
      setUp: () => stub(const Err(ReminderExists('You are already subscribed.'))),
      build: () => ReminderBloc(repository),
      act: (bloc) => bloc.add(const SubmitRequested(movieId: 7, email: 'dara@example.com')),
      expect: () => const [ReminderState.submitting(), ReminderState.alreadySubscribed()],
    );

    blocTest<ReminderBloc, ReminderState>(
      'a 400 shows the server message',
      setUp: () => stub(const Err(ReminderRejected('Please enter a valid email address.'))),
      build: () => ReminderBloc(repository),
      act: (bloc) => bloc.add(const SubmitRequested(movieId: 7, email: 'x@y')),
      expect: () => const [
        ReminderState.submitting(),
        ReminderState.failure('Please enter a valid email address.'),
      ],
    );

    blocTest<ReminderBloc, ReminderState>(
      'a second submit while one is in flight is ignored',
      build: () => ReminderBloc(repository),
      seed: () => const ReminderState.submitting(),
      act: (bloc) => bloc.add(const SubmitRequested(movieId: 7, email: 'dara@example.com')),
      expect: () => const <ReminderState>[],
    );
  });

  group('ReminderRepository', () {
    late FakeAdapter adapter;
    late ReminderRepository repository;

    void serve(int status, Object body) {
      adapter = FakeAdapter((_) async => jsonBody(status, body));
      repository = ReminderRepository(Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter);
    }

    test('posts movieId and trimmed email', () async {
      serve(200, {'ok': true});

      expect(await repository.subscribe(movieId: 7, email: ' dara@example.com '), isA<Ok<void, ReminderFailure>>());
      final request = adapter.requests.single;
      expect(request.path, '/api/reminders');
      expect(request.data, {'movieId': 7, 'email': 'dara@example.com'});
    });

    test('409 REMINDER_EXISTS maps to ReminderExists; 400 to ReminderRejected', () async {
      serve(409, {'error': 'Already.', 'type': 'CONFLICT', 'code': 'REMINDER_EXISTS'});
      expect((await repository.subscribe(movieId: 7, email: 'a@b.co') as Err).failure, isA<ReminderExists>());

      serve(400, {'error': 'Movie not found: 7', 'type': 'BAD_REQUEST'});
      final failure = (await repository.subscribe(movieId: 7, email: 'a@b.co') as Err).failure as ReminderFailure;
      expect(failure, isA<ReminderRejected>());
      expect(failure.message, 'Movie not found: 7');
    });
  });
}
