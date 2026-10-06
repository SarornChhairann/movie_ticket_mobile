# Sprint 16 — Booking journey flow

## Goal

Detail → Seats → Snacks → Checkout → PayWay → Success reads as **one flow**: the user always knows the step, what they are buying, how long the hold lasts, and that back will not silently lose their seats.

Depends on: sprint 15 (components), sprint 14 (`HoldBanner`, extend). Finding X5. Journeys P1, P2. No backend.

## Acceptance

- [x] **Progress header** `BookingProgress` on Seats, Snacks, Checkout: 4 steps (Seats · Snacks · Pay · Tickets), current step labelled, done steps tappable to go back. Indicator advances with a `Motion.medium` fill; announced to screen readers as "Step 2 of 4, Snacks".
- [x] **Booking capsule** `BookingCapsule` (poster thumb · title · date · time · hall · seat labels once chosen) pinned under the header. It is a shared element: it grows out of the selected showtime chip on Detail and travels Seats → Snacks → Checkout without re-layout; on Success it becomes the ticket card's header. Hero tags are unique per booking flow.
- [x] **Hold timer** lives in the capsule as `CountdownPill` on every step after seats are held (same expiry source as `HoldBanner`); turns `warning` at 60 s, pulses once (not looping); the sprint-14 Extend banner still appears.
- [x] **Sticky summary bar** at the bottom of Seats / Snacks / Checkout: seat count, food count, server total when known (crossfade, never count-up), primary action. The bar morphs its label (Continue → Pay $X) instead of being replaced.
- [x] **Leave guard:** back (button, gesture, predictive back) on Seats/Snacks/Checkout while a hold is live opens `AppDialog`: "Release 3 seats?" — **Keep seats** (default) / **Release**. Release calls the existing release; Keep stays. No dialog when nothing is held.
- [x] **Interrupted flow:** if the app is backgrounded and returns with a live hold, the capsule and timer resume; if the hold expired meanwhile, an `InlineBanner` says so with **Pick seats again**, and selection is cleared (server wins).
- [x] **Success → ticket landing:** on Success, **View tickets** plays a shared-element flight of the ticket card into the Bookings tab icon (badge pops), then switches tab. Reduced motion: instant switch + badge.
- [x] **Skip-ahead:** Snacks step shows **Skip snacks** as a ghost button; the progress header marks Snacks as skipped, not done.
- [x] Error states on every step use `ErrorState` / `InlineBanner` with the server message and one recovery action; no dead ends (each error has a way forward or back).

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

## Status

Done 2026-10-07 in code. Flutter 441 tests green, analyze clean. Not yet run on a device; **Measure** (taps and time Detail → PayWay, before vs after) is open until it is.

- **Steps on routes:** Seats is the seat-map route; Snacks and Pay are two steps of the checkout route (the food grid is `ConcessionsBody`, shown inline), so Seats → Snacks → Checkout is the real order without a second `CheckoutBloc`. A menu → checkout opens on Snacks; no menu → Pay with Snacks marked skipped (struck through, hollow bar). The old `/checkout/concessions` route stays for checkout outside a flow.
- **BookingFlowCubit** is created with the seat map route and handed to checkout through `CheckoutArgs` (route args, single `AppRouter`). It aggregates only; seat and checkout blocs stay the source of truth.
- **Capsule:** `Hero` with `BookingCapsule.heroTag(showtimeId)`; the Detail chip for the chosen showtime is the hero source (`HeroMode` on the selected chip only), every step carries the capsule, and Success shows it as the ticket header (`BookingSummary.showtimeId` added). Timer is a `CountdownPill` fed by the step's own bloc; warning + one pulse at 60 s.
- **Summary bar:** `StickySummaryBar` on all three steps; the action keeps its place and its label crossfades (Continue → Pay $12.50). Amounts are the server's `totalAmount` / `foodTotal` only (tested: food picked but not re-quoted keeps the last server total). Pay keeps "Processing…" next to the spinner.
- **Leave guard — deviation:** the "Release N seats?" dialog is on Seats, the only step where back actually drops the hold (leaving the seat map releases). Back on Snacks returns to Seats and back on Pay returns to Snacks; both keep the hold, so asking there would be a false alarm. Guarding Pay with `PopScope` means Android shows no predictive-back preview on that step.
- **Interrupted flow:** on resume the seat map asks `GET /api/seat-holds/state`; a lost hold clears selection and shows `flow.holdLost` with **Pick seats again**. Checkout relies on its own clock ticker for expiry (it already pops to the seat map); it does not re-ask the server on resume.
- **Ticket landing:** **View tickets** (now for guests too) pops to Home and asks the shell (`ShellTabs`) to open Bookings; the ticket flies from the success card into the tab icon (`Motion.extraLong`, emphasized), the badge pops, then the tab opens; reduced motion → instant switch + badge. The flight itself is not covered by a widget test (it needs real layout of both screens); the reduced-motion path is.
- **Errors:** the seat map failure now has Retry (`RetryRequested`); checkout errors already had one.
- Goldens: `flow_snacks`, `flow_pay` added; seats and checkout screens re-recorded for the new bar.

