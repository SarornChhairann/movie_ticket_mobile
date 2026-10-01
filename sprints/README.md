# Agile sprints for the movie ticket agents

Work one sprint at a time. A sprint is a vertical slice: UX, API, Flutter, and tests land together and can be demoed.

Read first:

1. `movie_ticket_mobile/system_analytics/SYSTEM_ANALYTICS.md` — behavior, ERD, DFD, invariants.
2. `.cursor/skills/movie-ticket-stack/SKILL.md` — Flutter and Spring Boot rules. Open `flutter.md` or `spring-boot.md` for the layer you are editing.
3. This file (especially **Cross-sprint contracts** and **Backend gap register**), then only the current `SPRINT.md`.

## Method

Scrum, one-week slices. The agent is the implementer. There is no separate discovery sprint inside a slice.

| Order inside a sprint | Owner | Output |
| --- | --- | --- |
| 1. Read the sprint, the analytics sections it names, and its rows in the gap register | Agent | Checklist copied into the working notes |
| 2. Contract check | Agent | Call each endpoint the sprint uses (Swagger UI at `/swagger-ui.html` or `curl`) and confirm the response shape in the sprint's **API contract** table. Fix the table first if the code drifted. |
| 3. UX/UI | Agent | Screen list, states, copy keys |
| 4. Backend | Agent | Close the sprint's gap rows, with a test per change |
| 5. Frontend | Agent | DTO → mapper → entity → repository → bloc → view, wired through GetIt |
| 6. Testing | Agent | Unit tests for pricing/holds/blocs, plus one API test for the slice |
| 7. Demo check | Agent | Every acceptance box in the sprint is true, on a real device/emulator against a running API |

Why backend before frontend: the Flutter DTOs are written against the real JSON. Writing them against a shape the backend does not return yet is the most common source of rework in this project.

Rules:

- Finish sprint `NN` definition of done before opening `NN+1`.
- Do not invent price math, seat states, or roles. Copy them from the analytics.
- Customer app scope is guest and customer. Admin stays on `/admin/**`.
- If a backend rule already exists in `Ticket-Management-System`, call it. Change it only when the sprint (or the gap register) says the target transaction differs from the current shortcut.
- Backend changes are additive where possible: new fields on response records, new endpoints beside old ones. Do not rename or remove a field another client may read.
- Keep each change inside the feature named by the sprint.

## Cross-sprint contracts

These are decided once and reused by every sprint. Do not redesign them inside a feature.

### 1. Hold session id — `X-Session-Id` header

The API is a stateless JWT resource server, but `SeatHoldApiController` and `BookingController` currently read `HttpSession.getId()`. A Dio client keeps no cookies, so every request would get a new servlet session and the hold → quote → confirm chain would always fail with "Your seat hold expired".

- The app creates **one UUID per app install run** (guest *and* signed-in user) in `core/session/session_id_provider.dart` and sends it on every request as `X-Session-Id`. Generate it with `Random.secure()` — do not add a `uuid` package for one function.
- Logout and login do **not** rotate it mid-flow; app restart does.
- Backend (sprint 3, `HoldSessions`) resolves the id from the header on hold/release/state/seat-map/quote/confirm. A malformed (non-UUID) header returns 400 `SESSION_REQUIRED`; a **missing** header falls back to the servlet session id so cookie-based browser clients keep working. The mobile app always sends the header. *(Closed in sprint 3.)*

### 2. Error body and `code`

Today every error is `{ "error": "<message>", "type": "<HTTP status name or BAD_REQUEST/CONFLICT>" }`. The Flutter rules branch on a stable `code`, never on message text.

- Sprint 0 adds an `ApiException(HttpStatus status, String code, String message)` handled by `ApiExceptionHandler`, which writes `{ "error", "type", "code" }`. `code` is omitted for errors that are not domain errors. Existing `IllegalArgumentException`/`IllegalStateException` keep working.
- Codes are added by the sprint that owns them. The full list lives here so the client can define one enum:

| Code | HTTP | Owner sprint | Thrown when |
| --- | --- | --- | --- |
| `ACCOUNT_BLOCKED` | 403 | 1 | Login or any authenticated call by a `SUSPENDED`/`BANNED` user |
| `SESSION_REQUIRED` | 400 | 3 | `X-Session-Id` missing |
| `SEAT_HELD` | 409 | 3 | Another session holds one of the seats |
| `SEAT_BOOKED` | 409 | 3 | A seat is already `BOOKED` (hold, quote, or confirm) |
| `COUPLE_PAIR_INVALID` | 400 | 3 | Couple seats not in `(odd, odd+1)` same-row pairs |
| `HOLD_EXPIRED` | 409 | 4 | Quote or confirm without an active hold owned by this session |
| `PROMO_INVALID` | 400 | 4 | Promo not found, inactive, expired, exhausted, or under `minPurchase` |
| `PAYMENT_FAILED` | 402 | 5 | Provider returned `FAILED` |
| `NOT_OWNER` | 403 | 6 | Cancel by someone who is not the booking's user |
| `ALREADY_CANCELLED` | 409 | 6 | Cancel on a `CANCELLED` booking |
| `CANCEL_WINDOW` | 409 | 6 | Cancel inside the cancellation window |
| `REMINDER_EXISTS` | 409 | 7 | Same email + movie already subscribed |

