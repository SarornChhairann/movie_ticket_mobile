import 'package:flutter/material.dart';

import '../../../core/telemetry/journey_tracker.dart';
import '../../../core/theme/spacing.dart';
import 'gallery_sections.dart';

/// Debug-only: this session's funnel, step by step (sprint 19).
class FunnelPanel extends StatelessWidget {
  const FunnelPanel({super.key, required this.tracker});

  final JourneyTracker tracker;

  @override
  Widget build(BuildContext context) {
    final debug = tracker;
    if (debug is! DebugJourneyTracker) {
      return const GallerySection(title: 'Funnel', note: 'No session counts with this tracker.', child: SizedBox());
    }
    return GallerySection(
      title: 'Funnel',
      note: 'Events this session. Ids and step names only — no personal data.',
      child: ListenableBuilder(
        listenable: debug,
        builder: (context, _) => Column(
          key: const Key('gallery.funnel'),
          children: [
            for (final name in JourneyEventName.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.x0_5),
                child: Row(
                  children: [
                    Expanded(child: Text(name.wire)),
                    Text('${debug.counts[name] ?? 0}', style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
