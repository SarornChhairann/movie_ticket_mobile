# Sprint 8 — Motion, journey flow, and the coming-soon carousel

## Goal

Make the booking journey feel continuous instead of a series of page swaps: one motion system for every screen change and state change, a hero **Coming soon** carousel on Home, and loading states that keep the layout still. Motion explains where things came from and what changed — it never delays a task, invents data, or animates money.

Depends on: sprints 0–7 and `ui-enhancement` (dark theme, bottom-bar shell, rails, detail, seat screen, auth gate, splash). Analytics: no domain change — this sprint reads only data the app already loads. No gap rows.

## Principles (apply to every item below)

1. **Purposeful.** Each animation answers one question: *where did this come from* (hero, shared axis), *what changed* (fade-through, morph), or *did my tap work* (press, confirm). Decoration-only loops are out.
2. **Fast.** Standard 200–300 ms, enter slower than exit, nothing that blocks input. A user who taps quickly is never made to wait for an animation to finish.
3. **One system.** Durations, curves, and transitions come from `core/motion` tokens — no inline `Duration(milliseconds: …)` in feature views.
4. **Reduced motion is first-class.** With the OS "reduce motion" setting (`MediaQuery.disableAnimationsOf`): transitions become a short crossfade or none, nothing auto-advances, nothing loops, staggers are off. The app is fully usable with zero motion.
5. **Truthful.** Never tween prices or totals (no count-up from 0 to $22.50 — the intermediate numbers are false); swap them with a crossfade. Never animate a seat to "booked" before the server says so.
6. **Smooth.** 60 fps on a mid-range Android (no frame over 16 ms in the profiled flows). Animate opacity/transform, not layout; decode images at display size; `RepaintBoundary` around moving parts.

## Acceptance

- [x] `core/motion` defines the tokens (durations, curves) and the transitions (shared axis, fade-through, fade, container-style hero) used by every route; no feature view hard-codes a duration or curve.
- [x] Home shows a **Coming soon** hero carousel (`CarouselView.weighted`) above the rails: large focused card plus smaller neighbours, snapping, page dots, release-date countdown, and a **Remind me** action.
- [x] The carousel auto-advances every 5 s and pauses while touched, while a screen reader is on, while Home is not visible, and permanently under reduced motion. It never auto-advances past the last card back to the first with a long reverse scroll (it jumps with a fade).
- [x] The carousel uses only the coming-soon list `MovieListBloc` already loads, honours the selected genre and search, and hides when that list is empty. No new endpoint.
- [x] Opening a movie from the carousel, a rail, or the Explore grid animates the poster into the detail banner (hero) and back; the same movie on two surfaces never shares a hero tag.
- [x] Journey transitions follow the table in **Step 1.2** (shared axis forward/back through Detail → Seats → Checkout → Success, fade-through between bottom-bar tabs, sheet for login).
- [x] First load of Home, Explore, and Bookings shows skeleton placeholders in the final layout (no spinner, no layout jump when data arrives); later refreshes keep content on screen.
- [x] Micro-interactions: seat select/deselect, Book Ticket enable, chip selection, price-line updates on re-quote, booking chip `confirmed → cancelled`, pay success.
- [x] Pay success plays a short "ticket issued" moment (≤ 900 ms) with a success haptic; reduced motion shows the final state.
- [x] With reduced motion on, every acceptance flow above still completes and no widget test sees a running animation after the first frame.
- [ ] Profiled on a mid-range Android in `--profile`: Home cold start, carousel swipe, poster → detail, and detail → seats show no frame over 16 ms on the UI or raster thread.
- [x] New copy keys exist in `en.json` and `km.json` (parity test passes).

### Status (2026-10-02)

Implemented. `flutter analyze` is clean and `flutter test` passes (247, of which 30 are new for this sprint): carousel behaviour with fake time (auto-advance, touch pause and 8 s resume, reduced motion, screen reader, last → first fade jump, Remind me, open detail, semantics label), release countdown, route-transition table, unique hero tags, money crossfade (no intermediate amounts), skeleton = loaded height, reminder sheet, and a reduced-motion sweep of Home, detail, seats, checkout, success, and Bookings (nothing running after the first frame). Visual frames were checked as rendered test images with Poppins.

**Open:** the 60 fps profile run (`flutter run --profile`, DevTools frame chart) on a mid-range Android and the device/simulator walk-through in English and Khmer — the profiling box above stays unchecked until then.

Where the build differs from the plan, and why:

