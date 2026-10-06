# Sprint 15 — Design system and interaction foundations

## Goal

One documented, tested set of tokens and components that every later sprint builds on, so the app feels consistent on every tap and a new screen can be built without re-deciding styles.

Depends on: sprint 8 (`core/motion`), `ui-enhancement`. Findings X1, X2, X3, X4, X6 (`experience-enhancement/PLAN.md`). No backend.

## Acceptance

- [ ] **Tokens** in `core/theme/`: `AppText` type scale (display, headline, title, body, label, numeric — tabular figures for times and money), `AppColors` semantic roles (`success`, `warning`, `info`, `onSurfaceMuted`, `scrim`), `Elevation` (surface levels 0–3 as navy tints, no drop shadows on dark), `Radii` (sm 8, card 16, sheet 28, button 24, pill), `Insets`. All exposed through `ThemeData` / a `ThemeExtension` so views read `context.tokens`.
- [ ] Every token pair used for text meets WCAG AA (4.5:1 body, 3:1 large) — checked by a unit test that computes contrast.
- [ ] **Components** in `core/widgets/` with all states (enabled, pressed, focused, disabled, loading, error): `AppButton` (primary / tonal / ghost / destructive), `AppChip`, `AppListTile`, `AppSheet` (drag handle, snap, keyboard-safe), `AppDialog` (confirm / destructive), `StatusChip`, `EmptyState`, `ErrorState`, `InlineBanner`, `CountdownPill`. Existing `PrimaryButton`, `GenreChip`, `ErrorBanner`, `EmptyView`, `ErrorView` become thin aliases or are replaced in place.
- [ ] **Interaction contract:** every tappable surface goes through `Pressable` (scale 0.97, `Motion.short`) and `AppHaptics` (one table: `selection` for chips/seats/steppers, `light` for primary actions, `success` / `warning` / `error` for outcomes). No `HapticFeedback.*` call outside `AppHaptics`.
- [ ] **Predictive back:** route transitions move into a `PageTransitionsTheme` builder (`AppPageTransitions`) driven by the existing `AppRouter.motionFor` table; Android 14+ shows the back preview on every route. Behavior of `motionFor` unchanged (its table test stays green).
- [ ] **Refactor, no behavior change:** `seat_map_page.dart` and `checkout_page.dart` split into widgets under 250 lines each (`seat_grid.dart`, `seat_legend.dart`, `seat_bottom_bar.dart`, `checkout_lines.dart`, `promo_field.dart`, `checkout_bottom_bar.dart`, …). All existing tests pass before any visual change.
- [ ] **Gallery:** debug-only `GalleryPage` (route `/_gallery`, `kDebugMode` only) lists every component in every state, with toggles for language, text scale (1.0 / 1.5 / 2.0), and reduced motion.
- [ ] **Goldens:** one golden per component state (en) plus Khmer for text-heavy ones; Home, Detail, Seats, Checkout, Success screen goldens with seeded blocs. `flutter test --update-goldens` documented in `CLAUDE.md`.
- [ ] **Lint guard:** a test (`test/architecture/no_inline_styles_test.dart`) fails if a `features/**/view` file contains `Duration(milliseconds`, `Color(0x`, `fontSize:`, or `HapticFeedback.`.

## UX

Component spec sheet lives in the gallery itself (each component shows its do / don't note). Copy: `gallery.*` keys are debug-only and excluded from the parity test; new user-facing keys: `common.retry`, `common.cancel`, `common.confirm`, `common.dismiss` (reuse if they already exist).

## Flutter

`core/theme/tokens.dart` (`AppTokens extends ThemeExtension`), `core/theme/app_text.dart`, `core/haptics/app_haptics.dart`, `core/motion/page_transitions.dart`, components above, `features/_gallery/` (debug only, not registered in release DI).

Order: tokens → contrast test → components + goldens → `Pressable`/`AppHaptics` sweep → seat/checkout refactor → predictive back → lint guard.

## Tests

Contrast unit test; component goldens; screen goldens; `AppHaptics` called with the right kind on seat tap, chip, Pay, success (mock the platform channel); `motionFor` table test unchanged; existing 58 test files green after the refactor commit **before** the visual commit.

## Out of scope

Light theme, new screens, new motion beyond the press/haptic contract.
