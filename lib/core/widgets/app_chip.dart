import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../motion/pressable.dart';

/// A selectable pill (sprint 15): genre, filters, party size. Selected is the
/// action fill with a white label; every select is an [AppHaptics.selection].
class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, required this.selected, required this.onSelected, this.icon});

  final String label;
  final bool selected;

  /// Null disables the chip.
  final VoidCallback? onSelected;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    // InkWell is a lookup boundary, so a chip inside a card cannot see the
    // card's Material. This transparent one is the ancestor ChoiceChip requires.
    final chip = Material(
      type: MaterialType.transparency,
      child: ChoiceChip(
        label: Text(label),
        avatar: icon,
        selected: selected,
        onSelected: onSelected == null
            ? null
            : (_) {
                AppHaptics.selection();
                onSelected!();
              },
      ),
    );
    return onSelected == null ? chip : Pressable(child: chip);
  }
}
