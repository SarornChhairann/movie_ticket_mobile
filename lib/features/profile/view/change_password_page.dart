import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../controller/profile_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_current, _new, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(PasswordChangeRequested(
            currentPassword: _current.text,
            newPassword: _new.text,
            confirmPassword: _confirm.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileReady && current.notice == ProfileNotice.passwordChanged,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('profile.passwordChanged'.tr(context: context))));
        Navigator.of(context).pop();
      },
      builder: (context, state) {
        final saving = state is ProfileReady && state.saving;
        final error = state is ProfileReady ? state.error : null;
        return Scaffold(
          appBar: AppBar(title: Text('profile.changePassword'.tr(context: context))),
          body: Column(
            children: [
              if (error != null)
                ErrorBanner(message: error.isEmpty ? 'common.error'.tr(context: context) : error),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(Space.x3),
                    children: [
                      TextFormField(
                        controller: _current,
                        enabled: !saving,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'profile.currentPassword'.tr(context: context),
                        ),
                        validator: (v) => Validators.required(v)?.tr(context: context),
                      ),
                      const SizedBox(height: Space.x2),
                      TextFormField(
                        controller: _new,
                        enabled: !saving,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'profile.newPassword'.tr(context: context)),
                        validator: (v) => Validators.password(v)?.tr(context: context),
                      ),
                      const SizedBox(height: Space.x2),
                      TextFormField(
                        controller: _confirm,
                        enabled: !saving,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'auth.confirmPassword'.tr(context: context),
                        ),
                        validator: (v) =>
                            Validators.confirmPassword(v, _new.text)?.tr(context: context),
                      ),
                      const SizedBox(height: Space.x3),
                      FilledButton(
                        onPressed: saving ? null : _submit,
                        child: Text('profile.save'.tr(context: context)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
