part of 'checkout_page.dart';

class _GuestForm extends StatelessWidget {
  const _GuestForm({required this.guest});

  final GuestInfo guest;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CheckoutBloc>();
    String? err(String? key) => key?.tr(context: context);
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'checkout.guestTitle'.tr(context: context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextFormField(
          key: const Key('guest.name'),
          initialValue: guest.name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'checkout.guestName'.tr(context: context),
          ),
          validator: (v) => err(Validators.required(v)),
          onChanged: (v) =>
              bloc.add(GuestEdited(bloc.guestOr(guest).copyWith(name: v))),
        ),
        TextFormField(
          key: const Key('guest.phone'),
          initialValue: guest.phone,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'checkout.guestPhone'.tr(context: context),
          ),
          validator: (v) => err(Validators.required(v)),
          onChanged: (v) =>
              bloc.add(GuestEdited(bloc.guestOr(guest).copyWith(phone: v))),
        ),
        TextFormField(
          key: const Key('guest.email'),
          initialValue: guest.email,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'checkout.guestEmail'.tr(context: context),
          ),
          // Required: the tickets (one QR per seat) are emailed here.
          validator: (v) => err(Validators.email(v)),
          onChanged: (v) =>
              bloc.add(GuestEdited(bloc.guestOr(guest).copyWith(email: v))),
        ),
      ],
    );
  }
}

extension on CheckoutBloc {
  /// The latest guest info, so fast typing in one field never drops another's.
  GuestInfo guestOr(GuestInfo fallback) {
    final s = state;
    return s is CheckoutReady ? s.guest : fallback;
  }
}
