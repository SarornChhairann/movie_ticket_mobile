# Sprint 2 — Catalog

## Goal

Guest and customer can browse now-showing and coming-soon movies, search, open a movie, pick a date and a showtime grouped by cinema/hall.

Depends on: sprint 1. Analytics sections 3.2 and 7. Gap rows G5, G6, G7.

## Acceptance

- [x] Movie list has two tabs, `NOW_SHOWING` and `COMING_SOON`. `ARCHIVED` never appears.
- [x] Search filters the current tab by title (server-side `search`).
- [x] Detail shows title, poster/banner, genre, duration, rating, language, format, director, cast, description, trailer link.
- [x] Now-showing detail shows a date strip (`availableDates`) and, for the selected date, showtimes grouped by cinema → hall. Blocked and already-started showtimes are not shown.
- [x] Coming-soon detail shows release date and no showtimes (reminder button arrives in sprint 7).
- [x] Empty and error states use the sprint 0 widgets.
- [x] Tapping a showtime navigates to the seat route with `showtimeId` (placeholder page until sprint 3).

*Verified by backend `MovieControllerTest` and Flutter mapper/repository/bloc/widget tests; a cold-start walk-through on an emulator against seeded data is still pending.*

## API contract

| Call | Request | Response used |
| --- | --- | --- |
| `GET /movies` | `tab=NOW_SHOWING\|COMING_SOON`, optional `search`, `city` | `movies: Movie[]` (ignore the other filter fields for now) |
| `GET /movies/{id}` | optional `date=YYYY-MM-DD`, `city`, `cinemaId` | `movie`, `availableDates`, `selectedDate`, `showtimesByDate: { "YYYY-MM-DD": ShowtimeSummary[] }` |
| `ShowtimeSummary` | — | `id, showTime, hallId, hallName, normalPrice, couplePrice, blocked` + (this sprint) `cinemaName, hasDolbyAtmos, hasScreenX` |
| `Movie` | — | `id, title, description, genre, director, language, format, cast, trailerUrl, rating, releaseDate, durationMinutes, status, imagePath, bannerPath` |

Why not `GET /api/movies`: it requires `type` plus `date` (now showing) or `month` (coming soon) and returns a home-page browse with at most four showtime chips (G5). Why not `/api/showtimes/search`: `date` is required and it returns no date, hall id, or blocked flag (G6). Keep both endpoints; the app does not use them in v1.

## Step 1 — UX/UI

1. Screens: Movie list (tabs + search field), Movie detail, Showtime picker (date strip + grouped chips; can be a section of detail).
2. Cards: poster, title, genre, duration. Detail: banner, metadata, trailer link (copy-to-clipboard in this sprint; opening it externally needs `url_launcher`, which is not on the package list — ask before adding it).
3. Showtime chip: time, hall name, Dolby / ScreenX flags, normal price as a hint (formatted only).
4. Keys under `catalog.*`: `catalog.nowShowing`, `catalog.comingSoon`, `catalog.search`, `catalog.duration`, `catalog.releaseDate`, `catalog.noShowtimes`, `catalog.trailer`.

## Step 2 — Backend

1. `GET /movies` already filters by `tab` → `MovieStatus`, so `ARCHIVED` only appears for `tab=ARCHIVED`. Confirm with a test; no code change expected.
2. `MovieController.ShowtimeSummary`: add `cinemaName` (`hall.cinema.name`, fall back to `hall.city`), `hasDolbyAtmos`, `hasScreenX`. Additive fields only (G6).
3. Customer view of `/movies/{id}`: exclude `blocked` showtimes and showtimes whose `showDate + showTime` is before now (cinema zone) from `showtimesByDate` and `availableDates`. Keep the change inside the controller mapping; admin uses its own endpoints.
4. Make sure the `findByMovieIdWithHall` query fetches `hall.cinema`, so the new field does not trigger a lazy load outside the transaction (the method is already `@Transactional(readOnly = true)`).
5. Do not require auth.
6. Tests: archived movie not in `tab=NOW_SHOWING`; blocked and past showtimes absent from detail; `cinemaName` present.

## Step 3 — Frontend

Feature `catalog`:

1. DTOs: `MovieDto`, `MovieListResponseDto` (only `movies`), `MovieDetailResponseDto`, `ShowtimeSummaryDto`. Prices parsed from JSON number.
2. Entities: freezed `Movie`, `ShowtimeSlot(id, time, hallId, hallName, cinemaName, dolby, screenX, normalPrice)`, `CinemaGroup(cinemaName, halls: [HallGroup(hallName, slots)])`.
3. Mapper: groups the selected date's slots by cinema then hall, sorted by time; builds absolute poster URLs from `API_BASE_URL + imagePath` (G7); filters out `blocked` defensively.
4. `CatalogRepository` (lazy singleton) + `MovieListBloc` (`TabChanged`, `SearchChanged` debounced 300 ms, `RefreshRequested`) + `MovieDetailBloc` (`DetailRequested(id)`, `DateSelected(date)`).
5. Views only render state. Showtime tap pushes `AppRoutes.seatMap` with `showtimeId` as the argument.
6. Cache nothing beyond the bloc lifetime in this sprint.

## Step 4 — Testing

1. Bloc tests: list success, empty, failure; tab switch reloads; search debounce emits one request.
2. Mapper test: grouping by cinema/hall and time order; blocked slot dropped; poster URL absolute.
3. Repository test (Dio mock adapter): `tab` and `search` query params sent; error maps to failure.
4. Widget test: tapping a showtime pushes the seat route with the id.
5. Backend tests from step 2.

## Definition of done

A user reaches a showtime id from a cold start without logging in, on an emulator against seeded data. Tests pass on both sides.

## Out of scope

Seat map, holds, price breakdown, reminders (sprint 7), city/cinema picker (keep `city` param plumbing only).
