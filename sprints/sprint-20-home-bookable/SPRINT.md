# Sprint 20 — Book from Home

## Goal

Home answers "what can I watch today, and when?" and a guest reaches the seat map in two taps: poster time chip → seats.

Depends on: sprint 10 (halls), 11 (filters), 18 (Up next). Findings H1, H2, H3, H10 in `home-enhancement/PLAN.md`. Journeys P1, P2. Backend: G34. Decisions D1, D2, D3.

## Acceptance

- [x] **Order (D1):** Home reads greeting → Up next → search → featured hero → date strip → "Showing today" rail → genre chips → Now in Cinemas → Coming soon carousel → Halls. Coming soon is below the first bookable section on a 360×640 screen.
- [x] **Featured hero (D2):** one wide banner from `featuredMovie` (falls back to the first of `heroMovies`) with title, rating, and **Book** (opens Detail). Hidden when the API has neither. Reuses the `GET /` call `ShellCubit` already makes — no new request.
- [x] **Date strip (D3):** Today, Tomorrow, then weekday + day for 5 more days, in the cinema zone (`CinemaClock`, contract 4). Selecting a date reloads only the Showing rail.
- [x] **Showing rail:** each card is poster + title + up to 4 time chips (`HH:mm`, tabular). Tapping a chip opens the seat map (`SeatMapArgs` with `showtimeId`, `date`, `posterUrl`, and the movie's other chips as `options`) and logs `showtime_selected` with `source: home`. Tapping the poster opens Detail. Times that have started are never shown (G34). Empty date → "No shows on {date}" with the next date that has shows.
- [x] **Genre chips** move directly above the rail they filter (Now in Cinemas) and stop filtering the coming-soon carousel. The filter sheet keeps its current scope.
- [x] **Richer poster card (H10):** meta line is `duration · rating`, then genre; a small Dolby / ScreenX badge when any of today's showtimes has it (only if the data is on the response — no invented flags).
- [x] Every new string in `en.json` and `km.json`; money/dates only via `context.showLine` / locale format helpers.

## API contract

| Call | Use | Change |
| --- | --- | --- |
| `GET /` | Featured hero (`featuredMovie`, `heroMovies`) | None — `HomeResponseDto` adds the two fields |
| `GET /api/movies?type=now_showing&date=YYYY-MM-DD` | Showing rail | **G34:** `ShowtimeChip` adds `hallName`; started showtimes filtered after the cache read |
| `GET /movies?tab=…` | Now in Cinemas, Coming soon | None |

Backend test: `MovieBrowseApiControllerTest` — chip has `hallName`; a showtime 1 minute in the past (cinema zone) is absent even when the date is already cached.

## UX

Copy: `home.featured.book`, `home.dates.today`, `home.dates.tomorrow`, `home.showing.title` (`Showing {date}`), `home.showing.empty` (`No shows {date}`), `home.showing.nextDate` (`See {date}`), `home.showing.slot` (screen-reader label of a time chip), reused `catalog.duration` (`{minutes} min`).

Motion: date change crossfades the rail (`Motion.medium`); time chips use `AppChip` with the theme press scale and `AppHaptics.selection`. Reduced motion: instant swap.

## Flutter

- `catalog/model/dto/browse_dtos.dart` (`MovieBrowseDto`, `ShowtimeChipDto`), mapper → `TodayMovie { Movie movie; List<ShowtimeSlot> slots }`.
- `CatalogRepository.fetchShowing(DateTime date)`.
- `catalog/controller/showing_cubit.dart` — `initial | loading | ready(date, movies) | failure`, `dateSelected(DateTime)`.
- `catalog/view/featured_hero.dart`, `date_strip.dart`, `showing_rail.dart`, `showtime_chip_row.dart`.
- `shell/model/home_summary.dart` gains `featured: Movie?` (keep the counts).
- `movie_home_view.dart`: new order; `GenreChipRow` moved; carousel ignores `genre`.

## Tests

- Mapper: chip parsing, missing `hallName` tolerated, string/number times.
- `ShowingCubit`: date change, failure keeps previous date's list, empty → next date.
- Widget: tapping a time pushes the seat route with the right `SeatMapArgs`; started times hidden; chips stop filtering the carousel; hero hidden without data.
- Goldens: Home in en/km (update `test/helpers/screens.dart`).
- Backend: G34 test above (`./mvnw test`).

## Out of scope

Seat availability per chip ("almost full"), price on chips, city/cinema picker on Home (filter sheet keeps that role).

## Status

Done 2026-10-07 in code. Backend 138 tests green (3 new); Flutter 521 green, analyze clean. **Not done:** the demo on a device against a running API (the API was not running here).

- **Backend G34:** `ShowtimeChip` adds `showDate`, `hallName`, `cinemaName`, `hasDolbyAtmos`, `hasScreenX`; `MovieBrowseResponse` adds `genre` and `durationMinutes` (all additive; nothing else reads this endpoint). The cache keeps every chip; `upcoming()` drops started showtimes (cinema zone) and caps at four **after** the cache read, and drops movies left with none. Tests: fields present, a cached day stops serving a started time, cap applied after dropping.
- **Hero:** from the `GET /` the shell already pings (`HomeSummary.featured`: `featuredMovie`, else the first `heroMovies`); no new request. Hidden when neither exists or the ping failed.
- **Showing:** `ShowingCubit` (strip = 7 cinema-clock days; stale answers for a date the user left are dropped). An empty day looks ahead on the strip only, stops at the first hit or failure, and offers **See {date}**. A time chip logs `showtime_selected {movieId, showtimeId, source: home}` and opens the seat map with the day's other times as options. Pull to refresh reloads it too.
- **Chips scope:** genre chips sit above Now in Cinemas; on Home the filter sheet's movie filters now apply to that rail only. The coming-soon carousel and the Showing rail are never filtered by them (search still narrows the carousel). Explore is unchanged.
- **Poster card:** `duration · rating` (the year when there is no duration), then genre. Rail height +20; Explore grid aspect 0.52 → 0.48. Dolby/ScreenX badges are on Showing cards only — `/movies` has no hall data, so Now in Cinemas posters get none.
- **Deviations:** no `+{count}` chip (the server caps at four and sends no total; the card opens Detail for the rest). Showing cards size to their content and share the tallest height (`IntrinsicHeight` row, not lazy) so wrapped time chips never clip at 200% text or in Khmer — a fixed-height first version overflowed in Khmer at 200%.
- **Goldens:** no golden PNGs exist in this checkout (never committed), so the 38 golden tests fail before and after this sprint with "non-existent file". The 200% text tests still run their overflow check first: no overflow on any screen. Record them on purpose with `flutter test --update-goldens test/goldens test/accessibility` and review.
