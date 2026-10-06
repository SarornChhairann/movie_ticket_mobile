# Booking enhancement — sprints 12–14

Sprints 0–11 deliver the full booking path: hold → quote → PayWay → tickets → cancel. This plan hardens it. It does not add a new channel, a new payment method, or new price math.

Read first: `system_analytics/SYSTEM_ANALYTICS.md` §3.3–3.6 and §8, `sprints/README.md` (contracts 1–4), and the gap rows below. Same method as every sprint: contract check → UX → backend → Flutter → tests → demo.

## Analysis — what is wrong today

Verified against source on 2026-10-06.

| # | Finding | Evidence | Impact |
| --- | --- | --- | --- |
| A1 | Any caller can read any booking. `/bookings/confirmation/{id}` is `permitAll`, ids are sequential `Long`, and the response carries guest name, email, phone, and every `ticketCode`. A ticket code is the bearer secret for `/tickets/{code}/qr` (G23). | `SecurityConfig` line 74; `BookingController.confirmation` has no owner check | **Security.** Enumerating 1…N leaks every customer's PII and lets anyone render a valid QR and walk in on another person's seat. |
| A2 | No seat cap. One session can hold every seat in a hall for `hold_minutes` (10) and renew. | `SeatHoldService.holdSeatsRealtime` checks only availability and conflicts | Inventory denial; a bot or a careless tap blocks a full show. |
| A3 | Cancel keeps the points. `confirm` adds `points += total`; `cancelBooking` frees seats but never subtracts them, and never returns the promo use. | `BookingService` lines 203–207 vs 421–452 | Book → earn → cancel → repeat inflates points for free. A capped promo is burned by a cancelled booking. |
| A4 | Cancel of a PayWay-paid booking has no money trail. The booking goes `CANCELLED`; the `PAID` payment row is untouched; nobody is told to refund. | `cancelTicketsAndFreeSeats`; no refund state anywhere | Customer paid, cancelled, and has no record a refund is owed. Admin cannot find them. |
| A5 | A payment is lost if the OS kills the app during the ABA hand-off. `tranId` lives only in `PaywayBloc`; the `X-Session-Id` rotates on restart, so the new run cannot poll or close it. The callback still confirms on the server. | `SessionIdProvider` (new UUID per run); no persisted `tranId` | Paid guest with no tickets on screen. Signed-in users find it in My bookings; guests cannot. |
| A6 | Guests have no way back to their tickets after leaving the success screen. Analytics §3.6: "Guest lookup is out of the current API". | No lookup endpoint; Bookings tab requires sign-in | Support load at the door. |
| A7 | Tickets need the network. QR is fetched on every open. | `TicketQrPage` loads `/tickets/{code}/qr` bytes | Cinema basements have weak signal; the queue stalls at check-in. |
| A8 | Hold expires with no warning and cannot be extended. A PayWay start needs ≥ 3 minutes left (`PAYWAY_MIN_LIFETIME_MINUTES`), so a slow checkout fails at Pay with `HOLD_EXPIRED`. | `BookingService.openPaywayBooking` | Lost sales at the last step. |
| A9 | Seat picking is manual only. No party-size step, no "best available". | `seat_map_page.dart` | Slow for groups; couple-pair errors from mis-taps. |

## Approach

1. **Fix trust before features.** A1 is a live data leak and A3 is a money leak. They ship first, alone, so the review is small.
2. **Server decides, client follows.** Every new rule (seat cap, extend limit, refund state, lookup) is a backend rule with a stable `code`. The app only shows it. Same as contracts 2 and 4.
3. **Additive API.** New endpoints beside old ones; `BookingDetailResponse` only gains fields. Older clients keep working except where A1 must close a door.
4. **No new packages.** Offline tickets use the file system via `path_provider` only if it is already a transitive dependency; otherwise `flutter_secure_storage` for the small index plus the app documents directory. Confirm in sprint 13 before writing code.
5. **Analytics first.** Each sprint that changes a rule edits `SYSTEM_ANALYTICS.md` in the same change (§3.3, §3.6, §8), because the README rule is "copy rules from the analytics".

## Gap register additions

Merged into the gap register in `sprints/README.md`; repeated here for review.

| # | Area | Current backend | Target | Sprint |
| --- | --- | --- | --- | --- |
| G25 | Booking read | `/bookings/confirmation/{id}` public, no owner check | Owner only: bearer user, or `X-Session-Id` that started it (reference + phone is added in sprint 13). Else 404 `BOOKING_NOT_FOUND` (not 403, so ids are not probeable) | 12 |
| G26 | Seat cap | None | `max_seats_per_booking` setting (default 8). Hold, quote, confirm, PayWay start reject above it with 400 `SEAT_LIMIT` | 12 |
| G27 | Cancel reversal | Points and promo use kept | Cancel subtracts the points that booking earned (floor 0) and decrements `usedCount` (floor 0). Admin cancel does the same | 12 |
| G28 | Refund trail | `PAID` payment untouched on cancel | Payment `REFUND_PENDING` on cancel of a paid booking; admin marks `REFUNDED`. No provider refund call in v1 | 12 |
| G29 | Booking reference | Only numeric id | `bookings.reference`: 8-char, no `0/O/1/I`, unique, shown on success, ticket, email | 13 |
| G30 | Guest lookup | None | `POST /bookings/lookup { reference, phone }` → `BookingDetailResponse`; rate-limited; 404 `BOOKING_NOT_FOUND` on any miss | 13 |
| G31 | Payment resume | Poll/close need the starting session | Poll and close also accept the bearer owner, or `reference` + phone. Session stays the default | 13 |
| G32 | Hold extend | None | `POST /api/seat-holds/extend` once per hold, adds `hold_extend_minutes` (default 5). Second call 409 `HOLD_EXTEND_LIMIT` | 14 |

New error codes for contract 2: `BOOKING_NOT_FOUND` 404 (12), `SEAT_LIMIT` 400 (12), `HOLD_EXTEND_LIMIT` 409 (14).

## Sequence

| Sprint | Folder | Demo | Gap rows |
| --- | --- | --- | --- |
| 12 | `sprint-12-booking-safety` | Another phone cannot open my booking; 9th seat is refused; cancel removes points and shows "refund pending" | G25–G28 |
| 13 | `sprint-13-find-my-tickets` | Kill the app mid-payment, reopen, tickets appear; guest finds tickets by reference + phone; tickets open in airplane mode | G29–G31 |
| 14 | `sprint-14-faster-seats` | Pick party size, tap "Best seats", extend the hold once at the 1-minute warning, pay | G32 |

Each sprint lives in its own folder: `sprint-12-booking-safety/SPRINT.md`, `sprint-13-find-my-tickets/SPRINT.md`, `sprint-14-faster-seats/SPRINT.md`.

---

## Risks and decisions to confirm

| Item | Default in this plan | Who decides |
| --- | --- | --- |
| Seat cap value | 8 per booking | Product |
| Refund handling | Manual by admin (`REFUND_PENDING` → `REFUNDED`); no PayWay refund API call | Product + finance |
| Points reversal on a booking whose points were already spent | Floor at 0, no negative balance | Product |
| A1 breaks any external client reading confirmations by id | Accept; the mobile app is the only customer client | Tech lead |
| Extend count | Once per hold | Product |
| Offline QR storage | QR PNG on device; it is the same secret printed on a paper ticket | Tech lead (consistent with G23) |

## Definition of done (each sprint)

Every acceptance box true on an emulator against a running API; `./mvnw test`, `flutter analyze`, `flutter test` green; new codes in the README code table; analytics updated in the same change; `en.json`/`km.json` keys match.