The client maps unknown codes to a generic failure and still shows the server's `error` message.

### 3. Realtime seats

- Endpoint: `WebSocketConfig` registers `/ws` **with SockJS only**. A native client connects to the SockJS raw-WebSocket transport at `ws(s)://<host>/ws/websocket` (derive it from `API_BASE_URL`). Do not add a second endpoint unless that URL fails.
- Topic: `/topic/showtimes/{showtimeId}/seats`.
- Payload: `{ "type": "HELD" | "RELEASED" | "BOOKED", "showtimeId", "seatIds": [showtimeSeatId...], "sessionId", "expiresAtEpochMs" }`.
- Package: `stomp_dart_client` — the one realtime package the app adds (it is not a second HTTP client, so it fits the skill). Record it in `flutter.md` in sprint 3.
- Fallback: if the socket fails, poll `GET /api/seat-holds/state` every 5 seconds while the seat map is visible. The bloc does not care which source produced a `RemoteSeatChanged`.

### 4. Ids and money on the wire

- Seat ids everywhere in the customer flow are **showtime seat ids** (`showtime_seats.id`), not `seats.id`.
- Money arrives as JSON numbers (`BigDecimal`) on most records and as strings on `/api/showtimes/search`. DTOs parse both into `Decimal`-safe values (store as `String` or integer cents in the entity, never `double` arithmetic). The view only formats.
- Times: `showDate` is ISO date, `showTime` is `HH:mm[:ss]`, both in the cinema's local zone (`Asia/Phnom_Penh`). Do not convert them with the device time zone.

### 5. Device networking (dev)

- Android emulator reaches the host at `http://10.0.2.2:8010`, iOS simulator at `http://localhost:8010`, a physical device at the host's LAN IP.
- Debug builds allow cleartext HTTP (Android `usesCleartextTraffic` in the debug manifest, iOS ATS exception in Debug only). Release builds do not.
- CORS only matters for `flutter run -d chrome`; native apps are not subject to it.

## Backend gap register

Verified against `Ticket-Management-System` source on 2026-10-01. Each row is closed by the named sprint; ✅ marks rows already closed (G1–G17 as of sprint 5). Re-check a row before closing it — the code may have moved.

