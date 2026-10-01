import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../auth/controller/auth_bloc.dart';
import '../../auth/model/user.dart';
import '../controller/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile.title'.tr(context: context))),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileInitial() || ProfileLoading() => const LoadingView(),
          ProfileReady(:final user) => _ProfileBody(user: user),
          ProfileFailure(:final failure) => ErrorView(
              message: switch (failure) {
                ApiFailureServer(:final message) => message,
                ApiFailureNetwork() => 'shell.offline'.tr(context: context),
                ApiFailureUnknown(:final message) => message ?? '',
              },
              onRetry: () => context.read<ProfileBloc>().add(const ProfileLoaded()),
            ),
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileBloc = context.read<ProfileBloc>();
    return ListView(
      padding: const EdgeInsets.all(Space.x2),
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(user.name, style: textTheme.titleMedium),
          subtitle: Text(user.email),
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: Text('profile.phone'.tr(context: context)),
          subtitle: Text(user.phone?.isNotEmpty == true ? user.phone! : '—'),
        ),
        ListTile(
          leading: const Icon(Icons.stars_outlined),
          title: Text('profile.points'.tr(context: context)),
          trailing: Text('${user.points}', key: const Key('profile.points'), style: textTheme.titleMedium),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: Text('profile.edit'.tr(context: context)),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile, arguments: profileBloc),
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: Text('profile.changePassword'.tr(context: context)),
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoutes.changePassword, arguments: profileBloc),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text('auth.logout'.tr(context: context)),
          onTap: () => context.read<AuthBloc>().add(const LogoutRequested()),
        ),
      ],
    );
  }
}
