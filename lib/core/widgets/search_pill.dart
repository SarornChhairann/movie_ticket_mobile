import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';

/// Rounded search field with a filter button on the right.
class SearchPill extends StatelessWidget {
  const SearchPill({
    super.key,
    required this.hint,
    this.onChanged,
    this.onTap,
    this.onFilter,
    this.filterTooltip,
    this.controller,
    this.fieldKey,
    this.filterCount = 0,
  });

  final String hint;
  final ValueChanged<String>? onChanged;

  /// Set for an entry point that opens a search view instead of typing here:
  /// the field is read-only and tapping it calls this.
  final VoidCallback? onTap;
  final VoidCallback? onFilter;
  final String? filterTooltip;
  final TextEditingController? controller;
  final Key? fieldKey;

  /// Active filters; a badge on the filter button when above zero.
  final int filterCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: fieldKey,
            controller: controller,
            onChanged: onChanged,
            readOnly: onTap != null,
            onTap: onTap,
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
              icon: Badge(
                key: filterCount > 0 ? const Key('search.filter.count') : null,
                isLabelVisible: filterCount > 0,
                label: Text('$filterCount'),
                child: const Icon(Icons.tune, color: AppColors.white),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
