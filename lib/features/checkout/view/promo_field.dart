part of 'checkout_page.dart';

class _PromoField extends StatefulWidget {
  const _PromoField({required this.applied, required this.busy});

  final String? applied;
  final bool busy;

  @override
  State<_PromoField> createState() => _PromoFieldState();
}

class _PromoFieldState extends State<_PromoField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CheckoutBloc>();
    final applied = widget.applied;
    if (applied != null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: InputChip(
          key: const Key('checkout.promoApplied'),
          avatar: const Icon(Icons.local_offer_outlined, size: 18),
          label: Text(applied),
          onDeleted: widget.busy ? null : () => bloc.add(const PromoCleared()),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: const Key('checkout.promo'),
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'checkout.promo'.tr(context: context),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: Space.x1),
        OutlinedButton(
          key: const Key('checkout.applyPromo'),
          onPressed: widget.busy
              ? null
              : () {
                  if (_controller.text.trim().isNotEmpty) {
                    bloc.add(PromoApplied(_controller.text));
                  }
                },
          child: Text('checkout.applyPromo'.tr(context: context)),
        ),
      ],
    );
  }
}
