import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../auth/controller/auth_bloc.dart';

/// Profile entry for a signed-in user, Sign in for a guest.
class AccountAction extends StatelessWidget {
  const AccountAction({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      return IconButton(
        key: const Key('shell.profile'),
        tooltip: 'profile.title'.tr(context: context),
        icon: const Icon(Icons.account_circle_outlined),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
      );
    }
    return TextButton(
      key: const Key('shell.signIn'),
      onPressed: () => context.read<AuthBloc>().add(const SignInRequested()),
      child: Text('auth.signIn'.tr(context: context)),
    );
  }
}
