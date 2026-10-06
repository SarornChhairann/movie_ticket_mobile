# Sprint 19 — Quality bar: accessibility, performance, telemetry

## Goal

Prove the experience holds up for every user and every device, and make the booking funnel measurable. This is the release gate for sprints 15–18.

Depends on: sprints 15–18. Findings X9, X10, X11. All journeys. No backend.

## Acceptance

### Accessibility (WCAG 2.2 AA)

- [ ] Every interactive element has a semantic label, role, and state; decorative images are excluded. Audit table (screen × issue × fix) recorded in Status — all 55 view files covered.
- [ ] 200% text scale: no clipping or overflow on Home, Detail, Seats (list mode), Checkout, Success, Bookings, QR, Profile, in English and Khmer. Khmer uses a taller line height token (`AppText` khmer variant) so subscripts aren't cut.
- [ ] Touch targets ≥ 48 × 48 dp (seats may be smaller visually but have 48 dp hit areas or list mode).
- [ ] Focus order follows reading order; no keyboard/switch-access traps in sheets and dialogs; dialogs return focus to the trigger.
- [ ] Hold countdown announces at 60 s and 10 s only (live region), not every second.
- [ ] Flutter's `meetsGuideline` checks (`androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`) pass in widget tests for every main screen.

### Performance

- [ ] Profile mode on a mid-range Android (record model): Home cold start, carousel swipe, poster → detail, detail → seats, seat pan/zoom, ticket flip — no frame over 16 ms on UI or raster thread (closes sprint 8's open box).
- [ ] Cold start to first Home frame ≤ 2.5 s on the same device (splash minimum 2 s stays).
- [ ] Images decoded at display size everywhere (`cacheWidth`); memory after 5 min browsing recorded.
- [ ] Shader warm-up decision recorded (Impeller on both platforms is the default; note any first-run jank).

### Telemetry

- [ ] `core/telemetry/journey_tracker.dart`: interface with `track(JourneyEvent)`; events `home_viewed`, `movie_opened`, `showtime_selected`, `seats_held`, `best_seats_used`, `hold_extended`, `snacks_skipped`, `checkout_viewed`, `pay_started`, `pay_succeeded`, `pay_failed`, `flow_abandoned(step)`, `ticket_opened(source)`. Properties are ids and step names only — **no PII** (no names, phones, emails, references).
- [ ] Default implementation logs in debug and no-ops in release; sink per decision D5. Registered in GetIt; views fire events through blocs, never directly.
- [ ] A debug **Funnel** panel in the gallery shows step counts for the current session.

### Consistency sweep

- [ ] State matrix (loading / empty / error / offline / success) filled for every screen and every gap fixed with sprint-15 components.
- [ ] Global connectivity banner (`InlineBanner`, slides down) when requests fail with `ApiFailureNetwork` twice in a row; hides on the next success.

## Tests

`meetsGuideline` per screen; 2.0 text-scale goldens (en, km) for the 8 main screens; tracker emits the expected sequence for a full P1 booking in a bloc-level integration test; no event carries PII (test inspects payload keys); reduced-motion sweep re-run over everything added in 15–18.

## Definition of done

Plan-level DoD in `experience-enhancement/PLAN.md`, plus: manual walk-through of all four persona journeys with TalkBack (Android) and VoiceOver (iOS), results and frame-chart screenshots referenced in Status.

## Out of scope

Choosing and integrating a commercial analytics vendor (D5), A/B testing, crash reporting SDK.