- **Carousel geometry:** full bleed with `flexWeights [1, 7, 1]`. With side padding, the first and last cards left an empty strip; full bleed turns the neighbour slots into the screen margin, so end cards sit centred. `[7, 1]` was rejected: its last card can never become the focused one.
- **Parallax:** no separate 0.3× image shift. The Material 3 hero layout already reveals the banner as the card widens (mask effect); focus also drives the dimming and the text fade. Revisit only if the profile run has headroom.
- **Focus and dots** come from each card's measured width (the widest card is focused), because `onIndexChanged` reports the leading item, which cannot tell "first card focused" from "second card focused" in this layout.
- **Ticket → QR** uses shared axis Y instead of a hero: the source is a small list icon and the target a full QR image, which morph poorly.
- **Genre filter on rails** crossfades the whole rail instead of sliding remaining cards to their new places (simpler, no jank risk, same intent: explain the change).
- **Predictive back (Android 14+):** the custom shared-axis routes (`PageRouteBuilder`) do not get the system back preview; only the login sheet (`MaterialPageRoute`) does. Getting it everywhere means expressing these transitions as a `PageTransitionsTheme` builder — a follow-up.
- **No new package:** transitions are built on `PageRouteBuilder` / `AnimatedSwitcher`; the `animations` package was not added.

## API contract

No new calls. Contract check only: `GET /movies?tab=COMING_SOON&search=` returns `movies[]` with `id`, `title`, `genre`, `rating`, `releaseDate` (ISO date), `imagePath`, `bannerPath`, `trailerUrl` — already mapped to `Movie` (`posterUrl`, `bannerUrl`, `releaseDate`). Remind me reuses `POST /api/reminders` (sprint 7).

## Step 1 — UX/UI

### 1.1 Motion tokens

| Token | Value | Use |
| --- | --- | --- |
| `Motion.short` | 150 ms | Press feedback, chip select, icon swaps |
| `Motion.medium` | 250 ms | Fades, crossfades, small size changes |
| `Motion.long` | 350 ms | Route transitions (enter) |
| `Motion.extraLong` | 500 ms | Hero / container transform, carousel page |
| `Motion.emphasized` | `Curves.easeInOutCubicEmphasized` | Route enter, hero |
| `Motion.decelerate` | `Curves.easeOutCubic` | Elements entering |
| `Motion.accelerate` | `Curves.easeInCubic` | Elements leaving (exit = 0.7× enter duration) |
| `Motion.stagger` | 40 ms per item, max 6 items | First-load list entrance |

All durations go through `Motion.of(context)`, which returns zero/crossfade values under reduced motion.

### 1.2 Journey map and transitions

| # | Journey step | From → To | Transition | Why |
| --- | --- | --- | --- | --- |
| J1 | Browse | Splash → Home | Fade (exists) | Root change, no spatial relation |
| J1 | Switch tab | Home ⇄ Explore ⇄ Bookings ⇄ Profile | Fade-through (out 90 ms, in 210 ms, 0.92→1 scale) | Peers, not a hierarchy |
| J1 | Pick a movie | Carousel / rail / grid card → Detail | Hero: poster grows into the banner; detail card rises with shared axis Y | Continuity of the chosen object |
| J1 | Choose showtime | Detail → Seats | Shared axis X forward (back reverses) | Next step in a sequence |
| J1 | Hold seats | Seats → Checkout | Shared axis X forward | Next step |
| J1 | Pay | Checkout → Success | Fade-through + "ticket issued" moment | Outcome, not a place |
| J1 | View ticket | Success / Booking → QR | Hero: ticket row → QR card | Same ticket, closer look |
| J2 | Needs account | Any → Login | Sheet slide up (exists, `fullscreenDialog`) | Interruption, returns to the same place |
| J2 | Signed in | Login → back to action | Sheet slide down, action continues | Resume, not restart |
| J3 | Manage booking | Bookings → Detail → Cancel | Shared axis X; chip morph on cancel | Hierarchy; state change in place |
| J4 | Remind me | Carousel / detail → Reminder sheet | Bottom sheet; success check morph | Quick action without leaving Home |

Back always plays the reverse of the forward transition. (Predictive back: see Status below.)

### 1.3 Home — Coming soon carousel

Layout, top to bottom: greeting + avatar, search pill, **Coming soon carousel**, genre chips, "Now in Cinemas" rail, (the "Upcoming movies" rail is removed — the carousel replaces it; "See all" on the carousel header opens Explore › Coming soon).

