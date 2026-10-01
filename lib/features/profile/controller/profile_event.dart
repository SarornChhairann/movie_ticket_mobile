sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoaded extends ProfileEvent {
  const ProfileLoaded();
}

final class ProfileSaved extends ProfileEvent {
  const ProfileSaved({required this.name, required this.phone});

  final String name;
  final String phone;
}

final class PasswordChangeRequested extends ProfileEvent {
  const PasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
}
