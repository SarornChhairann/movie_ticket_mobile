# Sprint 12 — Booking safety

## Goal

Only the owner can read a booking. Nobody can hold a whole hall. Cancelling gives back what the booking took and leaves a refund trail.

Depends on: sprints 5, 6, 9. Analytics §3.3, §3.6, §8.

## Acceptance

- [x] `GET /bookings/confirmation/{id}` returns the booking only to: the bearer user who owns it, or a request whose `X-Session-Id` equals the session that created it (PayWay payment row or a new `bookings.session_id`). Anyone else gets 404 `BOOKING_NOT_FOUND`.
- [x] The app's success screen and booking detail still load (they send the same session or bearer).
- [x] `max_seats_per_booking` exists in `system_settings`, default 8, admin-editable, validated ≥ 1.
- [x] Holding, quoting, confirming, or starting PayWay with more seats than the cap returns 400 `SEAT_LIMIT`. A couple pair counts as 2 seats.
- [x] Seat map disables further taps at the cap and shows `seats.limit` with the number from the seat-map response (`maxSeats`, new field). The server result still wins.
- [x] Customer cancel and admin cancel subtract `floor(totalAmount)` points from the booking's user (never below 0) and decrement the promo's `usedCount` (never below 0). Guest bookings: no points step.
- [x] Cancelling a booking whose payment is `PAID` sets the payment `REFUND_PENDING`. Booking detail shows a "Refund pending" chip. Admin booking list can filter by it and set `REFUNDED`.
- [x] Analytics §3.6 "Do not reverse points or promo usage" is replaced with the new rule; §8 gains invariants 9 (owner-only booking read) and 10 (seat cap).

*Verified by backend `BookingAccessTest` (owner from any session, creating session for guest and user bookings, stranger, guest booking with no stored session, 404 code) and `BookingSafetyIntegrationTest` on H2 (cap on hold, cumulative holds, couple pair counts two, quote/confirm/PayWay start reject before writing, seat map sends `maxSeats`; confirm stores the session and the same session reads it over HTTP with `paymentStatus`; other session, no session, and a missing id are the same 404 `BOOKING_NOT_FOUND`; owner reads by email; cancel reverses points and promo use and sets `REFUND_PENDING`; floors at 0; a `PENDING` booking gives nothing back; admin refund once), plus updated `BookingServiceTest`/`SeatHoldServiceTest`, and Flutter seat-map bloc (cap on tap, couple pair counts two, no cap when the server sends none, `SEAT_LIMIT` from hold), repository (`maxSeats`, refund state, `SEAT_LIMIT`, `BOOKING_NOT_FOUND`), and widget (refund chips, localized not-found) tests. Backend 126 tests, Flutter 339 tests green. Notes: the not-found copy key is `tickets.notFound` (the app has no `errors` group); `tickets.cancelConfirm` no longer says points are kept. A cancelled paid booking's chip shows the refund state in place of "Cancelled". The admin list filter is `GET /admin/bookings?paymentStatus=REFUND_PENDING`; the admin-portal button is still a follow-up. Two migrations run on Postgres: `bookings.session_id` (backfilled from PayWay payments) and dropping Hibernate's `payments_status_check`, which would otherwise reject the new statuses. Not yet run against a live Postgres or on a device.*

## Backend

1. `bookings.session_id` (nullable, set on confirm and PayWay start). Migration in `SchemaMigrationRunner`.
2. `BookingAccess.assertCanRead(booking, authentication, sessionId)` used by `confirmation`. Throw `ApiException(NOT_FOUND, BOOKING_NOT_FOUND)`.
3. `SystemSettingService.MAX_SEATS_PER_BOOKING`; one check in `resolveCheckoutData` and one in `holdSeatsRealtime`.
4. `PaymentStatus` gains `REFUND_PENDING`, `REFUNDED`. `cancelTicketsAndFreeSeats` → `reverseSideEffects(booking)` (points, promo, payment) in the same transaction.
5. `/admin/bookings/{id}/refund` sets `REFUNDED` (admin portal button is a follow-up for the admin sprints).

Tests: `BookingAccessTest` (owner, session, stranger, guest), seat cap on all four entry points, cancel reverses points to a floor of 0, promo `usedCount` floors at 0, paid → `REFUND_PENDING`, unpaid mock booking unchanged.

## Flutter

- `SeatMap` entity gains `maxSeats`; `SeatMapBloc` refuses `SeatToggled` past it (view guard only).
- `CheckoutFailure` / `TicketsFailure` map `SEAT_LIMIT` and `BOOKING_NOT_FOUND`.
- `BookingStatusChip` adds `refundPending` / `refunded` from the payment status (new optional field `paymentStatus` on `BookingDetailDto`).
- Copy: `seats.limit`, `tickets.refundPending`, `tickets.refunded`, `errors.bookingNotFound` in `en.json` + `km.json`.

## Out of scope

Calling a PayWay refund API. Partial cancel (some seats). Changing the cancellation window.

Analysis rows and decisions to confirm: `sprints/booking-enhancement/PLAN.md`.
