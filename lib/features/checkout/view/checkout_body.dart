part of 'checkout_page.dart';

class _ReadyBody extends StatelessWidget {
  const _ReadyBody({required this.state, this.inFlow = false});

  final CheckoutReady state;

  /// In a booking flow the capsule above shows title, time, and timer.
  final bool inFlow;

  @override
  Widget build(BuildContext context) {
    final quote = state.quote;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(Space.x2),
          children: [
            if (!inFlow) ...[
              Text(quote.movieTitle, style: textTheme.titleLarge),
              Text(
                context.showLine(
                  hallName: quote.hallName,
                  showDate: quote.showDate,
                  showTime: quote.showTime,
                ),
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: Space.x1),
            ],
            Row(
              children: [
                // In a flow the capsule above already lists the seats.
                Expanded(
                  child: inFlow
                      ? const SizedBox.shrink()
                      : Text(
                          quote.seatCodes.join(', '),
                          key: const Key('checkout.seats'),
                        ),
                ),
                TextButton(
                  key: const Key('checkout.changeSeats'),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('checkout.changeSeats'.tr(context: context)),
                ),
              ],
            ),
            if (state.secondsLeft != null && !inFlow)
              HoldLabel(
                secondsLeft: state.secondsLeft!,
                textKey: const Key('checkout.countdown'),
              ),
            // Under PayWay's 3-minute minimum Pay is off: extend once, or start over.
            if (state.holdTooShort && state.holdAlive) ...[
              const SizedBox(height: Space.x1),
              HoldBanner(
                secondsLeft: state.secondsLeft!,
                extending: state.extending,
                message: (state.hold.extended ? 'checkout.holdTooShort' : 'checkout.holdExtendToPay')
                    .tr(context: context),
                onExtend: state.canExtend
                    ? () => context.read<CheckoutBloc>().add(const CheckoutHoldExtendRequested())
                    : null,
              ),
            ],
            if (quote.foodItems.isNotEmpty) ...[
              const SizedBox(height: Space.x2),
              _FoodCard(state: state),
            ],
            const Divider(height: Space.x4),
            _PromoField(applied: quote.promoCode, busy: state.quoting),
            const Divider(height: Space.x4),
            _PriceLines(quote: quote),
            if (state.requiresGuest) ...[
              const Divider(height: Space.x4),
              _GuestForm(guest: state.guest),
            ],
            const SizedBox(height: Space.x4),
          ],
        ),
        if (state.quoting)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}
