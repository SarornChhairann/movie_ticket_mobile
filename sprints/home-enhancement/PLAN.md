# Home enhancement — sprints 20–22

Sprints 8, 10, 11, and 18 built Home piece by piece: greeting, Up next, search + filter sheet, coming-soon carousel, genre chips, "Now in Cinemas" rail, and the Halls list. Each piece works (shell + catalog: 102 tests green on 2026-10-07), but Home as a whole is not yet designed around its job: **get someone from opening the app to a showtime in as few taps as possible**, and let a regular feel at home.

This plan does **not** change price math, seat states, roles, or payment. Backend work is one additive change (G34). Same method as every sprint: contract check → UX → backend → Flutter → tests → demo. Principles 1–6 of `experience-enhancement/PLAN.md` still apply.

Read first: `sprints/README.md`, `experience-enhancement/PLAN.md` (journeys P1–P4), `sprint-10-home-halls`, `sprint-11-home-filters`, `sprint-18-ticket-wallet`.

## Home today

Top to bottom (`shell/view/shell_page.dart` `_HomeHeader` + `catalog/view/movie_home_view.dart`):

```
Offline banner (ShellCubit)        ← GET /  (full home payload, only list sizes used)
"Find your favourite movies!" + avatar
Up next card (sprint 18, conditional)
Search pill + filter sheet          ← GET /movies?tab=… ×2 on each debounced keystroke
Coming soon carousel  (hero slot)   ← GET /movies?tab=COMING_SOON
Genre chips
Now in Cinemas rail                 ← GET /movies?tab=NOW_SHOWING
Halls (grouped by cinema)           ← GET /api/halls
```

All of it is one non-lazy `ListView(children: …)`.

## Analysis — what holds Home back

Verified against source on 2026-10-07.

