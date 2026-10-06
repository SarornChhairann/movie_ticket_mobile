# Experience enhancement — sprints 15–19

Sprints 0–14 deliver a complete, safe booking path, and sprint 8 gave it one motion system. This plan raises the app to an **enterprise-grade experience**: a design system that scales past one developer, a booking journey that reads as one continuous flow, a seat map and ticket wallet that feel premium, and a measurable quality bar (accessibility, performance, UX telemetry).

It does **not** change price math, seat states, roles, or payment. Backend work is limited to one optional read (sprint 18). Same method as every sprint: contract check → UX → backend → Flutter → tests → demo.

Read first: `sprints/README.md`, `sprints/sprint-08-motion-carousel/SPRINT.md` (motion principles 1–6 still apply to every item here), `sprints/ui-enhancement/PLAN.md` (visual system).

## Principles

1. **Journey over screens.** Every change is judged by what it does to a journey in the map below, not by how one screen looks.
2. **Motion is information.** Sprint 8 principles stand: purposeful, fast (enter ≤ 350 ms, never blocks input), one token system, reduced motion first-class, truthful (never tween money, never show "booked" before the server).
3. **System before screens.** A component is built once in `core/`, documented, golden-tested, then used. No one-off styling in feature views.
4. **Accessible by default.** WCAG 2.2 AA contrast, 200% text scale, screen-reader order, 48 dp targets — in English **and** Khmer.
5. **Measured.** A UX claim ("faster checkout") is backed by a funnel number or a frame chart, recorded in the sprint's Status.
6. **No new packages without approval.** Each candidate is listed under *Decisions to confirm*; the default path works without it.

## Analysis — what holds the experience back today

Verified against source on 2026-10-06.

| # | Finding | Evidence | Impact |
| --- | --- | --- | --- |
| X1 | Design tokens stop at color and spacing. No type scale, elevation, semantic colors (success / warning / info), or component state tokens. | `core/theme/app_colors.dart` has 7 colors; `spacing.dart` has `Space` + 2 radii | Screens drift; each new view re-decides sizes and states. Hard to onboard a second developer or a designer. |
| X2 | Press feedback and haptics are inconsistent. | `Pressable` used only by `poster_card.dart`; `HapticFeedback` only in seat toggle and ticket issued | Buttons, chips, rows, and food steppers feel "dead" next to posters. |
| X3 | Two god-views. | `seat_map_page.dart` 928 lines, `checkout_page.dart` 636 lines | Slow to change safely; motion and a11y fixes collide. |
| X4 | No visual regression safety. | 0 golden tests in `test/` | A theme token change can silently break 50+ views. |
| X5 | The booking path has no sense of place. Detail → Seats → Snacks → Checkout → PayWay → Success are separate pages with no progress, no persistent summary, and back can drop a live hold without asking. | No step indicator; `PopScope` only on login and PayWay | Users don't know how far they are from done; accidental back loses seats. |
| X6 | Predictive back is missing on custom routes. | Sprint 8 Status: shared-axis `PageRouteBuilder` routes skip the Android 14+ back preview | Feels non-native on modern Android. |
| X7 | Seat map is functional, not delightful or accessible. Zoom exists (`InteractiveViewer`) but no focus on selection, no mini-map, no row/seat labels on press, and a screen-reader user must swipe seat by seat. | `seat_map_page.dart` | The highest-emotion screen is the flattest; screen-reader booking is very slow. |
| X8 | Tickets live three taps deep. No "next show" on Home; QR screen is a plain image. | `TicketQrPage`; Home has no upcoming-ticket surface | At the cinema door the user hunts for the ticket. |
| X9 | Accessibility coverage is thin. | `Semantics(` in 6 files out of 55 view files; text scale referenced in 1 | Large-text and screen-reader users hit clipping and unlabeled controls. |
| X10 | Performance is unverified. | Sprint 8 profile box still unchecked | Jank risk grows with every animation added here. |
| X11 | No product telemetry. | No funnel events anywhere | Can't tell where users drop off or whether these sprints helped. |

## User journeys

Four personas drive acceptance. Each sprint names the journeys it improves.

| Persona | Journey | Today's pain (finding) | Target moment |
| --- | --- | --- | --- |
| **P1 Guest quick-booker** — first open, no account, tonight's show | Splash → Home → Detail → Seats → Snacks → Checkout → PayWay → Success | No progress sense (X5), back drops hold (X5), seats tedious (X7) | Under 90 s from Home to PayWay, always knows the next step |
| **P2 Regular** — signed in, books weekly | Home → favourite hall → showtime → Best seats → Pay | Tickets buried (X8), inconsistent feel (X2) | Upcoming ticket on Home; booking feels "one gesture" |
| **P3 Group organiser** — 4–6 seats, couple seats | Seats → party size → Best seats → adjust → extend hold | Hard to see whole hall and selection at once (X7) | Mini-map + auto-focus on the chosen block |
| **P4 At the door** — poor signal, in a queue | Open app → ticket → QR scanned | 3 taps, dim screen, no offline cue (X8) | One tap from Home, QR full-bright, works offline |

