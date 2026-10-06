import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/spacing.dart';
import '../../catalog/model/movie.dart';
import '../controller/reminder_bloc.dart';
import 'reminder_form.dart';

/// Remind me from the Home carousel: the sprint 7 reminder form in a bottom
/// sheet. Closes with `true` once the email is subscribed (or already was), after
/// a short pause so the confirmation is seen.
class ReminderSheet extends StatelessWidget {
  const ReminderSheet({super.key, required this.movie});

  final Movie movie;

  /// How long the success message stays before the sheet closes.
  static const confirmHold = Motion.confirmHold;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<ReminderBloc, ReminderState>(
      listenWhen: (_, current) => current is ReminderSuccess || current is ReminderAlreadySubscribed,
      listener: (context, _) async {
        await Future<void>.delayed(context.reduceMotion ? Duration.zero : confirmHold);
        if (context.mounted) Navigator.of(context).pop(true);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Space.screen,
          Space.x1,
          Space.screen,
          Space.x3 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(movie.title, key: const Key('reminderSheet.title'), style: textTheme.titleLarge),
            const SizedBox(height: Space.x2),
            ReminderForm(movieId: movie.id),
          ],
        ),
      ),
    );
  }
}
