part of 'checkout_page.dart';

/// The food section: a preview row when the cart is empty, the chosen lines
/// otherwise. The whole card opens the concessions page on the same bloc.
class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.state});

  final CheckoutReady state;

  static const _previewCount = 4;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final menu = state.quote.foodItems;
    final chosen = [
      for (final item in menu)
        if ((state.food[item.id] ?? 0) > 0) item,
    ];
    final units = state.food.values.fold(0, (sum, q) => sum + q);
    // In a booking flow the shop is the Snacks step; otherwise its own route.
    void open() {
      final flow = maybeFlow(context);
      if (flow != null) {
        flow.stepTo(FlowStep.snacks);
      } else {
        Navigator.of(context).pushNamed(AppRoutes.concessions, arguments: context.read<CheckoutBloc>());
      }
    }
    return Material(
      key: const Key('checkout.foodCard'),
      color: AppColors.navyRaised,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: PressableInkWell(
        onTap: open,
        child: Padding(
          padding: const EdgeInsets.all(Space.x2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'checkout.foodTitle'.tr(context: context),
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          chosen.isEmpty
                              ? 'checkout.foodHint'.tr(context: context)
                              : 'checkout.foodCount'.plural(
                                  units,
                                  context: context,
                                ),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    key: const Key('checkout.foodAction'),
                    onPressed: open,
                    child: Text(
                      (chosen.isEmpty
                              ? 'checkout.foodBrowse'
                              : 'checkout.foodEdit')
                          .tr(context: context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.x1),
              if (chosen.isEmpty)
                Row(
                  children: [
                    for (final item in menu.take(_previewCount))
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: Space.x1,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Space.x1),
                          child: SizedBox.square(
                            dimension: Space.x6 + Space.x1,
                            child: FoodImage(url: item.imageUrl),
                          ),
                        ),
                      ),
                  ],
                )
              else
                for (final item in chosen)
                  _ChosenLine(
                    item: item,
                    quantity: state.food[item.id]!,
                    quote: state.quote,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChosenLine extends StatelessWidget {
  const _ChosenLine({
    required this.item,
    required this.quantity,
    required this.quote,
  });

  final FoodItem item;
  final int quantity;
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    // The server's line; missing while a re-quote for a new item is pending.
    final line = quote.foodLines
        .where((l) => l.foodItemId == item.id)
        .firstOrNull;
    return Padding(
      key: Key('food.${item.id}.line'),
      padding: const EdgeInsets.symmetric(vertical: Space.x0_5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Space.x0_5),
            child: SizedBox.square(
              dimension: Space.x4,
              child: FoodImage(url: item.imageUrl),
            ),
          ),
          const SizedBox(width: Space.x1),
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text('×$quantity', key: Key('food.${item.id}.lineQty')),
          const SizedBox(width: Space.x2),
          if (line != null) CrossfadeText(context.money(line.lineTotal)),
        ],
      ),
    );
  }
}
