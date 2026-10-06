import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/haptics/app_haptics.dart';
import '../../../core/widgets/app_list_tile.dart';
import '../../../core/widgets/hold_banner.dart';
import '../../../core/format/locale_format.dart';
import '../../../core/motion/crossfade_text.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/motion/motion.dart';
import '../../../core/widgets/booking_progress.dart';
import '../../../core/widgets/sticky_summary_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../controller/booking_flow_cubit.dart';
import '../controller/checkout_bloc.dart';
import '../model/checkout_failure.dart';
import '../model/payway.dart';
import '../model/quote.dart';
import 'concessions_page.dart';
import 'pay_sheet.dart';
import 'flow_header.dart';

part 'checkout_body.dart';
part 'food_card.dart';
part 'promo_field.dart';
part 'checkout_lines.dart';
part 'guest_form.dart';
part 'checkout_bottom_bar.dart';

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
    final flow = maybeFlow(context);
    final consumer = _consumer(context);
    if (flow == null) return consumer;
    // Feed the booking capsule and pick the first step once the quote is in.
    return BlocListener<CheckoutBloc, CheckoutState>(
      listenWhen: (previous, current) => current is CheckoutReady,
      listener: (context, state) {
        final s = state as CheckoutReady;
        flow
          ..quoteChanged(
            foodCount: s.food.values.fold(0, (sum, q) => sum + q),
            totalAmount: s.quote.totalAmount,
            holdExpiresAt: s.hold.expiresAt,
          )
          ..enteredCheckout(hasMenu: s.quote.foodItems.isNotEmpty);
      },
      child: consumer,
    );
  }

  Widget _consumer(BuildContext context) {
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
          maybeFlow(context)?.paid();
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
          AppHaptics.error();
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
          AppHaptics.success();
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
      builder: (context, state) {
        final flow = maybeFlow(context);
        if (flow == null) return _scaffold(context, state, FlowStep.pay, inFlow: false);
        return BlocBuilder<BookingFlowCubit, BookingFlowState>(
          bloc: flow,
          buildWhen: (a, b) => a.step != b.step || a.snacksSkipped != b.snacksSkipped,
          builder: (context, f) => _scaffold(context, state, f.step, inFlow: true),
        );
      },
    );
  }

  /// One route, two steps inside a booking flow: Snacks (the food grid) and Pay
  /// (the quote). Back on Pay returns to Snacks when there is a menu; back on
  /// Snacks returns to the seat map, which keeps the hold (sprint 16).
  Widget _scaffold(BuildContext context, CheckoutState state, FlowStep step, {required bool inFlow}) {
    final ready = state is CheckoutReady ? state : null;
    final snacks = inFlow && step == FlowStep.snacks && ready != null;
    final hasMenu = ready != null && ready.quote.foodItems.isNotEmpty;
    final flow = maybeFlow(context);
    void onStepTap(FlowStep target) {
      if (target == FlowStep.seats) {
        Navigator.of(context).maybePop();
      } else if (target == FlowStep.snacks) {
        flow?.stepTo(FlowStep.snacks);
      }
    }

    return PopScope<Object?>(
      canPop: !inFlow || snacks || !hasMenu,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) flow?.stepTo(FlowStep.snacks);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text((snacks ? 'checkout.foodTitle' : 'checkout.title').tr(context: context)),
        ),
        body: switch (state) {
          CheckoutInitial() ||
          CheckoutLoading() ||
          CheckoutSuccess() => const LoadingView(),
          CheckoutReady() => Column(
              children: [
                FlowHeader(secondsLeft: state.secondsLeft, onStepTap: onStepTap),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: context.motion(Motion.long),
                    child: snacks
                        ? KeyedSubtree(key: const ValueKey('snacks'), child: ConcessionsBody(state: state))
                        : KeyedSubtree(key: const ValueKey('pay'), child: _ReadyBody(state: state, inFlow: inFlow)),
                  ),
                ),
              ],
            ),
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
        bottomNavigationBar: ready == null
            ? null
            : snacks
                ? _SnacksBar(state: ready)
                : _PayBar(state: ready),
      ),
    );
  }
}
