# Sprint 21 — Fast and resilient Home

## Goal

Home paints fast, scrolls without jank at any hall count, still shows something useful with no signal, and one pull refreshes all of it. Every Home section is measurable.

Depends on: sprint 20 (new section order). Findings H5, H6, H7, H8, H11. Journeys P1, P4. Decision D4. No backend change.

## Acceptance

- [x] **Slivers (H6):** Home is a `CustomScrollView`; Halls render through `SliverList.builder` (cinema headers as items), so off-screen hall rows are not built. Rails stay horizontal `ListView.builder`s.
- [x] **One request plan (H5):** `GET /` is the connectivity check **and** the hero source (sprint 20); no other caller fetches it. Search-only changes do not refetch halls or the Showing rail.
- [x] **Offline Home (H7, D4):** after a successful load, the Home payload, both movie lists, today's Showing rail, and halls are written to one JSON file in the documents folder. On `ApiFailureNetwork` at cold start, Home renders that copy with `OfflineNote` ("Saved on this phone · updated {time}"); time chips are disabled offline with a hint. No cache → today's `ErrorView`. Cache is overwritten, never appended; cleared with app data only (it holds no personal data).
- [x] **Per-section failure:** a failed section shows an inline `InlineBanner` with Retry in its own slot; the other sections stay. No full-screen error on Home.
- [x] **One pull refreshes all (H8):** `HomeRefresh` fires movies, Showing, halls, `ShellCubit.pingRequested`, and `UpNextCubit.load`, and the indicator stays until all settle.
- [ ] **Telemetry (H11):** *(all but the manual gallery check — see Status)* `home_viewed` fires once per Home visit (tab select or cold start), not on refresh. `movie_opened` and `showtime_selected` carry `source` (`hero | showing | now | comingSoon | hall | search | recent`). Verified in the `/_gallery` funnel panel.
- [ ] **Performance:** profile build on a mid-range Android, scroll Home top→bottom with 50 halls: no frame over 16 ms in the raster or UI thread; result recorded in Status.

## API contract

No new calls. Same as sprint 20.

## UX

Copy: reused `ticket.savedOffline` (`Saved on this phone · updated {time}`) and `common.retry`; new `home.offline.timesDisabled`.

## Flutter

- `catalog/model/home_cache.dart` — read/write one JSON file (`path_provider`), versioned (`{"v":1, "savedAt":…}`); corrupt or old version → ignored.
- Repositories fall back to `HomeCache` only on `ApiFailureNetwork` (same rule as `TicketsRepository` + `BookingCache`).
- `catalog/view/home_refresh.dart` — `Future<void> refreshHome(BuildContext)` awaiting each bloc's next settled state.
- `movie_home_view.dart` → slivers; `hall_list_section.dart` → `SliverHallList`.
- `core/telemetry/journey_tracker.dart` — `source` property; `MovieDetailArgs` / `SeatMapArgs` carry it.

## Tests

- `HomeCache`: round trip, corrupt file, version mismatch, overwrite.
- Repository: network failure → cached value with `fromCache: true`; server failure → no fallback.
- Widget: airplane cold start shows cached rails + `OfflineNote`; chips disabled offline; one section failing leaves others visible; pull triggers all five loads.
- Telemetry: `home_viewed` once per visit; `source` on events from each section.
- Lazy halls: with 200 halls, fewer than 30 hall rows are built on first frame.

## Out of scope

HTTP-level caching/ETags, image disk cache package (needs approval), background refresh.

## Status

Done 2026-10-07 in code, except two manual boxes. Flutter 549 green (31 new), analyze clean. No backend change.

- **Saved copies:** `Ok` gained an optional `savedAt` (`core/network/result.dart`): set when a value is the copy saved on this phone. `HomeCache` (`core/storage/home_cache.dart`, one versioned JSON file in the documents folder) keeps the raw server JSON per read: `home` (only `featuredMovie` + first hero movie, not the whole catalog), `movies.NOW_SHOWING|COMING_SOON` (unfiltered only), `showing.<date>` (latest 7 days), `halls`. Writes are queued so parallel Home loads never lose a key; a corrupt or other-version file is ignored, then overwritten. `CatalogRepository`, `HallRepository`, `ShellRepository` fall back only on `ApiFailureNetwork`; an offline search filters the saved list by title.
- **Offline Home:** `ShellState.ready(savedAt:)` shows `OfflineNote` ("Saved on this phone · updated 18:40") under the greeting instead of the error banner; with nothing saved the old banner shows. Showing time chips are disabled with "Times can be booked when you're back online."; an offline empty day does not look ahead over the network.
- **Slivers:** Home is one `CustomScrollView`; Halls is a `SliverMainAxisGroup` whose rows come from `SliverList.builder` (cinema headers as items). Test: 200 halls → under 30 rows built.
- **Per-section failure:** movies and halls fail with an inline `InlineBanner` + Retry in their own slot (Showing already did); no `ErrorView` on Home. Explore keeps its `ErrorView`.
- **One pull:** `RefreshRequested` on `MovieListBloc` and `HallListBloc` takes an optional `Completer` completed when the load settles (even when the state does not change); Home waits for movies, halls, `ShowingCubit.load`, and the shell's part (`ShellCubit.pingRequested` + `UpNextCubit.load`). Tested: the spinner stays until the last one.
- **Requests:** `GET /` is called only by `ShellCubit`; search refetches only the movie lists (halls and Showing are filtered or unaffected client-side).
- **Telemetry:** `home_viewed` moved from `MovieListBloc` (it fired on every refresh) to `ShellCubit.homeViewed()`, called on cold start and on switching to Home, not when Home is re-tapped. `movie_opened` carries `source` from `MovieDetailArgs.trackingSource` (`hero`, `showing`, `now`, `comingSoon`, `explore`, `hall`); `showtime_selected` carries `source` `showing` (Home rail; was `home` in sprint 20), `detail`, or `hall` (`HallScheduleBloc` `ShowtimeChosen`). `search` and `recent` arrive with sprint 22.
- **Not done (manual):** the profile-build frame check on a mid-range Android with 50 halls, and the `/_gallery` funnel panel check — both need a device and a running API.
- Goldens are still unrecorded in this checkout: the same 38 golden tests fail with "non-existent file" as before; no overflow anywhere.
