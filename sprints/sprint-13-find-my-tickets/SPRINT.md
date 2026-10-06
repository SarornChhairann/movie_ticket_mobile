# Sprint 13 — Find my tickets

## Goal

A customer can always get back to tickets they paid for: after an app kill, as a guest, and with no signal.

Depends on: sprint 12 (owner rule). Analytics §3.6.

## Acceptance

- [x] Every booking has a `reference` (8 chars, Crockford-style alphabet). It shows on the success screen, booking detail, the QR page, and the confirmation email.
- [x] Before the PayWay web view opens, the app writes `{tranId, bookingId, reference, sessionId, startedAt}` to secure storage. It is removed on `APPROVED`, `DECLINED`, `CANCELLED`, or close.
- [x] On app start, if that record exists and is under 30 minutes old, the app reuses its `sessionId` for this run (amends contract 1) and opens a "Checking your payment" screen that polls once: `APPROVED` → success screen; `PENDING` → keep polling up to the hold expiry; else → failure notice and the record is cleared.
- [x] `POST /bookings/lookup { reference, phone }` returns the booking when both match (phone compared on digits only). Any miss is 404 `BOOKING_NOT_FOUND`. 5 tries per IP per 10 minutes, then 429.
- [x] Guests see **Find my booking** on the Bookings tab (instead of only the sign-in prompt). Found bookings are saved on the device and listed there.
- [x] Every `CONFIRMED` booking the app has opened is cached: detail JSON plus each ticket's QR PNG. Booking detail and the QR page render from cache when offline, with an "Offline copy" note. Cache is refreshed on the next online open; a `CANCELLED` result removes the QR files.
- [x] Sign-out clears the cached bookings of that user; guest-saved bookings stay until removed by swipe.

*Verified by backend `BookingReferenceTest` (alphabet, length, 2 000 unique, normalizing, Cambodian phone forms), `LookupRateLimiterTest` (five misses block, ages out at 10 minutes), `BookingLookupIntegrationTest` over HTTP on H2 (reference on insert, backfill, hit with any formatting, wrong phone and wrong reference are the same 404, five misses → 429 even for the right answer, hits never count), and a PayWay test polling a user's payment by session alone; Flutter `pending_payment_store_test` (round trip, 30-minute cut-off, unreadable record cleared, restored id sent as `X-Session-Id`), `booking_cache_test`, `payment_resume_bloc_test` (APPROVED saves guest/account copy and clears, PENDING keeps polling, PENDING after the hold closes and fails, DECLINED clears, no connection keeps the record), PayWay bloc record write/clear, repository device-copy tests (offline list and QR, 5xx never falls back, lookup body and save, `TOO_MANY_ATTEMPTS`, guest refresh and offline), guest bloc, lookup bloc and page, detail offline/reference, success reference, shell guest Bookings tab, and auth sign-out clearing. Backend 137 tests, Flutter 374 tests green.*

*Changes from the plan: the limiter counts only lookups that found nothing (5 per client per 10 minutes), so a phone refreshing its own saved bookings is never locked out. Phones compare without the `855` code or trunk `0`, so `012 345 678` and `+855 12 345 678` match. Poll and close accept the signed-in owner or the starting session, not reference + phone: the app restores the session, and the PayWay callback settles the payment on the server anyway. Bookings a guest pays for on this phone are saved to the guest list too, not only found ones. A stale record (30 minutes or more) is dropped without a check. `path_provider` became a direct dependency (it was already in the build). Not yet run on a device: killing the app during a real ABA hand-off, airplane mode, and the email text.*

## Backend

`Booking.reference` + unique index + backfill for existing rows. `BookingController.lookup`. Poll/close ownership accepts bearer owner or `reference` + phone (G31). Simple in-memory rate limiter keyed by IP (no new dependency). Email template shows the reference.

Tests: reference uniqueness and alphabet, lookup hit/miss/phone formatting, rate limit, poll by bearer after session change.

## Flutter

- `core/session`: `SessionIdProvider` takes an optional restored id; `PendingPaymentStore` (secure storage).
- `features/checkout`: `PaymentResumePage` + `PaymentResumeBloc`, routed from splash.
- `features/tickets`: `TicketCache` (index in secure storage, PNGs in the app documents dir), `BookingLookupPage` + bloc, guest list on the Bookings tab.
- Repository reads: network first, cache on `DioException` of type connection/timeout only — never on 4xx.

Tests: resume with APPROVED/PENDING/DECLINED/stale record; lookup bloc; cache hit offline, cache cleared on CANCELLED and on sign-out; contract test that the restored session id is sent as `X-Session-Id`.

## Out of scope

Push notifications, Apple/Google Wallet passes, PDF download in the app, account linking of guest bookings.

Analysis rows and decisions to confirm: `sprints/booking-enhancement/PLAN.md`.
