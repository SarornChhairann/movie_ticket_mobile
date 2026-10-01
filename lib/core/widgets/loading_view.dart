import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/spacing.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: Space.x2),
          Text('common.loading'.tr(context: context)),
        ],
      ),
    );
  }
}
