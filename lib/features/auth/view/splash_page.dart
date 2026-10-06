import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/ticket_emblem.dart';

/// Shown while the stored session is restored (`AuthState.unknown`).
///
/// "Admit one": a spotlight comes up, the ticket draws itself and fills, then the
/// name and tagline rise in. `App` keeps it on screen for at least [minDisplay]
/// so the animation is never cut off, and leaves as soon as both that time has
/// passed and the session is restored. The progress hint appears only if restoring
/// is still running after [progressDelay], so a normal start never shows a
/// spinner. With reduced motion the final frame is shown at once.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const introDuration = Motion.splashIntro;

  /// The animation plus a short hold on the finished logo.
  static const minDisplay = Motion.splashMinDisplay;

  /// Only a genuinely slow restore (past [minDisplay]) shows the loading bar.
  static const progressDelay = Motion.splashProgressDelay;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(vsync: this, duration: SplashPage.introDuration);
  late final AnimationController _glow = AnimationController(vsync: this, duration: glowPeriod);

  /// One breath of the glow behind the ticket.
  static const glowPeriod = Motion.splashGlow;

  /// Ticker-driven delay before the progress hint; keeps its length under reduced motion.
  late final AnimationController _progressDelay = AnimationController(
    vsync: this,
    duration: SplashPage.progressDelay,
    animationBehavior: AnimationBehavior.preserve,
  );
  bool _showProgress = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
      _glow.value = 0.5;
    } else {
      _intro.forward();
      _glow.repeat(reverse: true);
    }
    _progressDelay
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) setState(() => _showProgress = true);
      })
      ..forward();
  }

  @override
  void dispose() {
    _progressDelay.dispose();
    _intro.dispose();
    _glow.dispose();
    super.dispose();
  }

  Animation<double> _phase(double begin, double end, [Curve curve = Motion.decelerate]) => CurvedAnimation(
    parent: _intro,
    curve: Interval(begin, end, curve: curve),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final emblemWidth = (width * 0.36).clamp(120.0, 180.0);

    final beam = _phase(0, 0.3);
    final draw = _phase(0.05, 0.55, Motion.emphasized);
    final fill = _phase(0.45, 0.72);
    final title = _phase(0.55, 0.85);
    final tagline = _phase(0.7, 1);

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Projector beam from the top, and a soft glow behind the ticket. Decorative.
          FadeTransition(
            opacity: beam,
            child: AnimatedBuilder(
              animation: _glow,
              builder: (context, _) => CustomPaint(painter: _SpotlightPainter(glow: _glow.value)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 5),
                // Decorative: the title below names the app for screen readers.
                ExcludeSemantics(
                  child: AnimatedBuilder(
                    animation: _intro,
                    builder: (context, _) => TicketEmblem(
                      key: const Key('splash.emblem'),
                      width: emblemWidth,
                      draw: draw.value,
                      fill: fill.value,
                    ),
                  ),
                ),
                const SizedBox(height: Space.x4),
                _Rise(
                  animation: title,
                  child: Semantics(
                    header: true,
                    child: Text(
                      'app.title'.tr(context: context),
                      key: const Key('splash.title'),
                      style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: Space.x1),
                _Rise(
                  animation: tagline,
                  child: Text(
                    'splash.tagline'.tr(context: context),
                    key: const Key('splash.tagline'),
                    style: textTheme.bodyLarge?.copyWith(color: AppColors.mist.withValues(alpha: 0.75)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 4),
                SizedBox(
                  height: Space.x6,
                  child: AnimatedOpacity(
                    opacity: _showProgress ? 1 : 0,
                    duration: Motion.medium,
                    // Announce as soon as it appears, not after the fade-in.
                    alwaysIncludeSemantics: true,
                    child: _showProgress
                        ? Semantics(
                            liveRegion: true,
                            child: Center(
                              child: SizedBox(
                                key: const Key('splash.progress'),
                                width: 96,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                  child: LinearProgressIndicator(
                                    minHeight: 3,
                                    color: AppColors.blue,
                                    backgroundColor: AppColors.navyRaised,
                                    semanticsLabel: 'splash.loading'.tr(context: context),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fades a child in while sliding it up a little.
class _Rise extends StatelessWidget {
  const _Rise({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}

/// A soft cone of blue light from the top centre, and a breathing glow where the
/// ticket sits. [glow] runs 0 → 1 → 0.
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({required this.glow});

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final ticketY = size.height * 0.42;

    final beam = Path()
      ..moveTo(cx - size.width * 0.06, 0)
      ..lineTo(cx + size.width * 0.06, 0)
      ..lineTo(cx + size.width * 0.55, ticketY + size.height * 0.08)
      ..lineTo(cx - size.width * 0.55, ticketY + size.height * 0.08)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blue.withValues(alpha: 0.22),
            AppColors.blue.withValues(alpha: 0.06),
            AppColors.blue.withValues(alpha: 0),
          ],
          stops: const [0, 0.6, 1],
        ).createShader(Rect.fromLTWH(0, 0, size.width, ticketY + size.height * 0.08)),
    );

    final radius = size.width * (0.42 + 0.06 * glow);
    canvas.drawCircle(
      Offset(cx, ticketY),
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.blue.withValues(alpha: 0.18 + 0.08 * glow),
            AppColors.blue.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, ticketY), radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.glow != glow;
}