- **Component:** `CarouselView.weighted` with `flexWeights: [1, 7, 1]` (hero layout: one large focused card, slivers of neighbours), `itemSnapping: true`, height 220 at 360 dp width (scales with width, 16:9-ish card), 16 dp gap, radius 24.
- **Card:** banner (`bannerUrl`, else poster, else banner placeholder) with a bottom navy gradient for legibility; title (titleLarge), genre · rating; release badge: "In 12 days" / "Tomorrow" / "Out now" / the date when > 60 days (computed from `releaseDate` against today, cinema zone, date only); **Remind me** tonal button.
- **Parallax:** the banner inside the focused card moves at 0.3× the scroll offset (transform only).
- **Focus:** non-focused cards dim to 60% and scale to 0.92; the focused card animates to full (driven by scroll position, not a timer — it tracks the finger).
- **Dots:** below the carousel, active dot stretches to a pill (`AnimatedContainer`, `Motion.medium`). Tappable, 24 dp hit target.
- **Auto-advance:** every 5 s, `CarouselController.animateToItem(next, duration: Motion.extraLong, curve: Motion.emphasized)`. Stops on touch and resumes 8 s after the last interaction; off when `MediaQuery.accessibleNavigationOf` is true, under reduced motion, when the app is backgrounded, and when Home is not the visible tab. From the last card it fades to the first instead of scrolling back across all cards.
- **Remind me:** opens a bottom sheet with the existing `ReminderForm` (email prefilled when signed in). Success morphs the button to "Subscribed ✓" for that card for the session; `REMINDER_EXISTS` shows the same state (friendly, sprint 7).
- **Tap card:** opens detail with the hero transition.
- **States:** loading → skeleton card at the same size; empty (after genre/search filter) → the whole section hides with a `Motion.medium` size/fade; error → hidden (the rails show the error).
- **Accessibility:** each card is one semantics node: "Coming soon, 2 of 5, Avatar 3, releases in 12 days. Double-tap to open." Remind me is a separate button. Auto-advance never runs with a screen reader. Text scales to 200% without clipping (card grows).

### 1.4 Loading and list motion

- Skeletons (`core/widgets/skeleton.dart`): navy-raised blocks in the final layout with a slow 1.2 s shimmer sweep; static under reduced motion. Used for the carousel, rails, Explore grid, Bookings list, Profile header.
- First load only: items fade + rise 8 dp with a 40 ms stagger (max 6, the rest appear together). Refresh, filter, and search changes crossfade the content (`AnimatedSwitcher`), never re-stagger.
- Genre filter: cards leaving fade out (`Motion.short`), remaining cards slide to their new place (implicit animated list in the rail), new ones fade in.

### 1.5 Micro-interactions

| Element | Feedback |
| --- | --- |
| Any card / button press | Scale 0.97 on press, back on release (`Motion.short`) |
| Seat tap | Fill animates outline → blue with a 1.0 → 1.12 → 1.0 pop; deselect reverses; light haptic |
| Seat taken by someone else (realtime) | Brief 2-pulse of the held outline, then settles; no haptic |
| Seat count / Book Ticket | Count crossfades; button enables with a colour fade, never a size jump |
| Chips (date, time, genre) | Selected fill animates; checkmark-free |
| Re-quote (promo/food) | Changed price lines crossfade; the total swaps with a crossfade — no count-up |
| Booking cancel | Chip morphs Confirmed → Cancelled (colour + label crossfade); ticket rows dim |
| Pay success | Ticket "prints": slides up from a slot with a slight overshoot, perforation tear, success haptic (≤ 900 ms) |
| Pull to refresh | Platform indicator (exists) |
| Errors | Inline banner slides down `Motion.medium`; snackbars use the platform motion |

### 1.6 Copy keys

`home.comingSoon`, `home.comingSoonCount` (`{index} of {count}`), `release.inDays` (plural: `release.inDays.one|other`), `release.tomorrow`, `release.outNow`, `release.on` (`{date}`), `reminders.subscribed`, `a11y.carouselItem` (`Coming soon, {index} of {count}, {title}, {release}`), `a11y.pauseCarousel`. English and Khmer together.

## Step 2 — Backend

None. Confirm with the contract check that coming-soon movies carry `releaseDate` and `bannerPath` in seeded data; if seed banners are missing, the placeholder path covers it (no backend change).

## Step 3 — Frontend

