import 'package:flutter/material.dart';

import 'inline_banner.dart';

/// Inline error strip: [InlineBanner] in the error tone, under its old name.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.onDismiss});

  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) => InlineBanner(message: message, onDismiss: onDismiss);
}
