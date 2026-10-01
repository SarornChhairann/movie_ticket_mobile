# Sprint 1 — Identity

## Goal

A customer can register, log in, refresh, log out, and open a profile. Guests can continue without an account. Blocked accounts are told why and cannot reach booking actions.

Depends on: sprint 0. Analytics sections 3.1 and 7. Gap rows G2, G3, G4.

## Acceptance

- [x] Register creates the Keycloak user and a `users` row with role `CUSTOMER` and status `ACTIVE`, then the app logs in with the same credentials.
- [x] Login stores access and refresh tokens in secure storage, then loads the user with `GET /profile`.
- [x] App restart restores the session: refresh token valid → refresh → profile → shell. Invalid → Login.
- [x] Logout calls `POST /api/auth/logout` with the refresh token, then clears local storage even if the call fails.
- [x] Profile shows name, email, phone, points. Edit name and phone. Change password.
- [x] `SUSPENDED` and `BANNED` users see the blocked message (from `code: ACCOUNT_BLOCKED`) on login and on any later authenticated call, and the session is cleared.
- [x] Guest entry goes to the shell without calling login. Guest and signed-in users share the same `X-Session-Id` mechanism from sprint 0.
- [x] Tokens and passwords never appear in logs.

*Verified by unit, bloc, repository, and widget tests plus backend `AuthServiceTest`; the manual device run against a live API/Keycloak (Step 4.4) is still pending.*

## API contract

| Call | Request | Response used / errors |
| --- | --- | --- |
| `POST /api/auth/register` | `{ name, email, password }` | 201 `{ message, user: { id, name, email, role } }`. 409 email in use. 400 validation. |
| `POST /api/auth/login` | `{ email, password }` | `{ access_token, refresh_token, expires_in, token_type, email, name, role }`. 401 bad credentials. 403 `ACCOUNT_BLOCKED`. |
| `POST /api/auth/refresh` | `{ refresh_token }` | Same as login. |
| `POST /api/auth/logout` | `{ refresh_token }` | 204. |
| `GET /profile` | Bearer | `{ id, name, email, phone, role, points, status }` |
| `POST /profile` | Bearer, `{ name, phone }` | Same as `GET /profile`. |
| `POST /profile/change-password` | Bearer, `{ currentPassword, newPassword, confirmPassword }` | 200 empty. 400 wrong current / mismatch / under 6 chars. |

Note: register takes no phone and returns no tokens (G3); login returns no `id`/`status`/`points` (G4). Do not change those endpoints — the app logs in after register and reads the user from `/profile`.

## Step 1 — UX/UI

1. Screens: Login (with **Continue as guest**), Register, Profile, Edit profile, Change password, Blocked notice.
2. Fields: Login (email, password); Register (name, email, password, confirm password); Edit (name, phone). Inline validation: email format, password ≥ 6, confirm matches. Disable submit while loading.
3. API errors shown as the server `error` text in a banner, never a stack.
4. Keys: `auth.login`, `auth.register`, `auth.guest`, `auth.logout`, `auth.email`, `auth.password`, `auth.confirmPassword`, `auth.name`, `auth.blocked`, `auth.invalid_credentials`, `profile.title`, `profile.points`, `profile.phone`, `profile.edit`, `profile.save`, `profile.changePassword`.

## Step 2 — Backend

1. Keep `POST /api/auth/login`, `/register`, `/refresh`, `/logout` as the contract.
2. `AuthService` blocked check (currently `ResponseStatusException(FORBIDDEN, "This account is …")`) throws `ApiException(FORBIDDEN, "ACCOUNT_BLOCKED", <same message>)` (G2).
3. `KeycloakUserSyncFilter` 403 body for blocked users adds `"code": "ACCOUNT_BLOCKED"` so the mobile interceptor can tell a blocked user from a missing role.
4. `GET /profile` and `POST /profile` stay bearer-only (already in `SecurityConfig`).
5. Password change stays in Keycloak. Do not write a usable password into `users.password`.
6. Tests: blocked user login → 403 with `ACCOUNT_BLOCKED`; register defaults role `CUSTOMER` and status `ACTIVE` (mock `KeycloakAdminClient`).

## Step 3 — Frontend

Features `auth` and `profile`, built in the README order:

1. DTOs: `LoginRequestDto`, `TokenResponseDto` (`@JsonKey(name: 'access_token')` etc.), `RegisterRequestDto`, `UserDto`, `UpdateProfileDto`, `ChangePasswordDto`.
2. Entities: freezed `User(id, name, email, phone, role, points, status)`, `AuthSession(user, accessExpiresAt)`.
3. `AuthFailure` union: `invalidCredentials`, `blocked(message)`, `emailInUse`, `validation(message)`, `network`, `unknown(message)` — built from `ApiFailure` status + `code`.
4. `AuthRepository` (lazy singleton): `login`, `register`, `refresh`, `logout`, `currentUser` (`GET /profile`). No Keycloak URL in Flutter.
5. `AuthBloc` (app-level, provided above the navigator): events `SessionStarted`, `LoginRequested`, `RegisterRequested`, `GuestContinued`, `LogoutRequested`, `SessionExpired` (from the sprint 0 interceptor stream). State: `unknown | unauthenticated | guest | authenticated(User) | blocked(message)` plus `submitting` and a one-shot `failure`.
6. Interceptor: a 403 with `ACCOUNT_BLOCKED` on any call adds `SessionExpired(blocked: true)` instead of refreshing.
7. `ProfileBloc` (factory): `ProfileLoaded`, `ProfileSaved`, `PasswordChangeRequested`.
8. Router: splash while `unknown`; `unauthenticated` → Login; `guest`/`authenticated` → Shell; `blocked` → Blocked notice. Profile entry hidden for guests.
9. Register both blocs as factories, the repository as a lazy singleton, in `registerAuth(GetIt)` / `registerProfile(GetIt)`.

## Step 4 — Testing

1. Bloc tests: login success stores session and loads profile; login 403 `ACCOUNT_BLOCKED` yields `blocked`; login 401 yields `invalidCredentials`; register success then auto-login; logout clears session even when the API call fails; `SessionStarted` with no refresh token yields `unauthenticated`.
2. Repository test (Dio mock adapter): token JSON maps to the session; error JSON maps to the right `AuthFailure`.
3. Backend service tests from step 2.
4. Manual: login, kill app, reopen, profile still loads; suspend the user from admin, next call shows the blocked notice.

## Definition of done

Acceptance boxes checked. Tokens never logged. Guest path reaches the shell without calling login. `flutter analyze`, `flutter test`, `./mvnw test` pass.

## Out of scope

Movie lists, seats, checkout, social login, forgot-password.
