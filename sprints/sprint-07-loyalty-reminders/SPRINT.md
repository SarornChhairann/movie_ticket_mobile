# Sprint 7 — Loyalty, reminders, and locale pass

## Goal

Close the customer loop: points visible after purchase, coming-soon reminder, and a full pass of English and Khmer copy.

Depends on: sprints 1 through 6. Analytics sections 3.1, 3.2, 3.5. Gap rows G21, G22.

## Acceptance

- [ ] Profile points match `users.points` after a confirmed booking and stay unchanged after a failed payment.
- [ ] Coming-soon movie detail can submit an email reminder (`POST /api/reminders`). Signed-in users get their email prefilled.
- [ ] A duplicate reminder returns `REMINDER_EXISTS` and the app shows a friendly "already subscribed" message, not an error crash.
- [ ] A reminder is saved even when the mail server is not configured (dev).
- [ ] Every user-visible string in `shell`, `auth`, `profile`, `catalog`, `seats`, `checkout`, `tickets`, `reminders` exists in `en.json` and `km.json`, and a test fails if the key sets differ.
- [ ] Switching language on the shell updates the current screen, including dates and money formats.

## API contract

| Call | Request | Response / errors |
| --- | --- | --- |
| `GET /profile` | Bearer | `{ ..., points }` |
| `POST /api/reminders` | `{ movieId, email }` | 200 `{ ok: true }`. 400 invalid email / movie. 409 `REMINDER_EXISTS`. |

## Step 1 — UX/UI

1. Profile: points label, last booking shortcut (first item of my-bookings).
2. Coming-soon detail: email field and Remind button. Hidden for now-showing.
3. Walk every screen and replace leftover literal strings.
4. Keys under `loyalty.*` and `reminders.*`: `loyalty.points`, `loyalty.lastBooking`, `reminders.email`, `reminders.submit`, `reminders.success`, `reminders.exists`.

## Step 2 — Backend

1. Points stay `totalAmount` integer part, registered users only, after `PAID` (sprint 5). Confirm the sprint 5 tests cover it; add one if missing.
2. `MovieReminderService.createReminder`: duplicate → `ApiException(CONFLICT, "REMINDER_EXISTS")` instead of a silent return (G21).
3. Save the row first; send the confirmation email after commit and **best-effort** — log on `MailException` or missing sender, do not throw (G22). Today a missing sender throws `IllegalStateException`, which rolls the row back.
4. Optional: reject reminders for movies that are not `COMING_SOON` with 400.
5. Tests: same email and movie twice → one row and `REMINDER_EXISTS`; email case-insensitive duplicate; mail failure still saves the row.

## Step 3 — Frontend

1. After confirm success (sprint 5) and on Profile open, refresh profile points.
2. Feature `reminders`: `ReminderRepository`, `ReminderBloc` with `SubmitRequested(movieId, email)`; states `idle | submitting | success | alreadySubscribed | failure(message)`.
3. Locale: no new hard-coded strings. Dates via `DateFormat(…, context.locale.toString())`, money via `NumberFormat.currency(locale: …)` (both from `intl`, which `easy_localization` already depends on — add it explicitly to `pubspec.yaml` if you import it directly).
4. Translation parity test: load both JSON files, flatten keys, assert equal sets.

## Step 4 — Testing

1. Bloc test: reminder success and `REMINDER_EXISTS` → `alreadySubscribed`.
2. Backend tests from step 2.
3. Widget test: `km` locale shows the Khmer points label.
4. Unit test: translation key parity.
5. End-to-end manual script (both languages): register → login → browse → hold → quote with promo + food → pay → ticket QR → cancel outside window → points visible.

## Definition of done

The customer path from register to ticket to points works in both languages on an emulator against a running API. Analytics invariants 1 through 8 still hold, and every gap row G1–G22 in the README is closed (G23 accepted).

## Out of scope

Admin app, real card network, push notifications, refund of points on cancel, sending scheduled reminder emails when tickets open.
