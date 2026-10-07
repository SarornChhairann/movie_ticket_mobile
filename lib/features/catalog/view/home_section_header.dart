import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';

/// A Home section title with an optional "See all". The title is [titleKey]
/// translated, or [title] when the caller formats it.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, this.titleKey = '', this.title, this.seeAllKey, this.onSeeAll});

  final String titleKey;
  final String? title;
  final Key? seeAllKey;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.x1, Space.x1),
      // 48 dp tall so "See all" is a full touch target (sprint 19).
      child: SizedBox(
        height: Space.minTarget,
        child: Row(
          children: [
            Expanded(child: Text(title ?? titleKey.tr(context: context), style: Theme.of(context).textTheme.titleMedium)),
            if (onSeeAll != null)
              TextButton(key: seeAllKey, onPressed: onSeeAll, child: Text('catalog.seeAll'.tr(context: context))),
          ],
        ),
      ),
    );
  }
}
