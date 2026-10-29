import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/password_reset_bloc.dart';
import 'auth_failure_text.dart';

/// Forgot password, pushed from the login screen. Step 1 asks for the email,
/// step 2 for the emailed code and a new password. Pops `true` once the
/// password is reset, so login can say so; the user then logs in as usual.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  /// What was already typed on the login screen.
  final String initialEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailForm = GlobalKey<FormState>();
  final _resetForm = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail.trim());
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_email, _code, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _requestCode() {
    if (_emailForm.currentState!.validate()) {
      context.read<PasswordResetBloc>().add(ResetCodeRequested(_email.text));
    }
  }

  void _submitReset() {
    if (_resetForm.currentState!.validate()) {
      context.read<PasswordResetBloc>().add(ResetSubmitted(code: _code.text, newPassword: _password.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordResetBloc>().state;
    final failure = state.failure;

    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listenWhen: (previous, current) =>
          current.step == PasswordResetStep.done && previous.step != PasswordResetStep.done ||
          current.notice != null && previous.notice != current.notice,
      listener: (context, state) {
        if (state.step == PasswordResetStep.done) {
          Navigator.of(context).pop(true);
        } else if (state.notice == PasswordResetNotice.codeSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('auth.reset.codeSent'.tr(context: context, args: [state.email]))),
          );
        }
      },
      child: PopScope(
        canPop: !state.submitting,
        child: Scaffold(
          appBar: AppBar(title: Text('auth.reset.title'.tr(context: context))),
          body: Column(
            children: [
              Reveal(
                child: failure == null
                    ? null
                    : ErrorBanner(key: ValueKey(failure), message: authFailureText(context, failure)),
              ),
              Expanded(
                child: state.step == PasswordResetStep.email
                    ? _emailStep(context, state)
                    : _codeStep(context, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailStep(BuildContext context, PasswordResetState state) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: _emailForm,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x3),
        children: [
          Text(
            'auth.reset.emailHint'.tr(context: context),
            style: textTheme.bodyMedium?.copyWith(color: AppColors.mist.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: Space.x3),
          TextFormField(
            key: const Key('reset.email'),
            controller: _email,
            enabled: !state.submitting,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: 'auth.email'.tr(context: context)),
            validator: (v) => Validators.email(v)?.tr(context: context),
            onFieldSubmitted: (_) => _requestCode(),
          ),
          const SizedBox(height: Space.x3),
          PrimaryButton(
            key: const Key('reset.sendCode'),
            label: 'auth.reset.sendCode'.tr(context: context),
            loading: state.submitting,
            onPressed: _requestCode,
          ),
        ],
      ),
    );
  }

  Widget _codeStep(BuildContext context, PasswordResetState state) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = context.read<PasswordResetBloc>();
    return Form(
      key: _resetForm,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x3),
        children: [
          Text(
            'auth.reset.codeHint'.tr(context: context, args: [state.email]),
            key: const Key('reset.codeHint'),
            style: textTheme.bodyMedium?.copyWith(color: AppColors.mist.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: Space.x3),
          TextFormField(
            key: const Key('reset.code'),
            controller: _code,
            enabled: !state.submitting,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            decoration: InputDecoration(labelText: 'auth.reset.code'.tr(context: context)),
            validator: (v) => (v == null || v.trim().length != 6) ? 'auth.reset.codeLength'.tr(context: context) : null,
          ),
          const SizedBox(height: Space.x2),
          TextFormField(
            key: const Key('reset.password'),
            controller: _password,
            enabled: !state.submitting,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(labelText: 'profile.newPassword'.tr(context: context)),
            validator: (v) => Validators.password(v)?.tr(context: context),
          ),
          const SizedBox(height: Space.x2),
          TextFormField(
            key: const Key('reset.confirm'),
            controller: _confirm,
            enabled: !state.submitting,
            obscureText: true,
            decoration: InputDecoration(labelText: 'auth.confirmPassword'.tr(context: context)),
            validator: (v) => Validators.confirmPassword(v, _password.text)?.tr(context: context),
            onFieldSubmitted: (_) => _submitReset(),
          ),
          const SizedBox(height: Space.x3),
          PrimaryButton(
            key: const Key('reset.submit'),
            label: 'auth.reset.submit'.tr(context: context),
            loading: state.submitting,
            onPressed: _submitReset,
          ),
          const SizedBox(height: Space.x1),
          TextButton(
            key: const Key('reset.resend'),
            onPressed: state.submitting ? null : () => bloc.add(const ResetCodeResent()),
            child: Text('auth.reset.resend'.tr(context: context)),
          ),
          TextButton(
            key: const Key('reset.changeEmail'),
            onPressed: state.submitting ? null : () => bloc.add(const ResetEmailEditRequested()),
            child: Text('auth.reset.changeEmail'.tr(context: context)),
          ),
        ],
      ),
    );
  }
}
