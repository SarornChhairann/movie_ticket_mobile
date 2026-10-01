# Sprint 5 — Confirm and pay

## Goal

Confirm turns a hold into a `CONFIRMED` booking only after payment is `PAID`, then issues one `ACTIVE` ticket per seat and marks those seats `BOOKED`. A failed payment leaves no tickets, no booked seats, no promo use, and no points.

Depends on: sprint 4. Analytics sections 3.5, 6.3, invariants 1, 2, 4, 5, 8. Gap rows G15, G16, G17.

## Acceptance

- [x] Confirm sends showtime, seat ids, promo, food, payment method, and guest fields, with `X-Session-Id`. It does not send a client total.
- [x] Server recomputes the quote inside the transaction, under the seat row lock.
- [x] Success returns the booking detail: id, status `CONFIRMED`, showtime, amounts, tickets with codes and seat codes.
- [x] Seats are `BOOKED`. Holds for that session are gone. Other clients receive `BOOKED` on the seat topic.
- [x] A second confirm on the same seats fails with `SEAT_BOOKED` (409) and creates no second booking.
- [x] Payment failure returns `PAYMENT_FAILED`, leaves the booking `CANCELLED`, seats `AVAILABLE`, no tickets, promo `usedCount` unchanged, points unchanged. The session's hold is kept so the user can retry before it expires.
- [x] Registered user points increase by the integer part of `totalAmount` only after `PAID`. Guests earn nothing.
- [x] A blocked user attached by bearer cannot confirm (`ACCOUNT_BLOCKED`).
- [x] The mock provider lives behind a `PaymentGateway` interface and returns `PAID` in dev.
- [x] Double-tapping Pay submits once.

*Verified by backend `BookingServiceTest` (paid, payment failure, conflict, hold expired, guest, missing phone, blocked user) and `ConfirmCheckoutIntegrationTest` on H2 (sequential double confirm → `SEAT_BOOKED`; two concurrent confirms → exactly one booking; stable across repeated runs), plus Flutter checkout bloc/repository/widget tests and the auth refresh test. A live payment walk-through on a device is still pending. "View tickets" on the success screen is a stub until sprint 6.*

## API contract

| Call | Request | Response / errors |
| --- | --- | --- |
| `POST /bookings/checkout/{showtimeId}` | Header `X-Session-Id`, optional bearer. `{ seatIds, guestName?, guestPhone?, guestEmail?, promoCode?, paymentMethod, foodItems?: { id: qty } }` | 200 `BookingDetailResponse` `{ id, showtime, customerName, customerEmail, customerPhone, totalAmount, serviceFee, taxAmount, discountAmount, promoCode, paymentMethod, status, bookedAt, tickets: [{ id, ticketCode, status, seatCode, seatType }], firstTicketCode }`. Errors: 409 `HOLD_EXPIRED`, `SEAT_HELD`, `SEAT_BOOKED`; 400 `COUPLE_PAIR_INVALID`, `PROMO_INVALID`, guest fields missing; 402 `PAYMENT_FAILED`; 403 `ACCOUNT_BLOCKED`. |
| `GET /bookings/confirmation/{bookingId}` | — | Same `BookingDetailResponse` (used to re-open the success screen). |

Guest fields are required when no bearer is present: `guestName`, `guestPhone` non-blank (400 otherwise).

## Step 1 — UX/UI

1. Pay button shows progress and ignores taps while submitting.
2. Payment method: a single "Card (demo)" option this sprint; value sent as `CARD`.
3. Success screen: movie, hall, date/time, seats, total, ticket codes. Actions: view tickets (route stub until sprint 6), back to home. Back navigation from success goes home, not to checkout.
4. Failure screen/sheet: server message; if the hold is still alive, **Try again** re-quotes and stays on checkout; if expired, **Pick seats** returns to the map.
5. Keys under `pay.*`: `pay.processing`, `pay.success`, `pay.failed`, `pay.tryAgain`, `pay.pickSeats`, `pay.viewTickets`, `pay.backHome`, `pay.ticketCode`, `pay.method.card`.

## Step 2 — Backend