1. **`core/motion/`**
   - `motion.dart`: tokens above; `Motion.of(context)` → resolved durations (zero under reduced motion); `context.reduceMotion`.
   - `transitions.dart`: `SharedAxisPageRoute` (X/Y), `FadeThroughSwitcher`, `FadeThroughTransition` built on `PageRouteBuilder`/`AnimatedSwitcher` — **no new package** (the `animations` package would be the only alternative; adding it needs approval per the package rule in `CLAUDE.md`).
   - `AppRouter` picks the transition per route from the Step 1.2 table (one place), replacing per-call `MaterialPageRoute`.
   - `pressable.dart`: shared press-scale + optional haptic wrapper.
2. **Hero tags:** `HeroTags.poster(movieId, source)` where `source` ∈ `carousel | nowShowing | explore | detail`; detail receives the source in its route argument so the reverse flight lands on the right card.
3. **Carousel (`features/catalog/view/coming_soon_carousel.dart`):** reads `MovieListBloc` (`moviesFor(MovieTab.comingSoon)`), owns a `CarouselController` and an `AutoAdvance` helper (ticker-driven, pausable; stops on `AppLifecycleState.paused`, on touch, when not visible via `TickerMode`, under reduced motion / accessible navigation). Release badge text via a pure `ReleaseCountdown.of(releaseDate, today)` (unit-tested). Images: `PosterImage` with `cacheWidth` = display width × DPR; precache the next card's banner.
4. **Reminder sheet:** `showReminderSheet(context, movie)` hosts the existing `ReminderForm` with a `ReminderBloc` from the router-provided factory; per-session "subscribed" set kept in the sheet's caller state (UI only, server stays the authority).
5. **Skeletons:** `core/widgets/skeleton.dart` (`SkeletonBox`, `SkeletonRail`, `SkeletonGrid`, `SkeletonList`) replacing `LoadingView` in Home, Explore, Bookings first load.
6. **Shell:** bottom-bar tab body wrapped in `FadeThroughSwitcher`; Home ticker-driven widgets wrapped in `TickerMode(enabled: tab == home)`.
7. **Seats / checkout / bookings / success:** micro-interactions from 1.5 using implicit animations (`AnimatedContainer`, `AnimatedSwitcher`, `TweenAnimationBuilder`); pay success moment as a self-contained `TicketIssuedAnimation` (one controller, ≤ 900 ms, reduced motion → final frame).
8. **Haptics:** `HapticFeedback.selectionClick` on seat toggle, `mediumImpact` on pay success; nothing else.

Order: 1 → 2 → 3 (+4) → 5 → 6 → 7 → 8. Each step keeps `flutter test` green.

## Step 4 — Testing

1. **Unit:** `ReleaseCountdown` (today, tomorrow, 1 day, 12 days, 61 days → date, past → out now, null → hidden; cinema date, not device time zone); `Motion.of` under reduced motion returns zero durations.
2. **Carousel widget tests (fake time):**
   - shows only coming-soon movies, respects genre filter, hides when empty;
   - auto-advances after 5 s; a drag pauses it; resumes 8 s later;
   - no auto-advance when `disableAnimations` or `accessibleNavigation` is true, or when not the active tab;
   - last → first uses the fade jump, not a reverse scroll;
   - semantics label "Coming soon, 1 of 3, …"; Remind me is its own button and opens the reminder sheet; tap opens detail with the movie id.
3. **Hero:** carousel and rail showing the same movie produce different tags; detail argument carries the source.
4. **Transitions:** `AppRouter` returns the transition type from the 1.2 table for each route (one table-driven test).
5. **Reduced motion sweep:** pump Home, detail, seats, checkout, success, bookings with `disableAnimations: true`; after one frame `tester.hasRunningAnimations` is false.
6. **Money truthfulness:** re-quote widget test asserts the total text never shows a value other than the old or the new server total during the transition.
7. **Skeletons:** first-load states render skeletons with the same item sizes as the loaded layout (no size change on data arrival).
8. **Manual / profile:** `flutter run --profile` on a mid-range Android; DevTools frame chart for the four flows in the acceptance list; record results in this file.

## Definition of done

Every acceptance box is true on a real Android device and an iOS simulator in English and Khmer, with reduced motion both off and on. The profile run shows no janky frames in the four flows. `flutter analyze` is clean and `flutter test` passes. No new package was added (or the `animations` package was approved and recorded in `CLAUDE.md`).

## Out of scope

New endpoints, trailer playback in the carousel (the play button still opens the link), Lottie/Rive assets, a light theme, onboarding, push notifications, motion in admin screens, changing booking or price rules.
