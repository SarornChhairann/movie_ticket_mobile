import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../motion/motion.dart';
import 'inline_banner.dart';

/// "You're offline" sliding down over every screen while [offline] is true
/// (sprint 19). It covers no input: the screen under it stays usable.
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key, required this.offline, required this.child});

  final ValueListenable<bool> offline;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<bool>(
            valueListenable: offline,
            builder: (context, isOffline, _) => IgnorePointer(
              ignoring: !isOffline,
              child: AnimatedSlide(
                offset: isOffline ? Offset.zero : const Offset(0, -1),
                duration: context.motion(Motion.medium),
                curve: Motion.decelerate,
                child: AnimatedOpacity(
                  opacity: isOffline ? 1 : 0,
                  duration: context.motion(Motion.medium),
                  child: SafeArea(
                    bottom: false,
                    child: InlineBanner(
                      key: const Key('app.offlineBanner'),
                      message: 'shell.offline'.tr(context: context),
                      icon: Icons.cloud_off,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
