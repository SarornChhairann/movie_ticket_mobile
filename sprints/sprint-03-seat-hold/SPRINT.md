# Sprint 3 — Seat map and hold

## Goal

The user sees the hall for one showtime, selects seats, and holds them under their `X-Session-Id` until the hold expires or they leave. Other clients see holds and releases live.

Depends on: sprint 2. Analytics sections 3.3, 3.4 (couple rule), 4, invariants 3, 4, 8. README contracts 1, 2, 3, 4. Gap rows G8, G9, G10.

## Acceptance

- [x] Map colors: available, selected (mine, not yet held), held by me, held by others, booked, couple.
- [x] Booked seats and held-by-others seats are not tappable.
- [x] Couple seats toggle as a pair: tapping one couple seat selects its `(odd, odd+1)` partner in the same row. An invalid set shows the pair error and does not call hold.
- [x] **Continue** calls `POST /api/seat-holds/hold` with showtime seat ids; the header carries `X-Session-Id`.
- [x] Changing the selection after a hold releases the removed seats and holds the added ones.
- [x] Leaving the screen without continuing calls release.
- [x] Server pushes (`HELD`, `RELEASED`, `BOOKED`) update the map without a full reload; own-session events are ignored.
- [x] If the socket is down, the map polls `GET /api/seat-holds/state` every 5 s while visible.
- [x] Countdown from `expiresAtEpochMs`; at zero the selection clears and the map reloads.
- [x] A hold never sets `showtime_seats.status` to `BOOKED`.
- [x] No controller in the hold/seat flow reads `HttpSession` any more.

*Verified by backend `SeatHoldServiceTest`/`BookingServiceTest`/`HoldSessionsTest` and Flutter couple-pairing/bloc/repository/widget tests. Not yet verified live: the STOMP connection to `/ws/websocket` and the two-emulator check (Step 4.6). Deviation: a missing `X-Session-Id` falls back to the servlet session instead of returning 400 (see README contract 1).*

## API contract

All calls send header `X-Session-Id: <uuid>`.

| Call | Request | Response / errors |
| --- | --- | --- |
| `GET /bookings/seats/{showtimeId}` | — | `{ showtimeId, showtime: ShowtimeInfo, seats: [{ id, seatCode, seatType, rowNumber, status }], heldByOthers: [id], heldByMe: [id], holdMinutes, isWeekend, isMorning }` (`sessionId` echo is removed or ignored) |
| `POST /api/seat-holds/hold` | `{ showtimeId, seatIds }` | `{ showtimeId, expiresAtEpochMs, holdMinutes }`. 409 `SEAT_HELD` / `SEAT_BOOKED`. 400 `COUPLE_PAIR_INVALID`, `SESSION_REQUIRED`. |
| `POST /api/seat-holds/release` | `{ showtimeId, seatIds }` | `{ ok: true }` |
| `GET /api/seat-holds/state?showtimeId=` | — | `{ heldByOthers: [id], heldByMe: [id] }` |
| STOMP `/topic/showtimes/{id}/seats` | — | `{ type, showtimeId, seatIds, sessionId, expiresAtEpochMs }` |

`seats[].id` is the showtime seat id; send exactly these ids to hold.

## Step 1 — UX/UI

1. Screen: screen-edge label, seat grid by `rowNumber` sorted by seat number, legend, selected summary (seat codes), countdown, Continue button.
2. Continue is disabled until at least one seat is selected and the pair rule passes; it shows progress while holding.
3. Countdown at zero: snackbar "hold expired", clear selection, reload map.
4. Conflict on hold: snackbar with server message, reload map, keep the user on the screen.
5. Keys under `seats.*`: `seats.title`, `seats.legend.available|selected|held|booked|couple`, `seats.continue`, `seats.expiresIn`, `seats.expired`, `seats.pairError`.

## Step 2 — Backend

