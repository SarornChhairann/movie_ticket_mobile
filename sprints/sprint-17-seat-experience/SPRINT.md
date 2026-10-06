# Sprint 17 — Seat experience

## Goal

Make the seat map the best moment in the app: easy to see the whole hall, satisfying to pick, clear when someone else takes a seat — and fully usable with a screen reader.

Depends on: sprint 15 (refactored seat widgets), sprint 14 (party size, Best seats). Finding X7. Journeys P1, P3. No backend.

## Acceptance

- [ ] **Screen and depth:** curved screen with a soft glow painted by `CustomPainter`; rows nearer the screen render very slightly smaller (perspective ≤ 6%, transform only, off under reduced motion). Row letters on both edges stay sticky while panning.
- [ ] **Auto-focus:** after Best seats or the first manual pick, the `InteractiveViewer` animates (`Motion.extraLong`, `Motion.emphasized`) to frame the selection at a comfortable zoom; double-tap toggles fit-whole-hall ↔ focus.
- [ ] **Mini-map:** while zoomed in, a small overview (top-right, 25% width) shows the hall with selected seats and the current viewport rectangle; tap to jump. Hidden when the whole hall fits.
- [ ] **Best seats reveal:** chosen seats light up left-to-right with a 40 ms stagger (max 8) before the hold call returns; if the server rejects, they fade back and the server error shows. Never shows a seat as booked/held before the server says so.
- [ ] **Seat press:** long-press shows a tooltip "Row F · Seat 7 · Couple" (no price). Selection pop and `AppHaptics.selection` stay from sprint 8/15.
- [ ] **Realtime clarity:** a seat taken by someone else pulses twice in the held style; if it was in the user's *pending* selection, an `InlineBanner` says "F7 was just taken" with **Pick next best** (runs Best seats for the missing count).
- [ ] **Accessibility list mode:** with a screen reader on (or via a "List view" toggle), seats are offered as rows: "Row F, 6 seats available: 3, 4, 5, 6, 7, 8". Each row expands to selectable seats with state in the label ("Seat 7, available, couple pair with 8"). Party size + Best seats + list mode completes a booking with TalkBack and VoiceOver.
- [ ] **Legend** becomes interactive: tapping "Couple" briefly highlights all couple seats.
- [ ] 60 fps while panning/zooming a 300-seat hall on the mid-range Android (seat grid in a `RepaintBoundary`, seats painted, not one widget per seat if profiling shows it is needed).

## UX

Copy: `seats.tooltip` (`Row {row} · Seat {seat}`), `seats.coupleWith` (`couple pair with {seat}`), `seats.rowSummary` (`Row {row}, {count} seats available: {list}`), `seats.justTaken` (`{seat} was just taken`), `seats.pickNext`, `seats.listView`, `seats.mapView`, `seats.fitHall`.

## Flutter

`seats/view/screen_painter.dart`, `seat_minimap.dart`, `seat_focus_controller.dart` (computes target `Matrix4` from selection bounds — pure, unit-tested), `seat_list_mode.dart`, `SeatMapBloc` event `RemoteSeatLost` → state flag consumed once by a listener.

## Tests

Focus-rect math (single seat, block, row ends, couple pair); mini-map viewport mapping; list-mode semantics labels; "just taken" banner only when the lost seat was selected; Best-seats reveal rolls back on server error; reduced-motion: no perspective, no stagger, instant focus; profile run numbers recorded in Status.

## Out of scope

3D hall view, seat-view photos, accessibility seat type (needs backend seat type), price tiers.
