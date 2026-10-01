import 'package:flutter/widgets.dart';

import 'motion.dart';

/// Turns [Entrance] on for the widgets built in the first frame under it, and
/// off afterwards — so a list staggers in on first load but never again on
/// refresh, filter, or search.
class EntranceScope extends StatefulWidget {
  const EntranceScope({super.key, required this.child});

  final Widget child;

  @override
  State<EntranceScope> createState() => _EntranceScopeState();
}

class _EntranceScopeState extends State<EntranceScope> {
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _enabled = false);
    });
  }

  @override
  Widget build(BuildContext context) => _EntranceEnabled(enabled: _enabled, child: widget.child);
}

class _EntranceEnabled extends InheritedWidget {
  const _EntranceEnabled({required this.enabled, required super.child});

  final bool enabled;

  @override
  bool updateShouldNotify(_EntranceEnabled old) => old.enabled != enabled;
}

/// Fades [child] in while it rises 8 dp, delayed by [index] × [Motion.staggerStep]
/// (items past [Motion.staggerMax] share the last delay). Only inside an enabled
/// [EntranceScope], and never under reduced motion.
class Entrance extends StatefulWidget {
  const Entrance({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _t;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final scope = context.getInheritedWidgetOfExactType<_EntranceEnabled>();
    if (scope == null || !scope.enabled || context.reduceMotion) return;
    final delay = Motion.staggerStep * widget.index.clamp(0, Motion.staggerMax);
    final total = delay + Motion.medium;
    _controller = AnimationController(vsync: this, duration: total)..forward();
    _t = CurvedAnimation(
      parent: _controller!,
      curve: Interval(delay.inMicroseconds / total.inMicroseconds, 1, curve: Motion.decelerate),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _t;
    if (t == null) return widget.child;
    return AnimatedBuilder(
      animation: t,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: t.value,
        child: Transform.translate(offset: Offset(0, 8 * (1 - t.value)), child: child),
      ),
    );
  }
}
