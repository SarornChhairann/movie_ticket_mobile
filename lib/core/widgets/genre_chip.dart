import 'package:flutter/material.dart';

import 'app_chip.dart';

/// Pill filter chip: [AppChip] under its sprint-8 name.
class GenreChip extends StatelessWidget {
  const GenreChip({super.key, required this.label, required this.selected, required this.onSelected});

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => AppChip(label: label, selected: selected, onSelected: onSelected);
}