### Target journey flow (P1, the critical path)

```
 Home ──hero──▶ Detail ──axisX──▶ Seats ──axisX──▶ Snacks ──axisX──▶ Checkout ──sheet──▶ PayWay ──fadeThrough──▶ Success ──shared──▶ Ticket
   │              │  [1 Showtime]   │  [2 Seats]       │ [3 Snacks]       │ [4 Pay]                                 [5 Tickets]
   │              └── Booking capsule (poster · title · date · time · hall) appears and travels with every step ──────────┘
   │                                │◀── back = "Release 3 seats?" confirm while a hold is live
   └── Upcoming-ticket card ◀──────────────────────────────────────────────────────── ticket lands here after success
```

Emotional curve to design for: **anticipation** (Home, Detail) → **control** (Seats) → **reassurance** (Checkout: clear total, timer, progress) → **relief and reward** (Success) → **confidence** (door).

## Sequence

| Sprint | Folder | Demo | Findings | Backend |
| --- | --- | --- | --- | --- |
| 15 | `sprint-15-design-system` | Component gallery screen in en/km, golden tests green, every tappable presses and buzzes consistently, predictive back works on all routes | X1, X2, X3, X4, X6 | — |
| 16 | `sprint-16-booking-flow` | Book as a guest: progress header and booking capsule travel Detail → Success; back on Seats asks before releasing; the ticket flies into the Bookings tab | X5 | — |
| 17 | `sprint-17-seat-experience` | Choose 4 seats: map focuses the block, mini-map shows position, Best seats lights up in sequence; same booking with TalkBack via row list mode | X7 | — |
| 18 | `sprint-18-ticket-wallet` | Home shows "Tonight 19:30 · Hall 3 · in 2h 10m"; one tap flips the ticket to a full-bright QR; works in airplane mode | X8 | Optional G33 |
| 19 | `sprint-19-quality-bar` | 200% text + Khmer + TalkBack walk-through passes; profile run has no frame > 16 ms; funnel report from a test session | X9, X10, X11 | — |

Order matters: 15 builds the parts 16–18 use; 19 is the release gate (but its audit checklist is applied inside every sprint, not saved for the end).

Each sprint is one week, one vertical slice, demoable alone.

## Gap register addition (optional)

| # | Area | Current backend | Target | Sprint |
| --- | --- | --- | --- | --- |
| G33 | Next booking | Home needs the user's next upcoming confirmed booking; today the app must load all of `GET /bookings/my-bookings` and filter | Optional `GET /bookings/next` → one `BookingSummary` or 204. Default path: reuse `my-bookings` + `BookingCache` with no backend change | 18 |

## Definition of done (all sprints)

- Every acceptance box true on a real Android device and an iOS simulator, English and Khmer, reduced motion off **and** on, text scale 1.0 and 2.0.
- `flutter analyze` clean, `flutter test` green, goldens updated only on purpose (diff reviewed).
- New copy keys in `en.json` and `km.json` together (parity test).
- No inline durations, curves, colors, or font sizes in feature views (lint check from sprint 15).
- Status section filled in the sprint's `SPRINT.md` with deviations and measured numbers.

## Decisions to confirm

| # | Decision | Default (no approval needed) | Alternative needing approval |
| --- | --- | --- | --- |
| D1 | Component catalog | In-app debug-only `GalleryPage` route behind `kDebugMode` | `widgetbook` package |
| D2 | Transitions | Keep own `PageRouteBuilder` code, move it into a `PageTransitionsTheme` for predictive back | `animations` package |
| D3 | Rich animation assets (success, empty states) | `CustomPainter` + implicit animations | `rive` or `lottie` |
| D4 | QR screen brightness | Show a "Turn up brightness" hint + white high-contrast card | `screen_brightness` package (or a 20-line platform channel) |
| D5 | Telemetry sink | `JourneyTracker` interface with a debug-log implementation | Firebase Analytics / PostHog / Sentry (privacy review needed) |
| D6 | Home-screen widget / Wallet pass | Out of scope | `home_widget`, Apple Wallet pass from backend |
| D7 | G33 next-booking endpoint | Client-side from `my-bookings` | Backend endpoint |

## Risks

- **Animation creep.** Every new motion must cite a journey row and pass the reduced-motion sweep; anything that can't is cut.
- **Goldens are font-sensitive.** Load bundled Poppins in tests; Khmer falls back to a system font, so Khmer goldens run on one pinned CI platform only.
- **Refactor of seat/checkout views (X3)** touches the riskiest code. It is a no-behavior-change step with existing tests green before any visual change lands.

## Out of scope

Light theme, onboarding carousel, new payment methods, price or seat-state changes, push notifications, social sharing, admin UI.
