# UI enhancement plan

Match the cinematic layout in [Movie Ticket Booking App | UI/UX](https://www.behance.net/gallery/235963731/Movie-Ticket-Booking-App-UIUX) (Firoz Diwan). Restyle the Flutter screens that already exist. Do not change price math, seat status, or auth.

Reference screens to follow: home rails, movie detail, seat selection. The case-study boards (process, color, type, grid) define the visual system. Do not copy poster artwork, actor photos, or review counts from the mock.

## Current gap

`AppTheme.light` is a light red Material theme. Home is an app bar, two tabs, a search field, and a vertical card list (`MovieListView`). Detail is a sliver app bar plus chips. The seat route is still a placeholder. Profile and login are separate light forms.

## Visual system

Use one dark theme. Remove the light theme from `MaterialApp`.

| Token | Value | Use |
| --- | --- | --- |
| Navy | `#1A2543` | Scaffold, cards, bottom bar |
| Blue | `#368DBD` | Selected chip, primary button, selected seat |
| Mist | `#F5F5F5` | Secondary text and search fill |
| White | `#FFFFFF` | Titles, icons, seat outline |

Type: Poppins. Headline for the home greeting, title for movie names, body for meta. Add the font under `assets/fonts` and set `textTheme` in `AppTheme`. Do not load a font from the network at runtime.

Spacing stays on the 8pt scale in `core/theme/spacing.dart`. Screen margin is 20, gap between poster cards is 16. Radius: 16 on search and cards, 24 on primary buttons, pill on chips.

Seat colors replace `SeatColors.light`:

| State | Look |
| --- | --- |
| Available | White outline on navy |
| Selected | Fill `#368DBD` |
| Booked | Filled muted white, not tappable |
| Held by others | Outline plus a dim fill, not tappable |
| Couple | Same states, wider seat |

The mock only shows Available, Selected, and Reserved. This app also has holds. Keep held visually different from booked.

## Navigation

Replace the shell app bar with a bottom bar: Home, Explore, Bookings, Profile.

| Tab | Screen |
| --- | --- |
| Home | Greeting, search, genre chips, two horizontal rails |
| Explore | Full list for the active genre or search, still backed by `MovieListBloc` |
| Bookings | Existing my-bookings route when that feature exists. Until then, an empty state with `tickets.empty`, not fake tickets |
| Profile | Existing `ProfilePage`, restyled |

Language toggle moves into Profile. The avatar on Home opens Profile. Guest avatar still opens login.

## Phase 1 — Theme

Files: `lib/core/theme/app_theme.dart`, `seat_colors.dart`, `lib/app.dart`, `pubspec.yaml`.

1. Dark `ColorScheme` from the four tokens. Primary `#368DBD`, surface `#1A2543`.
2. Poppins on `textTheme`.
3. Shared widgets: `SearchPill` (rounded field plus a filter icon button), `GenreChip`, `PosterCard`, `PrimaryButton`.
4. Update widget tests that assume a light scaffold or the old app-bar title.

Done when every current screen uses the dark theme and existing tests still pass.

## Phase 2 — Home and Explore

Files: `lib/features/shell/view/shell_page.dart`, `lib/features/catalog/view/movie_list_view.dart`, translation files.

Home layout, top to bottom:

1. Greeting `catalog.greeting` ("Find your favourite movies!") and the account avatar.
2. Search pill. Typing still sends `SearchChanged`. The filter button opens a sheet of genres already present on the loaded movies. It does not call a new API.
3. Horizontal genre chips: All, then distinct `movie.genre` values. All is selected by default. Chip selection filters the list in the bloc. Do not hard-code Drama, Romance, Thriller, and Action if the API did not return them.
4. Rail "Now in Cinemas" for `NOW_SHOWING`.
5. Rail "Upcoming movies" for `COMING_SOON`.
6. Each card: poster, title, year from `releaseDate` when present, rating text when present. No review count. The API does not have one.
7. "See all" switches to Explore with that tab and genre.

Explore keeps pull-to-refresh, empty, error, and loading. Cards can stay in a two-column grid instead of the old row list.

Copy keys go in `assets/translations/en.json` and `km.json` together.

Done when a cold start shows two rails, a genre chip hides non-matching titles, and opening a poster still routes to `AppRoutes.movieDetail`.

## Phase 3 — Movie detail

File: `lib/features/catalog/view/movie_detail_page.dart`.

1. Full-bleed banner (`bannerUrl`, else poster). Back button over the image.
2. Play button only when `trailerUrl` is non-null. It opens that URL. No button when there is no trailer.
3. Overlapping navy card: title, genre, duration, rating, synopsis with a "Read more" expansion. Cast is the existing string, shown as names, not generated face photos.
4. Date chips from `detail.availableDates`. Time chips from showtimes on the selected date, labeled with hall name because one day can have several cinemas.
5. Sticky "Book Ticket" stays disabled until a showtime is selected, then pushes `AppRoutes.seatMap` with that showtime id.

Do not put a dollar total on this screen. Price is still a server quote.

Done when Book Ticket cannot fire without a real showtime id, and the old sliver layout is gone.

## Phase 4 — Seat screen

Build this when sprint 3 starts. The placeholder route should already use the dark scaffold so it does not flash the light theme.

Layout:

1. Title "Select Seat" and a back button.
2. A thin "Screen" curve above the grid.
3. Seats from the API, one row per `rowNumber`. Couple seats render wider and still toggle as a pair.
4. Legend: Available, Selected, Reserved, Held.
5. Date and time chips show the showtime already chosen on the detail screen. Changing a chip loads that other showtime's map. It does not invent times.
6. Bottom bar: seat count, then "Book Ticket". Do not print `$22.00` or per-row prices (`$10`, `$15`, `$25`). Those prices are not in the domain. Normal and couple prices come from the showtime and the checkout quote.

Done when booked and held seats cannot be tapped, and the continue action only carries seats the server still holds.

## Phase 5 — Auth and profile

Restyle `login_page.dart`, `register_page.dart`, `splash_page.dart`, and `profile_page.dart` with the same navy, Poppins, and pill buttons. Keep every field, validation, and bloc event. Splash can be the navy wordmark only. Do not add an onboarding carousel the API does not need.

## Out of scope

- New endpoints, review counts, row-based pricing, or a second light theme.
- Checkout, payment, and QR layout. Those follow sprints 4–6 and reuse `PrimaryButton` and the dark surface when those screens are built.
- Admin UI.

## Order

Phase 1, then 2, then 3. Phase 4 waits for the seat feature. Phase 5 can land with phase 1. After each phase, run `flutter test` and check Home, detail, and Profile in English and Khmer.

## Status (2026-10-01)

All five phases landed. `flutter analyze` is clean and `flutter test` passes (176), including rewritten shell, catalog, detail, seat, and login widget tests that run on the dark theme (`test/helpers/localized_app.dart` now pumps `AppTheme.dark`).

- **Theme:** `AppTheme.dark` only (`app_colors.dart` holds the four tokens). Poppins Regular/Medium/SemiBold/Bold are bundled under `assets/fonts` with `OFL.txt`; nothing loads at runtime. Khmer text falls back to the system Khmer font (Poppins has no Khmer glyphs). Shared widgets: `PrimaryButton`, `SearchPill`, `GenreChip`, `Wordmark` in `core/widgets`, `PosterCard` in `catalog/view`.
- **Home / Explore:** `MovieListBloc` loads both tabs in one pass (`nowShowing`, `comingSoon`), keeps search shared, and filters by `GenreSelected` client-side. `TabChanged` no longer refetches. Genres are the distinct `movie.genre` values returned.
- **Detail:** `MovieDetailBloc` gained `ShowtimeSelected`; a new date clears it, unknown ids are ignored, so Book Ticket only fires with a real showtime id. The seat route now takes `SeatMapArgs` (a bare `int` still works).
- **Seat screen:** seats are outline / blue / muted-fill / dim-fill-plus-outline for available / selected / reserved / held. Time chips are the same day's showtimes passed from detail; picking another releases any hold and loads that map. No prices.
- **Navigation:** bottom bar Home / Explore / Bookings / Profile. Guests get sign-in prompts on Bookings and Profile (and never call `/bookings/my-bookings` or `/profile`); signed-in tabs reload on open. The language toggle lives in Profile.

Deviations:

- ~~Trailer play button copies the link~~ — resolved: `url_launcher` was added on request. The play button opens the trailer in the browser or video app (`core/platform/link_opener.dart`, http/https only); if nothing can open it, the link is copied and the user is told.
- **Seat-screen date chip** is display-only: the seat map has the chosen day's showtimes but not other days'.

Still to do: a look on a real device or emulator in English and Khmer (screens were checked as rendered test images with the bundled font, English only).

## Splash (2026-10-01)

- **No white flash:** Android (`launch_background`, `NormalTheme`, Android 12+ `values-v31` system splash) and the iOS `LaunchScreen.storyboard` are brand navy `#1A2543`, the same as the Flutter scaffold.
- **"Admit one" animation** (`features/auth/view/splash_page.dart`, 1.4 s): a projector beam fades in, the ticket emblem (`core/widgets/ticket_emblem.dart`, also used by `Wordmark`) traces its outline, fills blue with a perforation and play glyph, then the name and the `splash.tagline` rise in.
- **Minimum display 2 s** (`SplashPage.minDisplay`, passed to `App.splashMinDisplay`): the 1.4 s animation plays in full plus a short hold, even when the session restores instantly. A slower restore leaves as soon as it finishes, with no extra wait. A thin progress bar appears only if restoring is still running at 2.4 s, so a normal start never shows a spinner. Root screens (splash, login, home, blocked) now fade into each other instead of sliding.
- **Accessibility:** with reduced motion the final frame shows at once. The name is read once, as a header; the emblem and beam are decorative; the progress bar is a live region ("Getting things ready…").
