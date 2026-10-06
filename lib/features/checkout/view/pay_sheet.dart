import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/haptics/app_haptics.dart';
import '../../../core/widgets/app_list_tile.dart';
import '../../../core/format/locale_format.dart';
import '../../../core/motion/crossfade_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/checkout_bloc.dart';

/// **Pay** on checkout: the amount the server charges and the one method, ABA KHQR.
class PaySheet extends StatelessWidget {
  const PaySheet({super.key});

  /// Opens the sheet over checkout, on the same [CheckoutBloc].
  static Future<void> show(BuildContext context) {
    final bloc = context.read<CheckoutBloc>();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.navy,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card))),
      builder: (_) => BlocProvider.value(value: bloc, child: const PaySheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state is! CheckoutReady) return const SizedBox.shrink();
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.screen, Space.x3, Space.screen, Space.x2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('pay.title'.tr(context: context), key: const Key('pay.sheetTitle'), style: textTheme.titleLarge),
                const SizedBox(height: Space.x1),
                Row(
                  children: [
                    Expanded(child: Text('checkout.total'.tr(context: context), style: textTheme.bodyMedium)),
                    CrossfadeText(
                      context.money(state.quote.totalAmount),
                      textKey: const Key('pay.sheetTotal'),
                      style: textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: Space.x2),
                Material(
                  key: const Key('pay.abaKhqr'),
                  color: AppColors.navyRaised,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.card),
                    side: const BorderSide(color: AppColors.blue),
                  ),
                  child: AppListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x0_5),
                    leading: const KhqrMark(),
                    title: Text('pay.abaKhqr.title'.tr(context: context)),
                    subtitle: Text('pay.abaKhqr.subtitle'.tr(context: context)),
                    trailing: const Icon(Icons.radio_button_checked, color: AppColors.blue),
                  ),
                ),
                const SizedBox(height: Space.x3),
                PrimaryButton(
                  key: const Key('pay.process'),
                  label: 'pay.process'.tr(context: context),
                  loading: state.submitting,
                  onPressed: state.submitting || !state.canPay
                      ? null
                      : () {
                          AppHaptics.light();
                          context.read<CheckoutBloc>().add(const PaymentStartRequested());
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The KHQR badge: red tile with the wordmark (no bitmap asset needed).
class KhqrMark extends StatelessWidget {
  const KhqrMark({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Space.x6,
      height: Space.x4,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.khqrRed, borderRadius: BorderRadius.circular(Space.x0_5)),
      child: Text(
        'KHQR',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
