import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/hold_banner.dart';
import '../../../core/format/locale_format.dart';
import '../../../core/motion/crossfade_text.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../controller/checkout_bloc.dart';
import '../model/checkout_failure.dart';
import '../model/payway.dart';
import '../model/quote.dart';
import 'concessions_page.dart';
import 'pay_sheet.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static Future<void> _showPaymentFailed(
    BuildContext context,
    CheckoutReady state,
  ) {
    final message = state.message;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const Key('pay.failedDialog'),
        title: Text('pay.failed'.tr(context: dialogContext)),
        content: Text(
          message == null || message.isEmpty
              ? 'pay.notCompleted'.tr(context: dialogContext)
              : message,
        ),
        actions: [
          if (state.holdAlive)
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('pay.tryAgain'.tr(context: dialogContext)),
            )
          else
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _backToSeatMap(context);
              },
              child: Text('pay.pickSeats'.tr(context: dialogContext)),
            ),
        ],
      ),
    );
  }

  /// Closes the pay sheet if it is still up, then opens PayWay's page and hands its
  /// outcome back to the bloc.
  static Future<void> _openPayway(
    BuildContext context,
    PaywayLaunch launch,
  ) async {
    final bloc = context.read<CheckoutBloc>();
    final navigator = Navigator.of(context)
      ..popUntil((route) => route is PageRoute);
    final outcome = await navigator.pushNamed<PaywayOutcome>(
      AppRoutes.payway,
      arguments: launch,
    );
    bloc.add(PaywayFinished(outcome ?? const PaywayOutcome.dismissed()));
  }

  static void _backToSeatMap(BuildContext context) => Navigator.of(context)
      .popUntil(
        (route) => route.settings.name == AppRoutes.seatMap || route.isFirst,
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (previous, current) =>
          current is CheckoutSuccess ||
          (current is CheckoutReady &&
              current.effect != null &&
              (previous is! CheckoutReady ||
                  previous.effect != current.effect ||
                  previous.message != current.message)) ||
          (current is CheckoutFailureState &&
              current.failure is CheckoutHoldExpired),
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state is CheckoutSuccess) {
          // Replace the booking flow with the success screen; back goes home.
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.paySuccess,
            (route) => route.isFirst,
            arguments: state.confirmation,
          );
          return;
        }
        if (state is CheckoutReady &&
            state.effect == CheckoutEffect.paywayStarted &&
            state.payway != null) {
          _openPayway(context, state.payway!);
          return;
        }
        if (state is CheckoutReady &&
            state.effect == CheckoutEffect.paymentFailed) {
          Navigator.of(context).popUntil((route) => route is PageRoute);
          _showPaymentFailed(context, state);
          return;
        }
        if (state is CheckoutFailureState ||
            (state is CheckoutReady &&
                state.effect == CheckoutEffect.holdExpired)) {
          messenger.showSnackBar(
            SnackBar(content: Text('seats.expired'.tr(context: context))),
          );
          _backToSeatMap(context);
          return;
        }
        if (state is CheckoutReady && state.effect == CheckoutEffect.holdExtended) {
          messenger.showSnackBar(SnackBar(content: Text('seats.extendDone'.tr(context: context))));
          return;
        }
        final message = (state as CheckoutReady).message;
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              message == null || message.isEmpty
                  ? 'common.error'.tr(context: context)
                  : message,
            ),
          ),
        );
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('checkout.title'.tr(context: context))),
        body: switch (state) {
          CheckoutInitial() ||
          CheckoutLoading() ||
          CheckoutSuccess() => const LoadingView(),
          CheckoutReady() => _ReadyBody(state: state),
          CheckoutFailureState(:final hold, :final failure) => ErrorView(
            message: switch (failure) {
              CheckoutPromoInvalid(:final message) ||
              CheckoutSeatConflict(:final message) ||
              CheckoutPaymentFailed(:final message) ||
              CheckoutBlocked(:final message) ||
              CheckoutSeatLimit(:final message) ||
              CheckoutUnknown(:final message) => message,
              CheckoutBookingNotFound() => 'tickets.notFound'.tr(context: context),
              CheckoutNetwork() => 'shell.offline'.tr(context: context),
              CheckoutHoldExpired() || CheckoutPairInvalid() => '',
            },
            onRetry: () =>
                context.read<CheckoutBloc>().add(QuoteRequested(hold)),
          ),
        },
        bottomNavigationBar: state is CheckoutReady
            ? _PayBar(state: state)
            : null,
      ),
    );
  }
}

class _ReadyBody extends StatelessWidget {
  const _ReadyBody({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final quote = state.quote;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(Space.x2),
          children: [
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
            Row(
              children: [
                Expanded(
                  child: Text(
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
            if (state.secondsLeft != null)
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
    void open() => Navigator.of(
      context,
    ).pushNamed(AppRoutes.concessions, arguments: context.read<CheckoutBloc>());
    return Material(
      key: const Key('checkout.foodCard'),
      color: AppColors.navyRaised,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
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
                  if (_controller.text.trim().isNotEmpty)
                    bloc.add(PromoApplied(_controller.text));
                },
          child: Text('checkout.applyPromo'.tr(context: context)),
        ),
      ],
    );
  }
}

/// The server's lines, in analytics 3.4 order. Zero discount/surcharge lines are hidden.
class _PriceLines extends StatelessWidget {
  const _PriceLines({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    Widget line(
      String key,
      num amount, {
      bool negative = false,
      bool bold = false,
    }) {
      final style = bold ? Theme.of(context).textTheme.titleMedium : null;
      return Padding(
        key: Key('line.$key'),
        padding: const EdgeInsets.symmetric(vertical: Space.x0_5),
        child: Row(
          children: [
            Expanded(
              child: Text('checkout.$key'.tr(context: context), style: style),
            ),
            CrossfadeText(
              '${negative ? '−' : ''}${context.money(amount)}',
              style: style,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        line('base', quote.baseAmount),
        if (quote.morningDiscount != 0)
          line('morningDiscount', quote.morningDiscount, negative: true),
        if (quote.weekendSurcharge != 0)
          line('weekendSurcharge', quote.weekendSurcharge),
        line('subtotal', quote.subtotal),
        if (quote.discountAmount != 0)
          line('promoDiscount', quote.discountAmount, negative: true),
        line('tax', quote.taxAmount),
        line('serviceFee', quote.serviceFee),
        if (quote.foodTotal != 0) line('food', quote.foodTotal),
        const Divider(),
        line('total', quote.totalAmount, bold: true),
      ],
    );
  }
}

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
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? null : err(Validators.email(v)),
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

class _PayBar extends StatelessWidget {
  const _PayBar({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Space.x2),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'checkout.total'.tr(context: context),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    CrossfadeText(
                      context.money(state.quote.totalAmount),
                      textKey: const Key('checkout.stickyTotal'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              FilledButton(
                key: const Key('checkout.pay'),
                onPressed: state.canPay ? () => PaySheet.show(context) : null,
                child: state.submitting
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox.square(
                            dimension: Space.x2,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: Space.x1),
                          Text('pay.processing'.tr(context: context)),
                        ],
                      )
                    : Text('checkout.pay'.tr(context: context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
