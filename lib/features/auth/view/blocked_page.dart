import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/spacing.dart';
import '../controller/auth_bloc.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final message = state is AuthBlockedState ? state.message : '';
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.x3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block, size: Space.x6, color: theme.colorScheme.error),
                const SizedBox(height: Space.x2),
                Text(
                  'auth.blocked'.tr(context: context),
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: Space.x1),
                  Text(message, textAlign: TextAlign.center),
                ],
                const SizedBox(height: Space.x3),
                FilledButton(
                  onPressed: () => context.read<AuthBloc>().add(const BlockedAcknowledged()),
                  child: Text('auth.backToLogin'.tr(context: context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
