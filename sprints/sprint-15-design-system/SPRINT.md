# Sprint 15 — Design system and interaction foundations

## Goal

One documented, tested set of tokens and components that every later sprint builds on, so the app feels consistent on every tap and a new screen can be built without re-deciding styles.

Depends on: sprint 8 (`core/motion`), `ui-enhancement`. Findings X1, X2, X3, X4, X6 (`experience-enhancement/PLAN.md`). No backend.

## Acceptance

- [x] **Tokens** in `core/theme/`: `AppText` type scale (display, headline, title, body, label, numeric — tabular figures for times and money), `AppColors` semantic roles (`success`, `warning`, `info`, `onSurfaceMuted`, `scrim`), `Elevation` (surface levels 0–3 as navy tints, no drop shadows on dark), `Radii` (sm 8, card 16, sheet 28, button 24, pill), `Insets`. All exposed through `ThemeData` / a `ThemeExtension` so views read `context.tokens`.
- [x] Every token pair used for text meets WCAG AA (4.5:1 body, 3:1 large) — checked by a unit test that computes contrast.
- [x] **Components** in `core/widgets/` with all states (enabled, pressed, focused, disabled, loading, error): `AppButton` (primary / tonal / ghost / destructive), `AppChip`, `AppListTile`, `AppSheet` (drag handle, snap, keyboard-safe), `AppDialog` (confirm / destructive), `StatusChip`, `EmptyState`, `ErrorState`, `InlineBanner`, `CountdownPill`. Existing `PrimaryButton`, `GenreChip`, `ErrorBanner`, `EmptyView`, `ErrorView` become thin aliases or are replaced in place.
- [x] **Interaction contract:** every tappable surface goes through `Pressable` (scale 0.97, `Motion.short`) and `AppHaptics` (one table: `selection` for chips/seats/steppers, `light` for primary actions, `success` / `warning` / `error` for outcomes). No `HapticFeedback.*` call outside `AppHaptics`.
- [x] **Predictive back:** route transitions move into a `PageTransitionsTheme` builder (`AppPageTransitions`) driven by the existing `AppRouter.motionFor` table; Android 14+ shows the back preview on every route. Behavior of `motionFor` unchanged (its table test stays green).
- [x] **Refactor, no behavior change:** `seat_map_page.dart` and `checkout_page.dart` split into widgets under 250 lines each (`seat_grid.dart`, `seat_legend.dart`, `seat_bottom_bar.dart`, `checkout_lines.dart`, `promo_field.dart`, `checkout_bottom_bar.dart`, …). All existing tests pass before any visual change.
- [x] **Gallery:** debug-only `GalleryPage` (route `/_gallery`, `kDebugMode` only) lists every component in every state, with toggles for language, text scale (1.0 / 1.5 / 2.0), and reduced motion.
- [x] **Goldens:** one golden per component state (en) plus Khmer for text-heavy ones; Home, Detail, Seats, Checkout, Success screen goldens with seeded blocs. `flutter test --update-goldens` documented in `CLAUDE.md`.
- [x] **Lint guard:** a test (`test/architecture/no_inline_styles_test.dart`) fails if a `features/**/view` file contains `Duration(milliseconds`, `Color(0x`, `fontSize:`, or `HapticFeedback.`.

## UX

Component spec sheet lives in the gallery itself (each component shows its do / don't note). Copy: `gallery.*` keys are debug-only and excluded from the parity test; new user-facing keys: `common.retry`, `common.cancel`, `common.confirm`, `common.dismiss` (reuse if they already exist).

## Flutter

`core/theme/tokens.dart` (`AppTokens extends ThemeExtension`), `core/theme/app_text.dart`, `core/haptics/app_haptics.dart`, `core/motion/page_transitions.dart`, components above, `features/_gallery/` (debug only, not registered in release DI).

Order: tokens → contrast test → components + goldens → `Pressable`/`AppHaptics` sweep → seat/checkout refactor → predictive back → lint guard.

## Tests

Contrast unit test; component goldens; screen goldens; `AppHaptics` called with the right kind on seat tap, chip, Pay, success (mock the platform channel); `motionFor` table test unchanged; existing 58 test files green after the refactor commit **before** the visual commit.

## Out of scope

Light theme, new screens, new motion beyond the press/haptic contract.

## Status

Done 2026-10-07. Flutter 420 tests green, `flutter analyze` clean (0 issues — the long-standing `checkout_page` lint is fixed too).

- **Tokens:** `AppTokens` (`context.tokens`), `AppText`, semantic colours, elevation 0–3, `Radii.sm/card/button/sheet/pill`, `Insets`. The contrast test found three real AA failures, now fixed: white on brand blue (3.7:1) → filled buttons and selected chips use `actionFill` #2A7AA8 (4.7:1); blue text on navy (4.1:1) → `link` #6CB4E0 (6.6:1); error red on the top surface (4.3:1) → #FF8A8A. Brand blue stays for non-text accents (3:1 rule).
- **Components:** all ten built; the five old widgets are aliases, so every existing screen picked them up with no call-site change.
- **Press + haptics:** Material buttons scale through the theme (`ButtonStyle.backgroundBuilder`) instead of wrapping ~60 call sites; cards and rows moved to `PressableInkWell` / `AppListTile`. Haptics: chips, seats, steppers → selection; Continue, Pay, Process payment → light; ticket issued, hold extended → success; payment failed → error. `HapticFeedback` appears only in `AppHaptics` (tested).
- **Predictive back:** every route is a `MotionPageRoute` (a `MaterialPageRoute`); `AppPageTransitions` is set for every platform and hands Android back gestures to `PredictiveBackPageTransitionsBuilder`; `android:enableOnBackInvokedCallback="true"` added. The `motionFor` table test is unchanged. **Needs a device check** on Android 14+: the gesture preview cannot be exercised in widget tests.
- **Refactor:** `seat_map_page.dart` 930 → 138 lines plus 8 part files; `checkout_page.dart` 645 → 178 plus 6; largest file 178 lines. Done as Dart `part` files so private widgets and behaviour are byte-for-byte the same; all tests green before any visual change.
- **Gallery:** `/_gallery`, debug only, with English/Khmer, 1×/1.5×/2× text, and reduced-motion toggles, and a do/don't note per component.
- **Goldens:** 9 component goldens (one per component with all its states side by side, rather than one file per state) incl. Khmer for the empty/error states, and 6 screen goldens (Home, Detail, Seats, Checkout, Success, Bookings) with Poppins and Material icons loaded. Recorded on macOS.
- **Lint guard:** in place; it moved splash, seat glow, ticket-issued, and reminder timings into `Motion`, search/requote debounce into `Debounce`, poster shades and the KHQR red into `AppColors`, and the seat-code size into `AppText.seatCode`.

