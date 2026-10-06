# Sprint 14 — Faster seats

## Goal

Fewer taps from showtime to Pay, and no surprise hold expiry.

Depends on: sprint 12 (seat cap). Analytics §3.3.

## Acceptance

- [x] Opening a seat map first asks **How many seats?** (1 … `maxSeats`), skippable. The chosen count caps selection for this visit.
- [x] **Best seats** picks that many adjacent `AVAILABLE`, not-held normal seats in one row, preferring the middle rows and the row centre; for an even count it may use couple pairs only when every pick is a valid `(odd, odd+1)` pair. It selects them and calls the existing hold. If nothing fits in one row it shows `seats.noBlock` and leaves the map as is. Pure function, unit tested; server hold result wins.
- [x] Seat map and checkout show a banner when 60 seconds remain on the hold, with **Extend**.
- [x] `POST /api/seat-holds/extend` (same body and session as hold) adds `hold_extend_minutes` (setting, default 5) to every hold this session owns on that showtime, once. Second call 409 `HOLD_EXTEND_LIMIT`; no hold 409 `HOLD_EXPIRED`. Response is the same as hold (`expiresAtEpochMs`). Publishes `HELD` with the new expiry.
- [x] After an extend, the countdown on both screens uses the new expiry. **Extend** is hidden once used.
- [x] Pay is disabled with `checkout.holdTooShort` when fewer than 3 minutes remain and extend is used, instead of failing after the tap.

*Verified by backend `HoldExtendIntegrationTest` on H2 (extend adds 5 minutes once and broadcasts `HELD` with the new expiry; second extend `HOLD_EXTEND_LIMIT`; nothing held and an expired hold `HOLD_EXPIRED`; holding again keeps the clock and the extended flag; extend over HTTP answers like hold and 409s the second time) and the updated `SeatHoldServiceTest`; Flutter `best_seats_test` (middle row and centre, taken seats skipped, gaps break a block, couple seats only as odd-even pairs and only when no normal block, odd count never couple, no block), seat-map bloc (party size caps and trims, skip, Best seats holds without proceeding, no block, extend success, `HOLD_EXTEND_LIMIT`, an extend from checkout reaching the map), checkout bloc (Pay guard, extend, `HOLD_EXPIRED`), and widget tests (banner at 60 s with Extend, none before, no Extend once used, party button and Best seats, the first map asking how many seats, checkout banner and Pay off under 3 minutes). Backend 141 tests, Flutter 394 tests green.*

*Changes from the plan: holding again no longer resets the timer — while a session holds seats on a showtime, every new hold keeps the running expiry and extended flag (otherwise "once" meant nothing, because re-holding gave a fresh 10 minutes); releasing everything and holding again still starts a new clock. Best seats holds the block but stays on the map; Continue goes to checkout. Checkout shows its banner under 3 minutes (PayWay's minimum), not 60 seconds, and Pay is off there whether or not Extend was used; the banner offers Extend when it is unused (`checkout.holdExtendToPay`) and says to start over when it is used (`checkout.holdTooShort`). Extra copy keys: `seats.partySkip`, `seats.partyCount`, `seats.holdEnding`, `checkout.holdExtendToPay`. The party size question uses `maxSeats` from the server, or 1–8 when it sends none. Not yet run on a device.*

## Backend

`SeatHold.extended` boolean; `SeatHoldService.extend(showtimeId, sessionId)` under the same row lock as hold; setting `hold_extend_minutes`. Tests: extend once, twice → 409, extend after expiry → `HOLD_EXPIRED`, broadcast payload.

## Flutter

`seats/model/best_seats.dart` (pure), `PartySizeSheet`, `SeatMapBloc` events `PartySizeChosen`, `BestSeatsRequested`, `HoldExtendRequested`; shared `HoldBanner` widget used by seat map and checkout. Copy: `seats.partySize`, `seats.best`, `seats.noBlock`, `seats.extend`, `seats.extendDone`, `checkout.holdTooShort`.

Tests: best-seats table (centre preference, held seats skipped, couple-pair rule, no block), bloc extend success/limit, banner appears at 60 s, Pay disabled rule.

## Out of scope

Accessibility seat type, seat pricing tiers, server-side seat recommendation.

Analysis rows and decisions to confirm: `sprints/booking-enhancement/PLAN.md`.
