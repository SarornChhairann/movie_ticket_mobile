import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/auth_bloc.dart';
import 'auth_failure_text.dart';

/// Opened from the login sheet. On success the login sheet below it closes both
/// screens and returns the user to the action that asked for sign-in.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterRequested(name: _name.text, email: _email.text, password: _password.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final submitting = state is AuthGuest && state.submitting;
    final failure = state is AuthGuest ? state.failure : null;

    return Scaffold(
      appBar: AppBar(title: Text('auth.register'.tr(context: context))),
      body: Column(
        children: [
          if (failure != null) ErrorBanner(message: authFailureText(context, failure)),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x3),
                children: [
                  TextFormField(
                    controller: _name,
                    enabled: !submitting,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: 'auth.name'.tr(context: context)),
                    validator: (v) => Validators.required(v)?.tr(context: context),
                  ),
                  const SizedBox(height: Space.x2),
                  TextFormField(
                    controller: _email,
                    enabled: !submitting,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'auth.email'.tr(context: context)),
                    validator: (v) => Validators.email(v)?.tr(context: context),
                  ),
                  const SizedBox(height: Space.x2),
                  TextFormField(
                    controller: _password,
                    enabled: !submitting,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'auth.password'.tr(context: context)),
                    validator: (v) => Validators.password(v)?.tr(context: context),
                  ),
                  const SizedBox(height: Space.x2),
                  TextFormField(
                    controller: _confirm,
                    enabled: !submitting,
                    obscureText: true,
                    decoration:
                        InputDecoration(labelText: 'auth.confirmPassword'.tr(context: context)),
                    validator: (v) =>
                        Validators.confirmPassword(v, _password.text)?.tr(context: context),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: Space.x3),
                  PrimaryButton(
                    key: const Key('register.submit'),
                    label: 'auth.register'.tr(context: context),
                    loading: submitting,
                    onPressed: _submit,
                  ),
                  TextButton(
                    onPressed: submitting ? null : () => Navigator.of(context).pop(),
                    child: Text('auth.haveAccount'.tr(context: context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
