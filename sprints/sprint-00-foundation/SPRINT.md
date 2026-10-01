# Sprint 0 — Foundation

## Goal

A Flutter app and a running API client exist. No booking screens yet. The app calls the public home endpoint, attaches a bearer token when one is stored, sends the hold session id, and turns API errors into typed failures.

Depends on: analytics sections 1, 3.1, 7. README sections **Cross-sprint contracts** 1, 2, 5. Gap row G1.

## Acceptance

- [ ] `movie_ticket_mobile` builds and runs on Android emulator and iOS simulator. Application id is `com.chhairann.movie_ticket`. *(Debug APK and iOS simulator app build; not yet run on a device against a live API.)*
- [x] `pubspec.yaml` has exactly the skill packages: `flutter_bloc`, `get_it`, `easy_localization`, `freezed_annotation`, `json_annotation`, `dio`, `flutter_secure_storage`; dev: `build_runner`, `freezed`, `json_serializable`, `bloc_test`, `mocktail`, `http_mock_adapter` (+ `shared_preferences`, test-only, to mock EasyLocalization storage).
- [x] GetIt registers Dio, `TokenStore` (secure storage), `SessionIdProvider`, and the interceptors.
- [x] EasyLocalization loads `en` and `km` (Khmer) with a language toggle on a blank home shell. Choice survives restart.
- [x] Dio base URL comes from `--dart-define=API_BASE_URL`. A missing value fails fast at startup with a clear message.
- [x] Every request carries `X-Session-Id`. Requests carry `Authorization: Bearer` only when a token exists.
- [x] 401 from a protected call attempts one refresh (`POST /api/auth/refresh`), retries the original once, and on failure clears the session. Concurrent 401s share one refresh.
- [x] API errors become an `ApiFailure` with `status`, `code` (nullable), and `message` from the `error` field.
- [x] Backend error body includes `code` when thrown through `ApiException`. Existing errors are unchanged.
- [x] Backend stays stateless JWT. No new session filter, no security matcher changes.

## API contract

| Call | Request | Response used |
| --- | --- | --- |
| `GET /` | — | 200, `{ nowShowing, comingSoon, heroMovies, cinemas, today, featuredMovie }` (only the status matters this sprint) |
| `POST /api/auth/refresh` | `{ "refresh_token": "..." }` | `{ access_token, refresh_token, expires_in, token_type, email, name, role }` |
| Any error | — | `{ "error": "<message>", "type": "<status>", "code"?: "<CODE>" }` |

## Step 1 — UX/UI

1. App shell: top bar, language toggle (EN / ខ្មែរ), empty body, error banner, loading overlay.
2. Shared state widgets in `lib/core/widgets`: `LoadingView`, `EmptyView(messageKey)`, `ErrorView(message, onRetry)`. Every later screen uses these.
3. Theme in `lib/core/theme`: light surface, 8px spacing scale (`Space.x1 = 8` …), seat color tokens `available`, `held`, `selected`, `booked`, `couple`.
4. Copy keys only. No raw English in widgets. Keys: `app.title`, `common.retry`, `common.loading`, `common.empty`, `common.error`, `shell.language`. Add to both `en.json` and `km.json`.

## Step 2 — Backend

1. Confirm `GET /` returns 200 without a token (`curl -i http://localhost:8010/`).
2. Add `ApiException extends RuntimeException` with `HttpStatus status`, `String code`, and the message. Handle it in `ApiExceptionHandler`, writing `{error, type, code}`. Leave the other handlers as they are (G1).
3. Unit test: a controller-advice test (`@WebMvcTest` with a throwaway controller, or a direct handler call) asserts the body has `code` for `ApiException` and has no `code` for `IllegalArgumentException`.
4. Add the mobile dev origin to `APP_CORS_ALLOWED_ORIGINS` in `.env.example` only for `flutter run -d chrome`; native builds do not need it.
5. Do not change security matchers in this sprint.

## Step 3 — Frontend

Build in this order:

1. `pubspec.yaml` packages (see acceptance), `assets/translations/` registered, `flutter pub get`.
2. Platform setup: Android debug manifest `usesCleartextTraffic="true"` and `INTERNET` permission; iOS `NSAppTransportSecurity` exception for local hosts in Debug.
3. `core/config/env.dart`: `const apiBaseUrl = String.fromEnvironment('API_BASE_URL')`; throw a `StateError` in `main` if empty.
4. `core/session/token_store.dart`: read/write/clear access token, refresh token, expiry in `flutter_secure_storage`. Never log values.
5. `core/session/session_id_provider.dart`: one UUID v4 per app run from `Random.secure()`.
6. `core/network/api_failure.dart`: freezed `ApiFailure(status, code, message)` plus `ApiFailure.network()` and `ApiFailure.unknown()`; `fromDioException`.
7. `core/network/session_header_interceptor.dart`: adds `X-Session-Id`.
8. `core/network/auth_interceptor.dart` (`QueuedInterceptor`): adds bearer; on 401 for a request that had a token, refresh once with a **separate bare Dio** (no auth interceptor, avoids a loop), retry once, else `TokenStore.clear()` and emit on a `SessionExpired` stream. Skip refresh for `/api/auth/**` calls.
9. `core/network/dio_client.dart`: single Dio, `baseUrl`, 10s connect / 20s receive timeouts, JSON, interceptors in order: session header → auth → (debug only) log interceptor with `Authorization` redacted.
10. `core/di/injection.dart`: `configureDependencies()`; Dio, stores, interceptors as lazy singletons; calls `registerShell(getIt)`.
11. `main.dart`: `WidgetsFlutterBinding.ensureInitialized()` → `EasyLocalization.ensureInitialized()` → `configureDependencies()` → `runApp(EasyLocalization(supportedLocales: [en, km], path: 'assets/translations', fallbackLocale: en, child: App()))`.
12. Feature `shell`: `ShellCubit` with state `initial | loading | ready | failure(ApiFailure)`; `pingRequested()` calls `GET /` through a `ShellRepository`. Locale is owned by EasyLocalization (`context.setLocale`), not duplicated in the cubit.
13. Routing: Flutter's built-in `Navigator` with an `onGenerateRoute` in `core/router/app_router.dart` and route-name constants. No extra router package.

## Step 4 — Testing

1. Widget test: shell renders; tapping the language toggle changes a sample string from English to Khmer.
2. Unit test: auth interceptor adds `Authorization` when a token exists and skips it when absent.
3. Unit test: on 401 the interceptor refreshes once and retries; when refresh fails it clears the store and does not retry again; two parallel 401s trigger one refresh.
4. Unit test: session header is the same value across two requests.
5. Unit test: `ApiFailure.fromDioException` reads `code` and `error`, and tolerates a body without `code`.
6. Backend: the `ApiException` handler test and the existing context load test pass (`./mvnw test`).

## Definition of done

The acceptance boxes are checked, `flutter analyze` is clean, `flutter test` and `./mvnw test` pass, the app shows home data status against a running API on an emulator, and no feature folder other than `shell` exists.

## Out of scope

Login form, movies, seats, payments, websocket client.
