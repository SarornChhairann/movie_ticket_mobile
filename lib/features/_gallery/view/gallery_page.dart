import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/l10n/app_locales.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_list_tile.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/countdown_pill.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/inline_banner.dart';
import '../../../core/widgets/status_chip.dart';
import 'gallery_sections.dart';

/// Debug-only catalog of the design system (sprint 15, decision D1): every
/// component in every state, with the do / don't note that is its spec. The
/// toggles re-render it in Khmer, at 1.5× / 2× text, and with reduced motion.
/// Strings here are developer-facing and deliberately not translated.
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, this.extraSections = const []});

  /// Panels added by later sprints (e.g. the sprint-19 funnel).
  final List<Widget> extraSections;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  double _textScale = 1;
  bool _reduceMotion = false;
  bool _chip = true;
  int _seconds = 75;

  @override
  Widget build(BuildContext context) {
    final khmer = context.locale.languageCode == 'km';
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(_textScale), disableAnimations: _reduceMotion),
      child: Scaffold(
        appBar: AppBar(title: const Text('Component gallery')),
        body: ListView(
          key: const Key('gallery.list'),
          padding: const EdgeInsets.all(Space.screen),
          children: [
            Wrap(
              spacing: Space.x1,
              runSpacing: Space.x1,
              children: [
                AppChip(
                  key: const Key('gallery.khmer'),
                  label: khmer ? 'ខ្មែរ' : 'English',
                  selected: khmer,
                  onSelected: () => context.setLocale(khmer ? AppLocales.en : AppLocales.km),
                ),
                for (final s in const [1.0, 1.5, 2.0])
                  AppChip(label: '${s}x text', selected: _textScale == s, onSelected: () => setState(() => _textScale = s)),
                AppChip(
                  label: 'Reduced motion',
                  selected: _reduceMotion,
                  onSelected: () => setState(() => _reduceMotion = !_reduceMotion),
                ),
              ],
            ),
            GallerySection(
              title: 'Tokens',
              note: 'Read colours from context.tokens and the colour scheme; never a hex colour in a view.',
              child: Wrap(
                spacing: Space.x1,
                runSpacing: Space.x1,
                children: [
                  for (final (name, color) in [
                    ('success', context.tokens.success),
                    ('warning', context.tokens.warning),
                    ('info', context.tokens.info),
                    ('link', context.tokens.link),
                    ('actionFill', context.tokens.actionFill),
                    ('error', AppColors.error),
                    for (var i = 0; i < 4; i++) ('surface $i', context.tokens.surface(i)),
                  ])
                    Swatch(name: name, color: color),
                ],
              ),
            ),
            GallerySection(
              title: 'AppButton',
              note: 'Do: one primary per screen. Don\'t: two filled buttons side by side.',
              child: Wrap(
                spacing: Space.x1,
                runSpacing: Space.x1,
                children: [
                  AppButton.primary(label: 'Primary', onPressed: () {}, expand: false),
                  const AppButton.primary(label: 'Disabled', onPressed: null, expand: false),
                  AppButton.primary(label: 'Loading', onPressed: () {}, loading: true, expand: false),
                  AppButton.tonal(label: 'Tonal', onPressed: () {}),
                  AppButton.ghost(label: 'Ghost', onPressed: () {}),
                  AppButton.destructive(label: 'Release seats', onPressed: () {}),
                ],
              ),
            ),
            GallerySection(
              title: 'AppChip',
              note: 'Do: short labels. Don\'t: use a chip as the main action.',
              child: Wrap(spacing: Space.x1, children: [
                AppChip(label: 'Selected', selected: _chip, onSelected: () => setState(() => _chip = !_chip)),
                AppChip(label: 'Not selected', selected: !_chip, onSelected: () => setState(() => _chip = !_chip)),
                const AppChip(label: 'Disabled', selected: false, onSelected: null),
              ]),
            ),
            GallerySection(
              title: 'StatusChip',
              note: 'Read-only. Colour is never the only signal: the label says the state.',
              child: Wrap(spacing: Space.x1, children: [
                for (final tone in StatusTone.values) StatusChip(label: tone.name, tone: tone),
              ]),
            ),
            GallerySection(
              title: 'InlineBanner',
              note: 'Above usable content. One action at most.',
              child: Column(children: [
                InlineBanner(message: 'You are offline.', actionLabel: 'Retry', onAction: () {}),
                const SizedBox(height: Space.x1),
                InlineBanner(message: 'F7 was just taken.', tone: StatusTone.warning, onDismiss: () {}),
                const SizedBox(height: Space.x1),
                const InlineBanner(message: 'Hold extended.', tone: StatusTone.success),
              ]),
            ),
            GallerySection(
              title: 'CountdownPill',
              note: 'Warning at 60 s, one pulse, never loops. Tabular digits.',
              child: Row(children: [
                CountdownPill(secondsLeft: _seconds),
                const SizedBox(width: Space.x2),
                AppButton.ghost(label: '−20 s', onPressed: () => setState(() => _seconds = (_seconds - 20).clamp(0, 600))),
                AppButton.ghost(label: 'Reset', onPressed: () => setState(() => _seconds = 75)),
              ]),
            ),
            GallerySection(
              title: 'AppListTile',
              note: '48 dp minimum height; presses scale when tappable.',
              child: Column(children: [
                AppListTile(leading: const Icon(Icons.qr_code_2), title: const Text('Tappable'), onTap: () {}),
                const AppListTile(leading: Icon(Icons.info_outline), title: Text('Static'), subtitle: Text('No onTap')),
              ]),
            ),
            GallerySection(
              title: 'AppSheet / AppDialog',
              note: 'The safe choice is first; destructive confirms say what they destroy.',
              child: Wrap(spacing: Space.x1, children: [
                AppButton.tonal(
                  label: 'Open sheet',
                  onPressed: () => AppSheet.show<void>(
                    context,
                    builder: (_) => const Padding(padding: EdgeInsets.all(Space.x3), child: Text('A sheet')),
                  ),
                ),
                AppButton.tonal(
                  label: 'Open dialog',
                  onPressed: () => AppDialog.confirm(
                    context,
                    title: 'Release 3 seats?',
                    body: 'Someone else can book them.',
                    confirmLabel: 'Release',
                    cancelLabel: 'Keep seats',
                    destructive: true,
                  ),
                ),
              ]),
            ),
            GallerySection(
              title: 'EmptyState / ErrorState',
              note: 'Every empty and error state offers a way forward.',
              child: SizedBox(
                height: 420,
                child: Column(children: [
                  Expanded(child: EmptyState(icon: Icons.local_activity_outlined, actionLabel: 'Browse', onAction: () {})),
                  Expanded(child: ErrorState(message: 'Server message here.', onRetry: () {})),
                ]),
              ),
            ),
            ...widget.extraSections,
          ],
        ),
      ),
    );
  }
}
