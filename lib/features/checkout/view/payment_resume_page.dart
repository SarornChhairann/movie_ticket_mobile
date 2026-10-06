import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_banner.dart';
import '../controller/payment_resume_bloc.dart';

/// "Checking your payment": opened over Home when the last run was killed while
/// an ABA payment was open. Approved → the success screen; failed → a notice.
class PaymentResumePage extends StatelessWidget {
  const PaymentResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<PaymentResumeBloc, PaymentResumeState>(
      listenWhen: (previous, current) => previous.outcome == null && current.outcome is ResumeApproved,
      listener: (context, state) => Navigator.of(context).pushReplacementNamed(
        AppRoutes.paySuccess,
        arguments: (state.outcome! as ResumeApproved).confirmation,
      ),
      builder: (context, state) {
        final failed = state.outcome is ResumeFailed;
        final reference = state.payment.reference;
        return Scaffold(
          appBar: AppBar(title: Text('pay.resumeTitle'.tr(context: context)), automaticallyImplyLeading: false),
          body: Column(
            children: [
              if (!failed && state.failures >= PaymentResumeBloc.failuresBeforeMessage)
                ErrorBanner(message: 'shell.offline'.tr(context: context)),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Space.x3),
                  children: [
                    const SizedBox(height: Space.x4),
                    Center(
                      child: failed
                          ? const Icon(Icons.error_outline, size: Space.x6)
                          : const SizedBox.square(dimension: Space.x6, child: CircularProgressIndicator()),
                    ),
                    const SizedBox(height: Space.x3),
                    Text(
                      (failed ? 'pay.resumeFailed' : 'pay.resumeBody').tr(context: context),
                      key: Key(failed ? 'pay.resumeFailed' : 'pay.resumeBody'),
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (reference.isNotEmpty) ...[
                      const SizedBox(height: Space.x2),
                      Text(
                        '${'tickets.reference'.tr(context: context)}: $reference',
                        style: textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Space.x2),
                  child: SizedBox(
                    width: double.infinity,
                    child: failed
                        ? FilledButton(
                            key: const Key('pay.backHome'),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('pay.backHome'.tr(context: context)),
                          )
                        // Leaving keeps the record: the next start checks again.
                        : OutlinedButton(
                            key: const Key('pay.resumeLater'),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('pay.resumeLater'.tr(context: context)),
                          ),
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
