# Sprint 18 — Ticket wallet and post-purchase

## Goal

At the cinema door the ticket is one tap away, readable in any light, and works offline. After purchase the app keeps the user oriented until the show.

Depends on: sprint 13 (`BookingCache`, offline QR), sprint 16 (ticket landing). Finding X8. Journeys P2, P4. Backend: optional G33.

## Acceptance

- [x] **Up next on Home:** when the user (signed in, or a guest with bookings on this phone) has a confirmed booking whose show starts within the next 7 days, Home shows an `UpNextCard` above the carousel: poster, title, "Tonight 19:30 · Hall 3", live relative countdown ("in 2h 10m", updates each minute, cinema time zone per contract 4), and **Show ticket**. Hidden otherwise. Data from `my-bookings` / `GuestBookingsBloc` + `BookingCache` (or G33 if approved).
- [x] **Ticket card:** booking detail and Up next open a full-width ticket card (perforated edge, capsule header from sprint 16, seats, reference). Tap or swipe **flips** it (3D Y rotation, `Motion.extraLong`; reduced motion → crossfade) to the QR side. Multiple tickets in one booking are a horizontal pager with dots.
- [ ] **Door mode QR:** *(all but keep-awake — see Status)* QR side is a white high-contrast card at maximum size with the reference in large tabular text below; screen stays awake while shown; brightness per decision D4 (default: "Turn up brightness" hint). Swipe down dismisses.
- [x] **Offline truth:** if the QR came from cache, a small `OfflineNote` shows "Saved on this phone · updated {time}"; a cancelled booking never shows a scannable QR (status overlay instead).
- [x] **Status timeline** on booking detail: Booked → Paid → (Show starts) → Used / Cancelled → Refund pending, from fields the API already returns; current state highlighted. No invented states.
- [x] **Bookings tab** grouped into **Upcoming** and **Past**, upcoming sorted by show time ascending; empty state with **Browse movies**.
- [x] Post-purchase nudge: Success screen offers **Remind me 1 hour before** only if a local, notification-free path exists (calendar intent via existing `link_opener`); otherwise omitted. No push notifications.

## API contract

Reuse `GET /bookings/my-bookings`, `GET /bookings/confirmation/{id}`, `/tickets/{code}/qr`. Optional G33 `GET /bookings/next` → `BookingSummary` | 204 (one backend test if built).

## UX

Copy: `upNext.title`, `upNext.tonight` (`Tonight {time}`), `upNext.tomorrow`, `upNext.inTime` (`in {duration}`), `upNext.showTicket`, `ticket.flipHint`, `ticket.brightnessHint`, `ticket.savedOffline` (`Saved on this phone · updated {time}`), `ticket.timeline.*`, `bookings.upcoming`, `bookings.past`, `bookings.browse`.

## Flutter

`tickets/view/up_next_card.dart` (+ `UpNextCubit`, pure `nextBooking(bookings, now)` selector), `ticket_card.dart`, `ticket_flip.dart`, `door_mode_page.dart` (wakelock via platform channel only if approved; else omit), `booking_timeline.dart`.

## Tests

`nextBooking` selector (none, past only, cancelled skipped, nearest wins, cinema zone vs device zone); countdown text table; flip widget test incl. reduced motion; cancelled booking shows no QR; offline note when from cache; Upcoming/Past grouping; goldens for card front/back in en/km.

## Out of scope

Apple/Google Wallet passes, home-screen widgets, push reminders (decision D6), sharing tickets.

## Status

Done 2026-10-07 in code, except one box. Flutter 482 tests green, analyze clean. No backend change: G33 was not built (decision D7 default — Up next is computed on the phone).

- **Cinema clock:** `CinemaClock` (UTC + 7 h, no DST) is "now" for every show-time comparison here, per contract 4 — never the device zone. Tested with a device-zone instant that would otherwise mis-sort.
- **Up next:** `nextBooking` (pure, tested: none, past only, cancelled skipped, > 7 days skipped, nearest wins), `UpNextCubit` ticking each minute, `UpNextCard` under the Home greeting: "Today 19:30 · Hall 3", "in 2h 10m", **Show ticket** → the ticket opened on its QR side. Signed in it reads the account list (server, device copy offline); a guest's comes from the bookings saved on this phone **without network calls**, so Home never spends lookups. **Deviation:** no poster thumbnail — the booking API has no poster field and this sprint adds no backend; the card uses a ticket icon. "Tonight" reads "Today" so a 10:00 show is not called tonight.
- **Ticket card:** `/tickets/wallet` — one flip card per ticket in a pager with dots; perforated stub, capsule header (no hero inside the pager to avoid duplicate tags), seat, reference. Tap flips (3D Y rotation, `Motion.extraLong`; reduced motion swaps at once). **Deviation:** a horizontal swipe pages between tickets, so it does not also flip; flip is tap. Booking detail's ticket rows open the wallet at that ticket; Success keeps the single-QR screen.
- **Door mode — partly open:** white high-contrast QR at full card width, code and reference in large tabular digits, brightness hint, swipe down closes. **Not done:** keeping the screen awake — it needs a wakelock package or platform channel (decision D4 not approved), so it is omitted as the plan allows.
- **Offline truth:** a cached QR shows "Saved on this phone · updated 18:40" (file time of the saved PNG); a cancelled ticket shows its status and never requests or shows a QR (tested).
- **Timeline:** Booked → Paid → Show starts → Used, or Booked → (Paid) → Cancelled → Refund pending / Refunded, only from status, tickets, refund, and show time; current step highlighted.
- **Bookings tab:** Upcoming (soonest first) and Past (latest first) sections, ties keep server order; empty state has **Browse movies** (switches to Explore).
- **Reminder nudge:** omitted, as the box allows: the only calendar path is a web URL, not a local intent.
- Goldens: ticket front/back in en and km.

