import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/controller/auth_bloc.dart';
import '../controller/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    final user = state is ProfileReady ? state.user : null;
    _name = TextEditingController(text: user?.name ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(ProfileSaved(name: _name.text, phone: _phone.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileReady && current.notice == ProfileNotice.saved,
      listener: (context, state) {
        context.read<AuthBloc>().add(UserUpdated((state as ProfileReady).user));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('profile.saved'.tr(context: context))));
        Navigator.of(context).pop();
      },
      builder: (context, state) {
        final saving = state is ProfileReady && state.saving;
        final error = state is ProfileReady ? state.error : null;
        return Scaffold(
          appBar: AppBar(title: Text('profile.edit'.tr(context: context))),
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
                        controller: _name,
                        enabled: !saving,
                        decoration: InputDecoration(labelText: 'auth.name'.tr(context: context)),
                        validator: (v) => Validators.required(v)?.tr(context: context),
                      ),
                      const SizedBox(height: Space.x2),
                      TextFormField(
                        controller: _phone,
                        enabled: !saving,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'profile.phone'.tr(context: context)),
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
