import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../auth/controller/auth_bloc.dart';
import '../controller/reminder_bloc.dart';

/// Email + Remind button for a coming-soon movie. Needs a [ReminderBloc] above it.
class ReminderForm extends StatefulWidget {
  const ReminderForm({super.key, required this.movieId});

  final int movieId;

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    _email = TextEditingController(text: auth is AuthAuthenticated ? auth.user.email : '');
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ReminderBloc>().add(SubmitRequested(movieId: widget.movieId, email: _email.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        final submitting = state is ReminderSubmitting;
        final (notice, color) = switch (state) {
          ReminderSuccess() => ('reminders.success'.tr(context: context), theme.colorScheme.primary),
          ReminderAlreadySubscribed() => ('reminders.exists'.tr(context: context), theme.colorScheme.primary),
          ReminderFailureState(:final message) => (
              message.isEmpty ? 'shell.offline'.tr(context: context) : message,
              theme.colorScheme.error,
            ),
          ReminderIdle() || ReminderSubmitting() => (null, null),
        };
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('reminders.title'.tr(context: context), style: theme.textTheme.titleMedium),
              const SizedBox(height: Space.x1),
              TextFormField(
                key: const Key('reminders.email'),
                controller: _email,
                enabled: !submitting,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(labelText: 'reminders.email'.tr(context: context)),
                validator: (v) => Validators.email(v)?.tr(context: context),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: Space.x1),
              FilledButton.icon(
                key: const Key('reminders.submit'),
                onPressed: submitting ? null : _submit,
                icon: submitting
                    ? const SizedBox.square(dimension: Space.x2, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.notifications_active_outlined),
                label: Text('reminders.submit'.tr(context: context)),
              ),
              if (notice != null) ...[
                const SizedBox(height: Space.x1),
                Text(notice, key: const Key('reminders.notice'), style: TextStyle(color: color)),
              ],
            ],
          ),
        );
      },
    );
  }
}
