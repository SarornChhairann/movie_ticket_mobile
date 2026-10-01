import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import 'ticket_emblem.dart';

/// Ticket emblem plus the app name, for the auth screens.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TicketEmblem(width: size * 1.6),
        const SizedBox(width: Space.x1 + 4),
        Text(
          'app.title'.tr(context: context),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: AppColors.white, letterSpacing: 0.3),
        ),
      ],
    );
  }
}
