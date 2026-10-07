# Sprint 22 — Personal Home and search

## Goal

A regular opens the app and sees *their* Home: greeted by name, their hall pinned, the movies they were considering one tap away. Search gives one clear results view instead of scattering results across three sections.

Depends on: sprint 21 (`HomeCache` file store, telemetry `source`). Findings H4, H9. Journeys P1, P2. Decisions D5, D6. No backend change.

## Acceptance

- [x] **Greeting (H9):** signed in → "Good evening, {firstName}" by cinema-zone time of day (morning < 12, afternoon < 18, evening otherwise); guest → the same without the name. Name from the profile already loaded by `AuthBloc`/`ProfileBloc`; no extra call.
- [x] **Favourite halls (D5):** a heart on hall rows and on the hall schedule page. Favourites show as a "Your halls" row on Home (chips with the hall's next showtime today when known), above the full Halls list. Stored on this phone only; survives restarts; cleared on sign-out.
- [x] **Recently viewed (D6):** opening a movie's Detail records its id (last 10, newest first, de-duplicated). Home shows a "Recently viewed" rail when there are ≥ 2 and they are still in the loaded movie lists; archived/missing ids are dropped silently. Cleared on sign-out.
- [x] **Search results view (H4):** focusing the search pill opens a full-height results view over Home (shared-axis Z). Groups: **Movies** (now showing, then coming soon, with status chip) and **Halls**, from the data already loaded plus the existing debounced `GET /movies?search=`. Empty → one empty state with "Clear search". Back/clear returns to the untouched Home; Home rails are no longer filtered by search.
- [x] Recent searches (last 5, device-only) shown when the query is empty; tap to re-run; clear-all.
- [ ] All copy in `en.json` and `km.json` (done); Khmer greeting reviewed by a native speaker (manual, open).

## API contract

No new calls. Reuses `GET /movies?tab=&search=`, `/api/halls`, `/api/halls/{id}/showtimes`.

## UX

Copy: `home.greeting.morning|afternoon|evening` (`Good evening, {name}` and a no-name variant), `home.yourHalls`, `home.recent`, `hall.favourite.add|remove` (semantics labels), `search.title`, `search.movies`, `search.halls`, `search.recent`, `search.clearRecent`, `search.empty`.

Motion: heart toggle uses `AppHaptics.light` and a scale pop (reduced motion → none); results view enters with shared-axis Z.

## Flutter

- `catalog/model/local_prefs_store.dart` — favourites, recent movie ids, recent searches in the sprint 21 documents-folder JSON store (separate file from `HomeCache`), wiped by the sign-out path that already clears `BookingCache`.
- `catalog/controller/favourite_halls_cubit.dart`, `recently_viewed_cubit.dart`.
- `catalog/view/search_results_page.dart` (+ `SearchResultsBloc` or reuse `MovieListBloc` search with a separate instance so Home rails stay unfiltered).
- `shell/view/shell_page.dart` `_HomeHeader` → time-of-day greeting.
- `MovieListBloc`: Home instance no longer applies `search`; Explore keeps its own search.

## Tests

- Greeting table: hours × signed-in/guest, cinema zone vs device zone.
- Store: add/remove favourite, recent cap 10 + de-dup, sign-out wipe, corrupt file.
- Widget: heart toggles and "Your halls" appears; recent rail hides < 2 and drops missing ids; search view groups and empty state; Home rails unchanged after a search; semantics labels on hearts.
- Goldens: Home with favourites + recent in en/km; search results in en/km.

## Out of scope

Account-synced favourites (needs backend), personalised ranking, search suggestions from the server.

## Status

Done 2026-10-07 in code, except the native-speaker review of the Khmer greeting. Flutter 612 green (63 new), analyze clean. No backend change.

- **Device store:** `LocalPrefsStore` (`catalog/model/local_prefs_store.dart`, `local_prefs.json` in the documents folder, versioned, writes queued, a corrupt/other-version file reads as empty) holds favourite hall ids, recent movie ids (10, newest first, de-duplicated), and recent searches (5, case-insensitive de-dup). It broadcasts `changes`, so every cubit over it follows. `AuthBloc` wipes it with `BookingCache.clearAccount()` on sign-out and session end.
- **Greeting:** `shell/model/greeting.dart` — `dayPartAt` uses `CinemaClock` (UTC+7) whatever the phone zone; the first name comes from `AuthAuthenticated.user`; keys `home.greeting.<part>.named|plain`. `ShellPage(clock:)` is injectable. `catalog.greeting` is gone.
- **Favourites:** `FavouriteHallsCubit` (Home instance `load(withTimes: true)` asks `GET /api/halls/{id}/showtimes?date=today` per favourite for the next time after now; failures leave it unknown; pull to refresh reloads them). `FavouriteHeart` (tooltip = `hall.favourite.add|remove`, selected state, `AppHaptics.light`, overshoot pop, none under reduced motion) on hall rows and the hall schedule app bar; `YourHallsRow` chips above the Halls header open the schedule.
- **Recently viewed:** the movie detail route records the id through `RecentlyViewedCubit.viewed`; Home's rail (after Showing) resolves ids against Home's unfiltered lists with `recentMovies()` and hides below 2. Posters use `HeroSource.recent` → `movie_opened.source = recent`.
- **Search:** Home's pill (`HomeSearchEntry`, read-only `SearchPill(onTap:)`) pushes `AppRoutes.search` (new `RouteMotion.sharedAxisZ`) with a `SearchSeed` of Home's loaded lists and halls. `SearchResultsBloc` matches titles locally at once, then the debounced `GET /movies?tab=&search=` replaces them (a failure keeps the local matches); halls match name/cinema/city. Empty → one `EmptyState` with "Clear search". Results/recent taps and the keyboard search remember the query. Movie results use `HeroSource.search` → `source = search`.
- **Unfiltered Home:** Explore has its own `ExploreMovieListBloc` (subclass, own search); Home's `MovieListBloc` never gets a search, and Halls are no longer filtered by search (`home.halls.searchEmpty` removed). "See all" carries Home's genre/language/rating to Explore.
- **Fix found by the 200% check:** poster rails now grow their text area with the text scale (a card with a meta line overflowed by 4–19 px).
- **Goldens:** recorded only the new ones (`screen_homePersonal`, `screen_search`, their `_km`, and `text200_homePersonal|search_en|km`); the same 38 older goldens are still unrecorded in this checkout.