Align `BookingService.confirmCheckout` with analytics 6.3 (G15):

1. Introduce `PaymentGateway` (`PaymentResult charge(Booking booking, String method)`, result `PAID | FAILED` with a reason). `MockPaymentGateway` (`@Component`, default) returns `PAID`. `PaymentService` records the `Payment` row and **no longer sets the booking status** — the booking service owns status.
2. In `confirmCheckout`:
   1. Lock seats (`findAllByShowtimeIdAndIdsForUpdate`), recheck available, couple pairs, and hold ownership (move the hold checks from the controller into the transaction, after the lock).
   2. Reject an attached user whose status is not `ACTIVE` with `ACCOUNT_BLOCKED` (G17). Require guest name/phone when no user.
   3. Recompute price (same `resolveCheckoutData`, `lockSeats = true`, with food).
   4. Insert booking `PENDING` and food lines.
   5. Charge.
   6. On `PAID`: set `CONFIRMED`, issue tickets (sets seats `BOOKED`), `promoCodeService.recordUsage`, add points, release this session's holds, then register the email and the `BOOKED` publish with `TransactionSynchronization.afterCommit` so neither fires for a rolled-back booking.
   7. On `FAILED`: set booking `CANCELLED`, save the failed `Payment`, issue no tickets, then throw `ApiException(PAYMENT_REQUIRED, "PAYMENT_FAILED", reason)` **after** persisting — use `noRollbackFor` on that exception or persist the cancelled booking in a `REQUIRES_NEW` step, so the audit row survives while seats stay `AVAILABLE`.
3. Controller: return `toBookingDetail(booking, tickets)` instead of `{ bookingId }` (G16). Remove the duplicate hold checks and the `publishBooked` call that now runs after commit.
4. Tests (`BookingServiceTest`, with a test-double `PaymentGateway`, not a public flag):
   - success: one `ACTIVE` ticket per seat, seats `BOOKED`, promo `usedCount` +1, points += `intValue()` of total, holds deleted;
   - conflict: seat already `BOOKED` → `SEAT_BOOKED`, no booking saved;
   - payment failure: booking `CANCELLED`, no tickets, seats `AVAILABLE`, `recordUsage` never called, points unchanged;
   - guest booking: no points, guest fields stored;
   - blocked user → `ACCOUNT_BLOCKED`.

## Step 3 — Frontend

1. DTOs: `ConfirmRequestDto`, `BookingDetailDto`, `TicketSummaryDto`. Entity: freezed `Confirmation(bookingId, movieTitle, hallName, showDate, showTime, seats, total, tickets)`.
2. `CheckoutRepository.confirm(...)` and `getConfirmation(id)`.
3. `CheckoutBloc` event `ConfirmRequested` (use `droppable()` from `bloc_concurrency` **only if** it is already a dependency; otherwise guard with the `submitting` state — do not add a package for this).
4. States added: `submitting`, `success(Confirmation)` (navigation flag), `paymentFailed(message, holdAlive)`.
5. On success: clear the local hold, stop the countdown, replace the route stack with Success. On failure: keep the hold, re-quote.
6. If the user is signed in, the app-level `AuthBloc` refreshes the profile after success (points shown in sprint 7).

## Step 4 — Testing

1. Backend service tests from step 2.
2. Backend concurrency test: two threads confirm the same seats with different session ids against H2 (`@SpringBootTest`), exactly one booking and one set of tickets exist afterwards; the loser gets `SEAT_HELD` or `SEAT_BOOKED`. If H2 locking makes this flaky, keep the sequential version (second confirm after the first commits) as the required test and the threaded one as `@Disabled` with a reason.
3. Bloc test: two `ConfirmRequested` in a row submit once; payment failure keeps the hold and re-quotes.
4. Widget test: Pay shows progress and is disabled while submitting.

## Definition of done

The failure test proves seats stay `AVAILABLE` and promo/points are untouched. The success test proves one ticket per seat and status `BOOKED`. The mobile success screen shows real ticket codes from a confirm against a running API.

## Out of scope

QR image UI, cancel, PDF layout changes, real payment gateway, refunds.
