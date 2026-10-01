import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/reveal.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/wordmark.dart';
import '../controller/auth_bloc.dart';
import 'auth_failure_text.dart';
import 'auth_gate.dart';

/// On-demand sign-in, opened over the current screen by [requireSignIn].
///
/// It closes itself with an [AuthGateResult]: `signedIn` after a login (or a
/// sign-up finished on the register screen above it), `guest` when guest
/// checkout is chosen, `dismissed` from the close button.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.args = const LoginArgs()});

  final LoginArgs args;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _closed = false;

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

  /// Pops this route (and the register screen if it is on top) with [result].
  void _close(AuthGateResult result) {
    if (_closed) return;
    _closed = true;
    final navigator = Navigator.of(context);
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) navigator.popUntil((r) => r == route);
    navigator.pop(result);
  }

  void _continueAsGuest() {
    context.read<AuthBloc>().add(const GuestContinued());
    _close(AuthGateResult.guest);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final submitting = state is AuthGuest && state.submitting;
    final failure = state is AuthGuest ? state.failure : null;
    final reasonKey = widget.args.reasonKey;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous is! AuthAuthenticated && current is AuthAuthenticated,
      listener: (context, _) => _close(AuthGateResult.signedIn),
      child: PopScope(
        // Do not leave mid-request; otherwise back/close is a plain dismiss.
        canPop: !submitting,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              key: const Key('login.close'),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              icon: const Icon(Icons.close),
              onPressed: submitting ? null : () => _close(AuthGateResult.dismissed),
            ),
          ),
          body: Column(
            children: [
              Reveal(
                child: failure == null
                    ? null
                    : ErrorBanner(key: ValueKey(failure), message: authFailureText(context, failure)),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x3),
                    children: [
                      const Center(child: Wordmark()),
                      const SizedBox(height: Space.x4),
                      Text('auth.login'.tr(context: context), style: textTheme.headlineSmall),
                      if (reasonKey != null) ...[
                        const SizedBox(height: Space.x0_5),
                        Text(
                          reasonKey.tr(context: context),
                          key: const Key('login.reason'),
                          style: textTheme.bodyMedium?.copyWith(color: AppColors.mist.withValues(alpha: 0.75)),
                        ),
                      ],
                      const SizedBox(height: Space.x3),
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
                      PrimaryButton(
                        key: const Key('login.submit'),
                        label: 'auth.login'.tr(context: context),
                        loading: submitting,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: Space.x1),
                      TextButton(
                        key: const Key('login.register'),
                        onPressed: submitting ? null : () => Navigator.of(context).pushNamed(AppRoutes.register),
                        child: Text('auth.noAccount'.tr(context: context)),
                      ),
                      // Only where the API accepts guests (checkout).
                      if (widget.args.allowGuest) ...[
                        const Divider(height: Space.x4),
                        OutlinedButton(
                          key: const Key('login.guest'),
                          onPressed: submitting ? null : _continueAsGuest,
                          child: Text('auth.guestCheckout'.tr(context: context)),
                        ),
                        const SizedBox(height: Space.x1),
                        Text(
                          'auth.guestCheckoutHint'.tr(context: context),
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
