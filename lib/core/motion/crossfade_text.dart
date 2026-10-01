import 'package:flutter/widgets.dart';

import 'motion.dart';

/// Text that crossfades when its value changes. Used for money: the old and new
/// server amounts swap directly — never a count-up through amounts the server
/// did not send.
class CrossfadeText extends StatelessWidget {
  const CrossfadeText(this.text, {super.key, this.style, this.textKey});

  final String text;
  final TextStyle? style;

  /// Key on the inner [Text], for finders.
  final Key? textKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: context.motion(Motion.medium),
      switchInCurve: Motion.decelerate,
      switchOutCurve: Motion.accelerate,
      layoutBuilder: (current, previous) =>
          Stack(alignment: AlignmentDirectional.centerEnd, children: [...previous, ?current]),
      child: KeyedSubtree(key: ValueKey(text), child: Text(text, key: textKey, style: style)),
    );
  }
}
