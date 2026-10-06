import 'package:flutter/material.dart';

import 'app_button.dart';

/// Full-width pill action: [AppButton.primary] under its sprint-8 name.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) =>
      AppButton.primary(label: label, onPressed: onPressed, loading: loading, icon: icon);
}
