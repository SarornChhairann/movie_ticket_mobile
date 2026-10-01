import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/profile/controller/profile_bloc.dart';
import 'package:movie_ticket_mobile/features/profile/model/profile_repository.dart';

import '../auth/auth_fixtures.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockProfileRepository repository;
  final renamed = testUser.copyWith(name: 'Dara S.', phone: '099');

  setUp(() => repository = _MockProfileRepository());

  blocTest<ProfileBloc, ProfileState>(
    'loads the profile',
    setUp: () => when(() => repository.fetch()).thenAnswer((_) async => const Ok(testUser)),
    build: () => ProfileBloc(repository),
    act: (bloc) => bloc.add(const ProfileLoaded()),
    expect: () => const [ProfileState.loading(), ProfileState.ready(testUser)],
  );

  blocTest<ProfileBloc, ProfileState>(
    'save success returns the new user and a saved notice',
    setUp: () => when(() => repository.update(name: 'Dara S.', phone: '099'))
        .thenAnswer((_) async => Ok(renamed)),
    build: () => ProfileBloc(repository),
    seed: () => const ProfileState.ready(testUser),
    act: (bloc) => bloc.add(const ProfileSaved(name: 'Dara S.', phone: '099')),
    expect: () => [
      const ProfileState.ready(testUser, saving: true),
      ProfileState.ready(renamed, notice: ProfileNotice.saved),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'save failure keeps the user and shows the server message',
    setUp: () => when(() => repository.update(name: any(named: 'name'), phone: any(named: 'phone')))
        .thenAnswer((_) async => const Err(ApiFailure.server(status: 400, message: 'Bad phone'))),
    build: () => ProfileBloc(repository),
    seed: () => const ProfileState.ready(testUser),
    act: (bloc) => bloc.add(const ProfileSaved(name: 'Dara', phone: 'x')),
    expect: () => const [
      ProfileState.ready(testUser, saving: true),
      ProfileState.ready(testUser, error: 'Bad phone'),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'wrong current password shows the server message',
    setUp: () => when(() => repository.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
          confirmPassword: any(named: 'confirmPassword'),
        )).thenAnswer(
      (_) async => const Err(ApiFailure.server(status: 400, message: 'Current password is incorrect.')),
    ),
    build: () => ProfileBloc(repository),
    seed: () => const ProfileState.ready(testUser),
    act: (bloc) => bloc.add(const PasswordChangeRequested(
      currentPassword: 'nope00',
      newPassword: 'secret2',
      confirmPassword: 'secret2',
    )),
    expect: () => const [
      ProfileState.ready(testUser, saving: true),
      ProfileState.ready(testUser, error: 'Current password is incorrect.'),
    ],
  );
}
