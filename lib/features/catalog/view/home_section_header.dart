import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';

/// A Home section title with an optional "See all".
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.titleKey, this.seeAllKey, this.onSeeAll});

  final String titleKey;
  final Key? seeAllKey;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.x1, Space.x1),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(child: Text(titleKey.tr(context: context), style: Theme.of(context).textTheme.titleMedium)),
            if (onSeeAll != null)
              TextButton(key: seeAllKey, onPressed: onSeeAll, child: Text('catalog.seeAll'.tr(context: context))),
          ],
        ),
      ),
    );
  }
}
