# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

The Flutter **customer** app for an online movie-ticket booking system. Dart package `movie_ticket_mobile`, application id / bundle id `com.chhairann.movie_ticket`. It talks to the Spring Boot API in the sibling folder `../Ticket-Management-System` (it has its own CLAUDE.md; default port 8010, Keycloak auth, stateless JWT). Admin features stay on the backend's `/admin/**` and are never called from this app.

Current state: Sprints 0–5 are done — core network/session/DI/theme/l10n plus the `shell`, `auth`, `profile`, `catalog`, `seats`, and `checkout` features exist. `AuthBloc` is app-level and `App` resets the navigator stack when the session kind changes; the shell body is the catalog; the seat map holds seats under `X-Session-Id` and listens on STOMP (`stomp_dart_client`) with a polling fallback. Checkout shows the read-only server quote (`POST /bookings/quote/{id}`) and Pay confirms through `POST /bookings/checkout/{id}` (backend `PaymentGateway`, mock = always `PAID`), then shows the success screen with ticket codes. Languages are English and Khmer (`km`). Next is Sprint 6 (tickets and cancel). The Flutter SDK is managed by fvm: if `flutter` is not on `PATH`, use `/Users/apple/fvm/versions/stable/bin/flutter`.

## Read before changing anything

1. `system_analytics/SYSTEM_ANALYTICS.md` — source of truth for behavior: seat inventory, pricing formula (§3.4), confirm transaction (§3.5), booking state, ERD, DFDs, the API map (§7), and invariants (§8).
2. `../.cursor/skills/movie-ticket-stack/SKILL.md` and `flutter.md` (or `spring-boot.md` when editing the backend) — stack and layering rules.
3. `sprints/README.md`, then only the current `sprints/sprint-NN-*/SPRINT.md`.

Sprint rules: finish sprint NN's definition of done before starting NN+1; keep changes inside the feature the sprint names; each sprint lands UX → backend → frontend → tests as one vertical slice. **Do not invent price math, seat states, or roles** — copy them from the analytics.

## Commands

```
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8010   # base URL must come from dart-define
flutter analyze                                                # lints: package:flutter_lints
flutter test                                                   # all tests
flutter test test/path/to/file_test.dart                       # single file
flutter test --plain-name "test name"                          # single test by name
dart run build_runner build                                    # after editing freezed/json_serializable classes
```

Never hand-edit `*.freezed.dart` or `*.g.dart`.

## Target architecture (from the Cursor skill)

Packages — use exactly these, do not add alternatives: `flutter_bloc`, `get_it`, `easy_localization` (`en` + `km` Khmer), `freezed` + `json_serializable`, `dio`, `flutter_secure_storage`, `stomp_dart_client` (seat realtime). Tests use `bloc_test`.

```
lib/
  main.dart                 # WidgetsFlutterBinding → EasyLocalization.ensureInitialized → configureDependencies() → runApp(EasyLocalization(...))
  core/di/injection.dart    # the only place that touches GetIt registration; calls each feature's registerX(GetIt)
  core/network/             # dio_client.dart, auth_interceptor.dart
  core/widgets/             # loading / empty / error states, seat legend colors
  core/theme/               # 8px spacing; seat color tokens: available, held, selected, booked, couple
  features/<feature>/{model,view,controller}/
assets/translations/en.json, km.json
```

Features: `shell`, `auth`, `profile`, `catalog`, `seats`, `checkout`, `tickets`, `reminders`.

- **Model**: Freezed entity for the UI, DTO for the wire, mapper, and a Dio repository. Repositories catch `DioException` and return a feature failure type — Dio types never leak into bloc state.
- **Controller**: one Bloc/Cubit per screen; events are past-tense intents (`LoginRequested`, `SeatToggled`); state is a freezed union `initial | loading | ready | failure`. Navigation/snackbars are state flags consumed once by a `BlocListener`.
- **View**: no Dio, no price math, no `GetIt.I` in widgets (create the bloc at the route via `BlocProvider`). All strings via `'key'.tr(context: context)` — the `context` argument makes the widget rebuild on a language switch; bare `'key'.tr()` inside a `const` widget stays in the old language — with keys added to both `en.json` and `km.json` in the same change. Money/dates are formatted only — display the quote lines the API returns.
- **GetIt**: Dio, interceptors, token store, repositories → `registerLazySingleton`; blocs → `registerFactory`.
- **Dio**: single instance, `baseUrl` from `String.fromEnvironment('API_BASE_URL')`. `AuthInterceptor` adds `Authorization: Bearer` when a token exists; on 401 it refreshes once, and if that fails clears the session — no retry loop.
- **Session**: tokens in secure storage; guests get one UUID `sessionId` reused for seat hold, release, and confirm.
- **Errors**: branch on HTTP status (400 bad input, 409 conflict) and the `code` field (e.g. `ACCOUNT_BLOCKED`, seat conflict), never on message text. Show the server's message.

## Domain rules the client must respect

- Seat status is only `AVAILABLE` or `BOOKED`. A hold lives in `seat_holds` (with TTL, broadcast over the seat websocket) — "held" is a UI state, not a seat status.
- Couple seats sell only as same-row `(odd, odd+1)` pairs, priced per pair. Client pairing is a view guard; the server result wins.
- The server recomputes totals at confirm; client totals are display-only. Fee/tax/discount rates come from backend `system_settings` — never hard-code them in Flutter.
- Promo discount applies to subtotal only (not tax, service fee, or food).
- Customer cancel is owner-only and blocked inside the cancellation window (default 2h before show).

## Tests

- Bloc tests mock the repository, not Dio. Repository tests use a Dio mock adapter. Widget tests pump a `BlocProvider` with seeded state and never hit the network; wrap localized widgets with `pumpLocalized` from `test/helpers/localized_app.dart` (translations only load in real async).
- Each sprint expects unit tests for pricing/holds/blocs plus one backend API test for the slice; the backend test command is in `../Ticket-Management-System/CLAUDE.md` (`./mvnw test`).
