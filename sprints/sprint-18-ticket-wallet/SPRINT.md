# Sprint 18 — Ticket wallet and post-purchase

## Goal

At the cinema door the ticket is one tap away, readable in any light, and works offline. After purchase the app keeps the user oriented until the show.

Depends on: sprint 13 (`BookingCache`, offline QR), sprint 16 (ticket landing). Finding X8. Journeys P2, P4. Backend: optional G33.

## Acceptance

- [ ] **Up next on Home:** when the user (signed in, or a guest with bookings on this phone) has a confirmed booking whose show starts within the next 7 days, Home shows an `UpNextCard` above the carousel: poster, title, "Tonight 19:30 · Hall 3", live relative countdown ("in 2h 10m", updates each minute, cinema time zone per contract 4), and **Show ticket**. Hidden otherwise. Data from `my-bookings` / `GuestBookingsBloc` + `BookingCache` (or G33 if approved).
- [ ] **Ticket card:** booking detail and Up next open a full-width ticket card (perforated edge, capsule header from sprint 16, seats, reference). Tap or swipe **flips** it (3D Y rotation, `Motion.extraLong`; reduced motion → crossfade) to the QR side. Multiple tickets in one booking are a horizontal pager with dots.
- [ ] **Door mode QR:** QR side is a white high-contrast card at maximum size with the reference in large tabular text below; screen stays awake while shown; brightness per decision D4 (default: "Turn up brightness" hint). Swipe down dismisses.
- [ ] **Offline truth:** if the QR came from cache, a small `OfflineNote` shows "Saved on this phone · updated {time}"; a cancelled booking never shows a scannable QR (status overlay instead).
- [ ] **Status timeline** on booking detail: Booked → Paid → (Show starts) → Used / Cancelled → Refund pending, from fields the API already returns; current state highlighted. No invented states.
- [ ] **Bookings tab** grouped into **Upcoming** and **Past**, upcoming sorted by show time ascending; empty state with **Browse movies**.
- [ ] Post-purchase nudge: Success screen offers **Remind me 1 hour before** only if a local, notification-free path exists (calendar intent via existing `link_opener`); otherwise omitted. No push notifications.

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