1. **Session id (G8).** Add a small resolver (e.g. `HoldSessionResolver` component or a `@RequestHeader("X-Session-Id")` parameter) and replace `HttpSession session` / `session.getId()` in `SeatHoldApiController` (hold, release, state) and `BookingController` (seat map, checkout preview, confirm). Missing or blank → `ApiException(BAD_REQUEST, "SESSION_REQUIRED", …)`. Validate it looks like a UUID to stop arbitrary strings.
2. **Error codes (G9).** In `SeatHoldService.holdSeatsRealtime` and `BookingService.resolveCheckoutData` throw `ApiException(CONFLICT, "SEAT_BOOKED")` for non-`AVAILABLE` seats and `ApiException(CONFLICT, "SEAT_HELD")` for other-session holds. `validateCouplePairs`/`parseSeatCode` throw `ApiException(BAD_REQUEST, "COUPLE_PAIR_INVALID")`. Keep the existing messages.
3. **Couple rule on hold.** If `holdSeatsRealtime` does not already validate couple pairs, call the same validator as checkout (extract it to a package-private helper so there is one rule).
4. **Expiry epoch (G10).** Compute `expiresAt` and its epoch from one clock — use `Instant`/`Clock` injected into `SeatHoldService`, or convert with the same zone used to create the `LocalDateTime`. Apply in `SeatHoldApiController` and `SeatRealtimeService`.
5. WebSocket publish stays in `SeatRealtimeService` on `/topic/showtimes/{id}/seats`. Add a Javadoc line on `SeatHoldApiController` naming the topic and payload.
6. Tests (`SeatHoldServiceTest`, extend): hold leaves status `AVAILABLE`; second session holding the same id gets `SEAT_HELD`; booked seat gets `SEAT_BOOKED`; lone couple seat gets `COUPLE_PAIR_INVALID`; expiry epoch ≈ now + holdMinutes. One `@WebMvcTest` for the controller: missing header → 400 `SESSION_REQUIRED`.

## Step 3 — Frontend

Feature `seats`:

1. Add `stomp_dart_client` to `pubspec.yaml` and record it in `.cursor/skills/movie-ticket-stack/flutter.md` as the realtime package.
2. DTOs: `SeatMapResponseDto`, `SeatDto`, `HoldResponseDto`, `HoldStateDto`, `SeatEventDto`.
3. Entities: freezed `SeatView(id, code, row, number, type, status, uiState)` where `uiState` is `available | selected | heldByMe | heldByOthers | booked`; `Hold(showtimeId, seatIds, expiresAt)`.
4. `couple_pairing.dart`: pure function, parses `^([A-Za-z]+)(\d+)$`, returns the partner code or an error. Same rule as analytics 3.4. Display guard only — the server result wins.
5. `SeatRepository` (lazy singleton): `loadMap`, `hold`, `release`, `state`, and `Stream<SeatEvent> watch(showtimeId)` that owns the STOMP client and the polling fallback. No socket code in widgets or the bloc.
6. `SeatMapBloc` (factory) events: `LoadRequested`, `SeatToggled`, `HoldRequested`, `ReleaseRequested`, `RemoteSeatChanged`, `HoldTicked`, `HoldExpired`. It ignores events whose `sessionId` equals our own.
7. Leaving the screen: `close()` of the bloc fires a release when a hold exists and the user did not continue (fire-and-forget; the server TTL is the backstop).
8. Continue on success navigates to the checkout route with `Hold` (placeholder until sprint 4).

## Step 4 — Testing

1. Unit: couple pairing (A1→A2, A2→A1, A3+A4 valid, A2+A3 invalid, lone seat invalid, different rows invalid).
2. Bloc tests: toggle normal seat; couple tap selects partner; invalid set blocks hold; remote `HELD` disables a seat; own-session event ignored; expiry clears selection; conflict reloads map.
3. Repository test: header `X-Session-Id` present; event JSON maps to entity.
4. Widget test: booked seat has no tap handler.
5. Backend tests from step 2.
6. Manual: two emulators on the same showtime; hold on one grays the seat on the other within a second; kill the first app, seat returns after TTL.

## Definition of done

Two clients cannot both hold the same seat. The database seat status is still `AVAILABLE` after a hold. The hold survives across requests from the mobile client (proves G8 is fixed).

## Out of scope

Price quote, payment, ticket issue.
