import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';

/// Rounded search field with a filter button on the right.
class SearchPill extends StatelessWidget {
  const SearchPill({
    super.key,
    required this.hint,
    required this.onChanged,
    this.onFilter,
    this.filterTooltip,
    this.controller,
    this.fieldKey,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilter;
  final String? filterTooltip;
  final TextEditingController? controller;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: fieldKey,
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search, color: AppColors.mist),
              isDense: true,
            ),
          ),
        ),
        if (onFilter != null) ...[
          const SizedBox(width: Space.x1 + 4),
          Material(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(Radii.card),
            child: IconButton(
              key: const Key('search.filter'),
              tooltip: filterTooltip,
              onPressed: onFilter,
              icon: const Icon(Icons.tune, color: AppColors.white),
            ),
          ),
        ],
      ],
    );
  }
}
