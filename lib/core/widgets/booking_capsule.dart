import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/tokens.dart';
import 'countdown_pill.dart';

/// What is being bought, pinned under the progress header on every step
/// (sprint 16): poster · title · date, time, hall · seats once chosen · the hold
/// timer once held. It is a shared element: it grows out of the showtime chip
/// on Detail and stays put while the steps change under it.
class BookingCapsule extends StatelessWidget {
  const BookingCapsule({
    super.key,
    required this.showtimeId,
    required this.title,
    required this.line,
    this.poster,
    this.seats = const [],
    this.secondsLeft,
    this.timerLabel,
    this.timerAnnouncement,
    this.hero = true,
  });

  final int showtimeId;
  final String title;

  /// `Hall · date · time`, already formatted for the language.
  final String line;
  final Widget? poster;
  final List<String> seats;

  /// Seconds left on the hold; null hides the timer.
  final int? secondsLeft;

  /// What a screen reader hears for the timer.
  final String? timerLabel;

  /// Spoken at 60 s and 10 s left.
  final String Function(int seconds)? timerAnnouncement;

  /// Off where several capsules share one screen (the ticket pager).
  final bool hero;

  /// One tag per booking flow (a flow is one showtime at a time), shared by the
  /// Detail showtime chip and every step's capsule.
  static Object heroTag(int showtimeId) => 'booking-capsule-$showtimeId';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tokens = context.tokens;
    final capsule = Material(
        key: const Key('flow.capsule'),
        color: tokens.surface(1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radii.card)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(Space.x1 + Space.x0_5),
          child: Row(
            children: [
              if (poster != null) ...[
                ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTokens.radii.sm),
                    child: SizedBox(width: 40, height: 60, child: poster),
                  ),
                ),
                const SizedBox(width: Space.x1 + Space.x0_5),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(line, style: text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (seats.isNotEmpty)
                      Text(
                        seats.join(', '),
                        key: const Key('flow.capsule.seats'),
                        style: tokens.numeric.copyWith(fontSize: text.bodySmall?.fontSize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (secondsLeft != null) ...[
                const SizedBox(width: Space.x1),
                CountdownPill(secondsLeft: secondsLeft!, semanticsLabel: timerLabel, announce: timerAnnouncement),
              ],
            ],
          ),
        ),
      );
    return hero ? Hero(tag: heroTag(showtimeId), child: capsule) : capsule;
  }
}
