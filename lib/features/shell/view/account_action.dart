import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_list_tile.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/controller/auth_bloc.dart';

/// Home avatar. [onTap] opens the account: Profile when signed in, otherwise
/// sign-in first (the shell decides via `requireSignIn`).
class AccountAction extends StatelessWidget {
  const AccountAction({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final signedIn = state is AuthAuthenticated;
    final initial = signedIn && state.user.name.isNotEmpty ? state.user.name.characters.first.toUpperCase() : null;
    return Tooltip(
      message: (signedIn ? 'profile.title' : 'auth.signIn').tr(context: context),
      child: PressableInkWell(
        key: Key(signedIn ? 'shell.profile' : 'shell.signIn'),
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.navyHigh,
          foregroundColor: AppColors.white,
          child: initial == null ? const Icon(Icons.person_outline) : Text(initial),
        ),
      ),
    );
  }
}
