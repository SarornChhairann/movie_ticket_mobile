import 'package:flutter/material.dart';

import 'empty_state.dart';

/// [EmptyState] under its sprint-2 name.
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.messageKey = 'common.empty'});

  final String messageKey;

  @override
  Widget build(BuildContext context) => EmptyState(messageKey: messageKey);
}
