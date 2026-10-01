import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../controller/auth_bloc.dart';
import 'auth_failure_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginRequested(email: _email.text, password: _password.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final submitting = state is AuthUnauthenticated && state.submitting;
    final failure = state is AuthUnauthenticated ? state.failure : null;

    return Scaffold(
      appBar: AppBar(title: Text('auth.login'.tr(context: context))),
      body: Column(
        children: [
          if (failure != null) ErrorBanner(message: authFailureText(context, failure)),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(Space.x3),
                children: [
                  TextFormField(
                    key: const Key('login.email'),
                    controller: _email,
                    enabled: !submitting,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: 'auth.email'.tr(context: context)),
                    validator: (v) => Validators.email(v)?.tr(context: context),
                  ),
                  const SizedBox(height: Space.x2),
                  TextFormField(
                    key: const Key('login.password'),
                    controller: _password,
                    enabled: !submitting,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(labelText: 'auth.password'.tr(context: context)),
                    validator: (v) => Validators.password(v)?.tr(context: context),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: Space.x3),
                  FilledButton(
                    key: const Key('login.submit'),
                    onPressed: submitting ? null : _submit,
                    child: submitting
                        ? const SizedBox.square(
                            dimension: Space.x2,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('auth.login'.tr(context: context)),
                  ),
                  const SizedBox(height: Space.x1),
                  TextButton(
                    onPressed: submitting
                        ? null
                        : () => Navigator.of(context).pushNamed(AppRoutes.register),
                    child: Text('auth.noAccount'.tr(context: context)),
                  ),
                  const Divider(height: Space.x4),
                  OutlinedButton(
                    key: const Key('login.guest'),
                    onPressed: submitting
                        ? null
                        : () => context.read<AuthBloc>().add(const GuestContinued()),
                    child: Text('auth.guest'.tr(context: context)),
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
