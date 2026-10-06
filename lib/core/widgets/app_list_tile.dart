import 'package:flutter/material.dart';

import '../motion/pressable.dart';
import '../theme/spacing.dart';

/// A row (sprint 15): a `ListTile` with a 48 dp minimum height and, when it is
/// tappable, the press feedback every tappable surface shares.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.contentPadding,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final tile = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: Space.minTarget),
      child: ListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        contentPadding: contentPadding,
      ),
    );
    return onTap == null ? tile : Pressable(child: tile);
  }
}

/// An `InkWell` with the shared press feedback, for cards and custom tappables.
class PressableInkWell extends StatelessWidget {
  const PressableInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.customBorder,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;

  @override
  Widget build(BuildContext context) {
    final ink = InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      customBorder: customBorder,
      child: child,
    );
    return onTap == null && onLongPress == null ? ink : Pressable(child: ink);
  }
}
