part of 'checkout_page.dart';

/// Pay step: the server total and **Pay \$X**, the same bar as the other steps so
/// its label morphs instead of the bar being replaced (sprint 16).
class _PayBar extends StatelessWidget {
  const _PayBar({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final total = context.money(state.quote.totalAmount);
    return StickySummaryBar(
      actionKey: const Key('checkout.pay'),
      actionLabel: 'flow.payAmount'.tr(context: context, namedArgs: {'amount': total}),
      loading: state.submitting,
      loadingLabel: 'pay.processing'.tr(context: context),
      busy: state.quoting,
      onAction: state.canPay ? () => PaySheet.show(context) : null,
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('checkout.total'.tr(context: context), style: Theme.of(context).textTheme.bodySmall),
          // Never counted up: the server's number crossfades in (sprint 8).
          CrossfadeText(total, textKey: const Key('checkout.stickyTotal'), style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

/// Snacks step: units chosen and the server's food total; **Skip snacks** while
/// the cart is empty, **Continue** to Pay.
class _SnacksBar extends StatelessWidget {
  const _SnacksBar({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final units = state.food.values.fold(0, (sum, q) => sum + q);
    final hasFoodQuote = state.quote.foodLines.isNotEmpty;
    final flow = maybeFlow(context);
    return StickySummaryBar(
      actionKey: const Key('flow.snacksContinue'),
      actionLabel: 'flow.continue'.tr(context: context),
      busy: state.quoting,
      onAction: () => flow?.snacksDone(skipped: units == 0),
      top: units == 0
          ? Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton.ghost(
                key: const Key('flow.skipSnacks'),
                label: 'flow.skipSnacks'.tr(context: context),
                onPressed: () => flow?.snacksDone(skipped: true),
              ),
            )
          : null,
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'checkout.foodCount'.plural(units, context: context),
            key: const Key('concessions.count'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (hasFoodQuote && units > 0)
            CrossfadeText(
              context.money(state.quote.foodTotal),
              textKey: const Key('concessions.foodTotal'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
        ],
      ),
    );
  }
}
