# Sprint 6 — Tickets and cancel

## Goal

A signed-in customer sees their bookings, opens a ticket QR, and cancels when the show is outside the cancellation window.

Depends on: sprint 5. Analytics section 3.6, invariant 7. Gap rows G18, G19, G20, G23.

## Acceptance

- [ ] My bookings lists the signed-in user's bookings, newest first, with status chip, movie, date/time, hall, seat codes, total.
- [ ] Booking detail lists tickets; each ticket opens a QR screen with code and the PNG from `/tickets/{ticketCode}/qr`.
- [ ] Cancel is offered only for `CONFIRMED` bookings whose show start is outside the window. The server is still the authority.
- [ ] Cancel inside the window shows the server message (`CANCEL_WINDOW`) and does not change seats.
- [ ] Successful cancel sets booking `CANCELLED`, tickets `CANCELLED`, seats `AVAILABLE`, and open seat maps receive `RELEASED`.
- [ ] Guests have no My bookings entry (analytics 3.6: guest lookup is out of the current API). The success screen from sprint 5 is the guest's ticket view.
- [ ] This sprint does not reverse points or promo usage.

## API contract

| Call | Request | Response / errors |
| --- | --- | --- |
| `GET /bookings/my-bookings` | Bearer | `BookingDetailResponse[]`, newest first (G18) |
| `GET /bookings/confirmation/{id}` | — | `BookingDetailResponse` |
| `POST /bookings/cancel/{id}` | Bearer | `{ success, message }`. 403 `NOT_OWNER`, 409 `ALREADY_CANCELLED`, 409 `CANCEL_WINDOW`, 400 not found |
| `GET /tickets/{ticketCode}` | — | `TicketResponse` |
| `GET /tickets/{ticketCode}/qr` | — | `image/png` bytes |

The cancel window length is not in any customer response. The client may hide the button for shows already started, but must not hard-code the 2 hours — it shows the button for every `CONFIRMED` future booking and lets the server answer `CANCEL_WINDOW`. (If a pre-check is wanted later, add `cancellableUntil` to `BookingDetailResponse` on the server.)

## Step 1 — UX/UI

1. Screens: My bookings (pull to refresh), Booking detail, Ticket QR (large code, QR image, brightness hint).
2. Status chips: pending, confirmed, cancelled.
3. Cancel asks for confirmation, shows progress, then success or the server message.
4. Keys under `tickets.*`: `tickets.title`, `tickets.empty`, `tickets.status.pending|confirmed|cancelled`, `tickets.cancel`, `tickets.cancelConfirm`, `tickets.cancelled`, `tickets.qr`, `tickets.code`.

## Step 2 — Backend

1. `GET /bookings/my-bookings`: use `bookingRepository.findByUserOrderByBookedAtDesc` (G18). Keep the lazy fields initialized inside the read-only transaction.
2. `POST /bookings/cancel/{id}` error codes (G19): not owner or guest booking → `ApiException(FORBIDDEN, "NOT_OWNER")`; already cancelled → `ApiException(CONFLICT, "ALREADY_CANCELLED")`; inside window → `ApiException(CONFLICT, "CANCEL_WINDOW")`. Keep the messages.
3. After a successful cancel, publish `RELEASED` for the freed showtime seat ids through `SeatRealtimeService` after commit (G20).
4. `GET /tickets/{ticketCode}/qr` returns PNG and stays public (G23 — the ticket code is the bearer secret; record this in the controller Javadoc and revisit after v1).
5. Tests: owner cancel frees seats and publishes release; stranger gets `NOT_OWNER`; inside-window cancel gets `CANCEL_WINDOW` and seats stay `BOOKED`; guest booking cannot be cancelled by any user; my-bookings is ordered newest first.

## Step 3 — Frontend

Feature `tickets`:

1. DTOs reuse `BookingDetailDto`/`TicketSummaryDto` from sprint 5 (move them to a shared `features/tickets/model` or `core/model` if both features need them — one definition only).
2. Entities: freezed `BookingSummary`, `TicketPass(code, seatCode, status)`.
3. `TicketsRepository` (lazy singleton): `myBookings`, `booking(id)`, `cancel(id)`, `qrBytes(code)` via Dio with `ResponseType.bytes`.
4. `MyBookingsBloc` (`LoadRequested`, `RefreshRequested`, `CancelRequested(id)`), `TicketBloc` (`QrRequested(code)`).
5. QR is `Image.memory(bytes)` from the Dio call — no third-party URL built in the widget.
6. Profile entry and the sprint 5 success screen's **View tickets** navigate here (signed-in only).

## Step 4 — Testing

1. Bloc tests: list newest first preserved; cancel success flips the chip to cancelled; `CANCEL_WINDOW` keeps it confirmed and sets the error.
2. Repository test: QR call requests bytes; cancel error codes map to failures.
3. Widget test: cancelled booking hides the cancel button.
4. Backend tests from step 2.

## Definition of done

Cancel outside the window frees the seat so sprint 3's map shows it available live. Cancel inside the window does not.

## Out of scope

Admin check-in UI, PDF redesign, loyalty history, guest booking lookup, points/promo reversal.
