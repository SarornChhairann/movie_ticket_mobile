import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/booking_lookup_bloc.dart';
import '../model/tickets_failure.dart';

/// Guest "Find my booking": the reference from the success screen or email plus the
/// phone used to book. Pops the found booking, which is already saved on the device.
class BookingLookupPage extends StatefulWidget {
  const BookingLookupPage({super.key});

  @override
  State<BookingLookupPage> createState() => _BookingLookupPageState();
}

class _BookingLookupPageState extends State<BookingLookupPage> {
  final _formKey = GlobalKey<FormState>();
  final _reference = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _reference.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<BookingLookupBloc>().add(LookupSubmitted(reference: _reference.text, phone: _phone.text));
  }

  static String _failureText(BuildContext context, TicketsFailure failure) => switch (failure) {
        TicketsNetwork() => 'shell.offline'.tr(context: context),
        TicketsNotFound() => 'tickets.lookupMiss'.tr(context: context),
        _ => failure.message,
      };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingLookupBloc, BookingLookupState>(
      listenWhen: (previous, current) => previous.found == null && current.found != null,
      listener: (context, state) => Navigator.of(context).pop(state.found),
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('tickets.find'.tr(context: context))),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(Space.x2),
            children: [
              if (state.failure != null) ...[
                ErrorBanner(key: const Key('lookup.error'), message: _failureText(context, state.failure!)),
                const SizedBox(height: Space.x2),
              ],
              Text('tickets.findHint'.tr(context: context)),
              const SizedBox(height: Space.x2),
              TextFormField(
                key: const Key('lookup.reference'),
                controller: _reference,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(labelText: 'tickets.reference'.tr(context: context)),
                validator: (v) => Validators.required(v)?.tr(context: context),
              ),
              const SizedBox(height: Space.x2),
              TextFormField(
                key: const Key('lookup.phone'),
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'checkout.guestPhone'.tr(context: context)),
                validator: (v) => Validators.required(v)?.tr(context: context),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: Space.x3),
              PrimaryButton(
                key: const Key('lookup.submit'),
                label: 'tickets.findSubmit'.tr(context: context),
                loading: state.submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
