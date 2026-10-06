import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/widgets/genre_chip.dart';

/// "How many seats?" (sprint 14): 1 … [max]. Pops the number, or null for **Skip**.
class PartySizeSheet extends StatelessWidget {
  const PartySizeSheet({super.key, required this.max, this.selected});

  final int max;
  final int? selected;

  static Future<int?> show(BuildContext context, {required int max, int? selected}) => showModalBottomSheet<int>(
        context: context,
        showDragHandle: true,
        builder: (_) => PartySizeSheet(max: max, selected: selected),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, Space.x2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('seats.partySize'.tr(context: context), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Space.x2),
            Wrap(
              spacing: Space.x1,
              runSpacing: Space.x1,
              children: [
                for (var n = 1; n <= max; n++)
                  GenreChip(
                    key: Key('party.$n'),
                    label: '$n',
                    selected: n == selected,
                    onSelected: () => Navigator.of(context).pop(n),
                  ),
              ],
            ),
            const SizedBox(height: Space.x2),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                key: const Key('party.skip'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('seats.partySkip'.tr(context: context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
