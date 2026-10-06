import 'package:flutter/widgets.dart';

import 'motion.dart';

/// Press feedback: scales [child] to 0.97 while a pointer is down. Purely
/// visual — taps are still handled by the child (InkWell, button, …).
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child});

  final Widget child;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: context.motion(Motion.short),
        curve: Motion.decelerate,
        child: widget.child,
      ),
    );
  }
}

/// The same press feedback for Material buttons, set once in the theme
/// (`ButtonStyle.backgroundBuilder`), so every Filled, Outlined, Text, and Icon
/// button scales on press without each view wrapping it.
Widget pressScaleBuilder(BuildContext context, Set<WidgetState> states, Widget? child) {
  return AnimatedScale(
    scale: states.contains(WidgetState.pressed) ? 0.97 : 1,
    duration: context.motion(Motion.short),
    curve: Motion.decelerate,
    child: child,
  );
}