| # | Finding | Evidence | Impact |
| --- | --- | --- | --- |
| H1 | The hero slot sells movies you **cannot book**. The coming-soon carousel sits above the fold; the bookable "Now in Cinemas" rail is below it. | `movie_home_view.dart` `_Loaded`: carousel → chips → rail | P1 (guest, tonight's show) scrolls past a reminder carousel before seeing anything bookable. |
| H2 | No showtimes on Home. Booking is always Home → Detail → date → time → Seats. | `PosterCard` shows title + year·rating only. Backend already has `GET /api/movies?type=now_showing&date=` returning up to 4 `ShowtimeChip`s per movie (cached), unused by the app. | 2 extra taps on the most common path; nothing on Home answers "what can I watch tonight?". |
| H3 | Genre chips sit **between** the carousel and the rail but filter both, and never the halls. | `GenreChipRow` placed after the carousel; `HallListSection` ignores movie filters | Tapping a chip changes content above the user's eyes (off-screen); mental model is unclear. |
| H4 | Search has no results state. Typing filters the rails in place; the carousel collapses, the rail says "No movies", the halls show their own empty note. Every keystroke (debounced 300 ms) refetches **both** tabs. | `MovieListBloc._load`, `HallListSection._HallList` | Results are scattered over three sections; extra network on every query. |
| H5 | Redundant calls on open. `ShellCubit` downloads the full `GET /` payload (now showing, coming soon, hero movies, cinemas, featured movie) only to prove the API is up, then Home loads the same movies again. | `ShellRepository.fetchHome`, `HomeSummary` keeps 3 counts; `HomeController` returns `heroMovies` + `featuredMovie` | Slower first paint on 3G; the admin-curated `featuredMovie` is never shown. |
| H6 | Home is one eager `ListView(children:)`; the Halls section builds every hall row at once. | `movie_home_view.dart`, `hall_list_section.dart` (`Column` + `for`) | Cost grows with the hall count; risks sprint 19's "no frame > 16 ms" bar. |
| H7 | Offline cold start shows a full-screen error for movies. Only bookings are cached. | `MovieListFailure` → `ErrorView`; `BookingCache` is bookings/QR only | At the door with poor signal, Home is an error page (Up next still works, everything else does not). |
| H8 | Pull-to-refresh is partial: movies + halls only; Up next and the offline banner keep stale state. | `MovieHomeView.onRefresh` | "Pull to fix it" does not fix the banner or a just-bought ticket. |
| H9 | Home is impersonal: a static greeting, no memory of what the user looked at, no favourite hall. | `catalog.greeting` = "Find your favourite movies!" | P2 (regular, books weekly) re-navigates to the same hall every time. |
| H10 | Poster cards carry little decision info: no duration, genre, or format (Dolby/ScreenX availability). | `PosterCard.meta` = year · rating | Users must open Detail to decide. |
| H11 | Home is not measurable per section. `home_viewed` fires only on `RefreshRequested`; `movie_opened` does not say which section it came from. | `JourneyEventName`, `MovieListBloc` | Cannot prove any change here helped. |

## Target Home

```
Offline banner · greeting by name/time of day · avatar
Up next (conditional)
Search pill → opens a dedicated results view
Featured hero (featuredMovie / heroMovies from GET /) ── Book
Date strip: Today | Tomorrow | Fri 10 | …
"Showing today" rail: poster + up to 4 time chips → tap a time = Seats
Genre chips (scoped to the rail directly below them)
Now in Cinemas rail (richer cards)
Your halls (favourites) · Recently viewed (local)
Coming soon carousel (Remind me)
Halls (lazy sliver)
```

## Sprints

| Sprint | Folder | Theme | Demo | Findings | Backend |
| --- | --- | --- | --- | --- | --- |
| 20 | `sprint-20-home-bookable` | Book from Home | Open app → tap "19:30" on a poster → seat map, in 2 taps | H1, H2, H3, H10 | G34 |
| 21 | `sprint-21-home-fast` | Fast and resilient Home | Cold start in airplane mode shows last Home with an offline note; one pull refreshes everything; frame chart green | H5, H6, H7, H8, H11 | — |
| 22 | `sprint-22-home-personal` | Personal Home and search | Greeting by name; favourite hall pinned; recently viewed rail; search shows one grouped results view | H4, H9 | — |

Order: 20 → 21 → 22. 21 can start in parallel with 20 once 20's sliver layout decision (D1) is made, since both touch `movie_home_view.dart`; do 20's layout move first.

## Backend gap register — additions

| # | Area | Current backend | Target | Sprint |
| --- | --- | --- | --- | --- |
| G34 ✅ | Today's showtimes on Home | `GET /api/movies?type=now_showing&date=` returns `ShowtimeChip(showtimeId, time)` — no hall name, includes showtimes that already started today, cached per date (so a cached entry keeps serving started times) | `ShowtimeChip` adds `showDate`, `hallName`, `cinemaName`, `hasDolbyAtmos`, `hasScreenX`; the movie adds `genre`, `durationMinutes` (all additive). Started showtimes (cinema zone) are dropped and the 4-chip cap applied **after** the cache read. `MovieBrowseApiControllerTest`. | 20 |

## Decisions to confirm

| # | Question | Default (works without approval) | Alternative |
| --- | --- | --- | --- |
| D1 | Section order | Target Home above: bookable first, coming soon below "Now in Cinemas" | Keep the carousel on top, add the Today rail under it |
| D2 | Hero source | `featuredMovie` / `heroMovies` from the `GET /` the app already calls (H5) | Drop the hero; first section is the date strip |
| D3 | Date strip length | Today + next 6 days, cinema zone (`CinemaClock`) | Today / Tomorrow only |
| D4 | Offline catalog cache | JSON file in the documents folder via `path_provider` (already a dependency); movies + halls + Home payload, max one copy | No cache; keep `ErrorView` |
| D5 | Favourites storage | Device-only (same file store as D4); no account sync | Backend favourites table (new endpoints; out of scope here) |
| D6 | Recently viewed | Last 10 movie ids opened on this phone, device-only, cleared on sign-out | Omit |

## Out of scope

Recommendations/ML ranking, push notifications, server-side favourites, promotions/banners CMS, home-screen widgets (D6 of the experience plan).
