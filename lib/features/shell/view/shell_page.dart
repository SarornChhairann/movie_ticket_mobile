import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_banner.dart';
import '../../catalog/view/movie_list_view.dart';
import '../controller/shell_cubit.dart';
import '../controller/shell_state.dart';
import 'account_action.dart';
import 'language_toggle.dart';

/// Home: app bar (language, account), a connectivity banner, and the catalog.
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app.title'.tr(context: context)),
        actions: const [LanguageToggle(), AccountAction(), SizedBox(width: Space.x1)],
      ),
      body: Column(
        children: [
          BlocBuilder<ShellCubit, ShellState>(
            builder: (context, state) => switch (state) {
              ShellFailure(:final failure) => ErrorBanner(
                  key: const Key('shell.offlineBanner'),
                  message: _messageOf(context, failure),
                  onDismiss: () => context.read<ShellCubit>().pingRequested(),
                ),
              _ => const SizedBox.shrink(),
            },
          ),
          const Expanded(child: MovieListView()),
        ],
      ),
    );
  }

  String _messageOf(BuildContext context, ApiFailure failure) => switch (failure) {
        ApiFailureServer(:final message) => message,
        ApiFailureNetwork() => 'shell.offline'.tr(context: context),
        ApiFailureUnknown(:final message) => message ?? '',
      };
}