| # | Area | Current backend | Target | Sprint |
| --- | --- | --- | --- | --- |
| G1 | Error body ✅ | `{error, type}` only | Adds optional `code` via `ApiException` | 0 |
| G2 | Blocked login ✅ | `AuthService` throws 403 `ResponseStatusException`, no code; `KeycloakUserSyncFilter` writes its own 403 body | Both return `code: ACCOUNT_BLOCKED` | 1 |
| G3 | Register ✅ | Body is `name, email, password`; no phone; returns no tokens | Keep. App logs in right after register; phone is set from Profile | 1 |
| G4 | Login payload ✅ | Returns `email, name, role, access_token, refresh_token, expires_in`; no `id`, `status`, `points` | Keep. App calls `GET /profile` after login/refresh to load the user | 1 |
| G5 | Movie list ✅ | `GET /api/movies` needs `type` + `date`/`month` and returns a home-style browse; `GET /movies?tab=&search=` filters by status | App uses `GET /movies?tab=NOW_SHOWING|COMING_SOON&search=` (`movies` field) | 2 |
| G6 | Showtimes ✅ | `/movies/{id}` returns `showtimesByDate` incl. `blocked` rows, no cinema name or hall flags; `/api/showtimes/search` requires `date` | `ShowtimeSummary` adds `cinemaName`, `hasDolbyAtmos`, `hasScreenX`; blocked and already-started showtimes are excluded from the customer response | 2 |
| G7 | Posters ✅ | `imagePath`/`bannerPath` are relative (`/uploads/movies/...`) | App prefixes `API_BASE_URL`; no backend change | 2 |
| G8 | Hold session ✅ | `HttpSession.getId()` in `SeatHoldApiController` and `BookingController` | `X-Session-Id` header (contract 1) | 3 |
| G9 | Seat errors ✅ | Already-booked in `resolveCheckoutData` is `IllegalArgumentException` → 400; couple error has no code | `SEAT_BOOKED` 409, `SEAT_HELD` 409, `COUPLE_PAIR_INVALID` 400 | 3 |
| G10 | Hold expiry epoch ✅ | `LocalDateTime.now()` converted with fixed `Asia/Phnom_Penh` zone | Use `Instant`/server zone consistently; test that `expiresAtEpochMs - now ≈ holdMinutes` | 3 |
| G11 | Quote side effect ✅ | `GET /bookings/checkout/{id}` **places a hold** and ignores food | New pure `POST /bookings/quote/{showtimeId}` (no hold, no writes) that takes food | 4 |
| G12 | Quote lines ✅ | Response lacks `subtotal`, `foodTotal`, food lines | Quote response returns every line in analytics 3.4 order | 4 |
| G13 | Promo `minPurchase` ✅ | `buildCheckout` calls `validate(code)` with a null subtotal, so `minPurchase` is never checked | Quote and confirm call `validateWithSubtotal(code, subtotal)` | 4 |
| G14 | Promo endpoint ✅ | `POST /bookings/promo/validate` always 200 with `valid: false` | App does not use it; it re-quotes with the promo and reads `PROMO_INVALID` | 4 |
| G15 | Confirm order ✅ | Promo usage recorded before payment; `processMockPayment` always `PAID` and flips `CONFIRMED` itself | Analytics 6.3 order behind a `PaymentGateway` interface | 5 |
| G16 | Confirm response ✅ | `{ bookingId }` only | Returns the `BookingDetailResponse` (same as `/confirmation/{id}`) | 5 |
| G17 | Blocked checkout ✅ | Guest path has no status check; signed-in blocked users are stopped by the sync filter | Confirm rejects a blocked attached user with `ACCOUNT_BLOCKED` (defense in depth) | 5 |
| G18 | My bookings order | `findByUser` (unordered) | `findByUserOrderByBookedAtDesc` | 6 |
| G19 | Cancel errors | Not owner, already cancelled, inside window → all 400 | `NOT_OWNER` 403, `ALREADY_CANCELLED` 409, `CANCEL_WINDOW` 409 | 6 |
| G20 | Cancel realtime | Cancel frees seats but publishes nothing | Publish `RELEASED` for freed seats so open seat maps update | 6 |
| G21 | Reminder duplicate | Silently returns `{ok:true}` | 409 `REMINDER_EXISTS` | 7 |
| G22 | Reminder email | Sends synchronously and throws 409 when mail is not configured, so the row is rolled back in dev | Persist first; email is best-effort (log on failure) | 7 |
| G23 | Ticket QR access | `/tickets/{code}/qr` is public to anyone holding a code | Accepted for v1 (code is the bearer secret). Note in sprint 6, revisit after v1 | 6 |

## Sequence

| Sprint | Folder | Demo | Gap rows |
| --- | --- | --- | --- |
| 0 | `sprint-00-foundation` | App boots, talks to the API, tokens refresh | G1 |
| 1 | `sprint-01-identity` | Register, login, logout, profile shell | G2, G3, G4 |
| 2 | `sprint-02-catalog` | Browse movies, cinemas, showtimes | G5, G6, G7 |
| 3 | `sprint-03-seat-hold` | Seat map, hold, realtime release | G8, G9, G10 |
| 4 | `sprint-04-checkout-quote` | Quote with promo, food, fees | G11, G12, G13, G14 |
| 5 | `sprint-05-confirm-pay` | Pay, tickets issued, seats booked | G15, G16, G17 |
| 6 | `sprint-06-tickets-cancel` | My bookings, QR, cancel window | G18, G19, G20, G23 |
| 7 | `sprint-07-loyalty-reminders` | Points, coming-soon reminder, locale pass | G21, G22 |

## Per-feature build order (Flutter)

Every feature follows the same order so the agent never writes a widget against a type that does not exist yet:

1. `model/dto/*_dto.dart` — `@JsonSerializable`, field names exactly as the JSON (use `@JsonKey(name: 'access_token')`).
2. `model/entity/*.dart` — `@freezed`, what the UI needs.
3. `model/mapper/*_mapper.dart` — DTO → entity, pure functions, unit tested.
4. `model/*_failure.dart` — freezed union built from HTTP status + `code`.
5. `model/*_repository.dart` — Dio calls, catches `DioException`, returns `Either`-style result or throws the failure. Test with a Dio mock adapter.
6. `controller/*_bloc.dart` + events + freezed state. Test with `bloc_test` and a mocked repository.
7. `view/*_page.dart` — `BlocProvider` at the route, `BlocBuilder` for UI, `BlocListener` for one-shot effects. Widget test with seeded state.
8. `register<Feature>(GetIt)` and a call from `core/di/injection.dart`.
9. Copy keys in `en.json` and `km.json`.
10. `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`.

## Where code goes

| Part | Path |
| --- | --- |
| Flutter app | `movie_ticket_mobile` (this folder, application id `com.chhairann.movie_ticket`) |
| Spring Boot API | `Ticket-Management-System` |
| Analytics | `movie_ticket_mobile/system_analytics/SYSTEM_ANALYTICS.md` |
| Agent skill | `.cursor/skills/movie-ticket-stack/` |
