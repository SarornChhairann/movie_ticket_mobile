import 'package:flutter/material.dart';

import 'error_state.dart';

/// [ErrorState] under its sprint-0 name.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => ErrorState(message: message, onRetry: onRetry);
}
