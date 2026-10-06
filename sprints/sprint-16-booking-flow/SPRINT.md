# Sprint 16 — Booking journey flow

## Goal

Detail → Seats → Snacks → Checkout → PayWay → Success reads as **one flow**: the user always knows the step, what they are buying, how long the hold lasts, and that back will not silently lose their seats.

Depends on: sprint 15 (components), sprint 14 (`HoldBanner`, extend). Finding X5. Journeys P1, P2. No backend.

## Acceptance

- [ ] **Progress header** `BookingProgress` on Seats, Snacks, Checkout: 4 steps (Seats · Snacks · Pay · Tickets), current step labelled, done steps tappable to go back. Indicator advances with a `Motion.medium` fill; announced to screen readers as "Step 2 of 4, Snacks".
- [ ] **Booking capsule** `BookingCapsule` (poster thumb · title · date · time · hall · seat labels once chosen) pinned under the header. It is a shared element: it grows out of the selected showtime chip on Detail and travels Seats → Snacks → Checkout without re-layout; on Success it becomes the ticket card's header. Hero tags are unique per booking flow.
- [ ] **Hold timer** lives in the capsule as `CountdownPill` on every step after seats are held (same expiry source as `HoldBanner`); turns `warning` at 60 s, pulses once (not looping); the sprint-14 Extend banner still appears.
- [ ] **Sticky summary bar** at the bottom of Seats / Snacks / Checkout: seat count, food count, server total when known (crossfade, never count-up), primary action. The bar morphs its label (Continue → Pay $X) instead of being replaced.
- [ ] **Leave guard:** back (button, gesture, predictive back) on Seats/Snacks/Checkout while a hold is live opens `AppDialog`: "Release 3 seats?" — **Keep seats** (default) / **Release**. Release calls the existing release; Keep stays. No dialog when nothing is held.
- [ ] **Interrupted flow:** if the app is backgrounded and returns with a live hold, the capsule and timer resume; if the hold expired meanwhile, an `InlineBanner` says so with **Pick seats again**, and selection is cleared (server wins).
- [ ] **Success → ticket landing:** on Success, **View tickets** plays a shared-element flight of the ticket card into the Bookings tab icon (badge pops), then switches tab. Reduced motion: instant switch + badge.
- [ ] **Skip-ahead:** Snacks step shows **Skip snacks** as a ghost button; the progress header marks Snacks as skipped, not done.
- [ ] Error states on every step use `ErrorState` / `InlineBanner` with the server message and one recovery action; no dead ends (each error has a way forward or back).

## UX — journey table additions

| Step | From → To | Transition | Persistent elements |
| --- | --- | --- | --- |
| Choose showtime | Detail → Seats | Shared axis X; showtime chip → capsule hero | Progress, capsule |
| Seats held | Seats → Snacks | Shared axis X; header fill advances | Progress, capsule, timer, summary bar |
| Snacks | Snacks → Checkout | Shared axis X | same |
| Pay | Checkout → PayWay | Sheet (exists) | — (PayWay is full screen) |
| Paid | PayWay → Success | Fade-through + ticket issued (exists) | Capsule becomes ticket header |
| Done | Success → Bookings | Ticket flies to tab icon | Badge |

Copy: `flow.step.seats`, `flow.step.snacks`, `flow.step.pay`, `flow.step.tickets`, `flow.stepOf` (`Step {n} of {total}, {name}`), `flow.skipSnacks`, `flow.leave.title` (`Release {count} seats?`, plural), `flow.leave.body`, `flow.leave.keep`, `flow.leave.release`, `flow.holdLost`, `flow.pickAgain`, `flow.viewTickets`.

## Flutter

- `features/checkout/controller/booking_flow_cubit.dart` — read-only aggregation of what the steps already know (showtime, held seats, food, expiry, current step). It owns no rules; seat and checkout blocs stay the source of truth. Provided above the flow routes (nested `Navigator` or a scoped `BlocProvider` passed via route args — decide in contract check; prefer route args to keep `AppRouter` single).
- `core/widgets/booking_progress.dart`, `booking_capsule.dart`, `sticky_summary_bar.dart`, `leave_guard.dart` (`PopScope` + dialog).
- `AppLifecycleListener` in the flow to re-check hold state on resume (existing `GET /api/seat-holds/state`).

## Tests

Cubit tests (step changes, skip snacks, hold expiry → `holdLost`); widget tests: leave guard shows only with a live hold, Keep vs Release paths, progress semantics label, summary bar never shows an amount the server didn't return (money truthfulness test from sprint 8 extended), capsule hero tags unique; reduced-motion sweep includes all new widgets; goldens for each step.

## Measure

Record in Status: taps and time from Detail to PayWay for P1 on a device before vs after (3 runs each).

## Out of scope

Changing step order, merging Snacks into Checkout, saved payment methods.
