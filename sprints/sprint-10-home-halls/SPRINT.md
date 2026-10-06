# Sprint 10 — Home hall list

## Goal

Home keeps the greeting, search, coming-soon carousel, genre chips, and **Now in Cinemas** rail. Under that rail, a **Halls** section lists every hall, grouped by cinema, as a vertical list. A row opens that hall’s bookable showtimes. A time opens the existing seat map.

Depends on: sprint 2 catalog (movie home, movie detail, `SeatMapArgs`) and sprint 8 motion (skeletons, reduced motion). Analytics section 3.2. No price math, no new seat status, no new role.

The customer app does not call `/admin/halls`. That route stays `ROLE_ADMIN`.

## Acceptance

- [x] Home still shows, in this order: greeting, search, coming soon (hidden when empty), genre chips, **Now in Cinemas**, then **Halls**.
- [x] **Halls** is a vertical list under the movie rail, grouped by cinema. Each group header is the cinema name and the city. Each row is one hall: name, type, Dolby Atmos when `hasDolbyAtmos` is true, ScreenX when `hasScreenX` is true, and the seat count.
- [x] The home search filters hall name, cinema name, and city. Genre chips do not hide halls.
- [x] A movie-list failure does not remove the hall section. A hall-list failure does not remove the movie sections. Each section has its own retry.
- [x] Pull to refresh reloads movies and halls. First load shows hall-row skeletons in the list layout. Later refreshes keep the rows on screen.
- [x] Tapping a hall opens its schedule: date chips, then that date’s movies and times. Blocked showtimes and showtimes that have already started are absent. Times stay cinema-local (`Asia/Phnom_Penh`); the app does not shift them with the device zone.
- [x] Tapping a time opens the existing seat map with `SeatMapArgs` for that showtime and the other times on the same date at that hall. This page does not place a hold and does not compute a total.
- [x] A missing hall is `404`. Guest and customer can both read the list and the schedule.
- [x] Copy keys exist in `en.json` and `km.json`.

*Verified by backend `HallApiControllerTest` (H2 + MockMvc, anonymous: order, cinema fields, no coordinates; blocked and started shows dropped; first bookable date selected; unknown hall `404` without `code`) and Flutter hall mapper, repository, bloc, Home-section, and schedule-page tests plus the reduced-motion sweep. Notes: the section title key is `home.halls.title` (nested JSON cannot hold `home.halls` as both text and parent); `hall.schedule.normalPrice` / `hall.schedule.couplePrice` label the per-showtime prices; `HallListBloc` is created in the shell route next to `MovieListBloc` (no `GetIt` in widgets) and `MovieHomeView` reads it from context.*

## Journey

```
Home
  greeting
  search
  Coming soon
  genre chips
  Now in Cinemas          (horizontal posters, unchanged)
  Halls                   (vertical, grouped by cinema)
      cinema name · city
      hall row
      hall row
  → tap hall
      Hall schedule
          cinema, city, type, flags, amenities
          date chips
          movie + time chips for the selected date
      → tap a time
          existing seat map → existing hold / checkout
```

## What the screen shows

Seed data is 6 cinemas × 3 halls. Hall names already look like `Legend Sen Sok · Atmos`. Cinema names are the full Khmer names (`រោងភាពយន្ត Legend Aeon Sen Sok`). Group by `cinemaId` so the long cinema name is the header and the hall name is the row.

| Piece | Source field | Rule |
| --- | --- | --- |
| Group header | `cinemaName` | One header per cinema. Sort groups by cinema name, then halls by hall name. |
| City | `city` | Once under the header when every hall in the group shares it. If a hall’s city differs, show that city on the row. |
| Type | `type` | `ATMOS` and `STANDARD` use translation keys. Any other value is shown as the server sent it. |
| Dolby / ScreenX | `hasDolbyAtmos`, `hasScreenX` | Badge only when true. Seeded halls set Dolby on the Atmos plan and leave ScreenX false. |
| Seats | `totalSeats` | Format with `home.halls.seats`. Do not derive a price from it. |
| Amenities | `amenities` | Hall schedule only, as stored. Do not translate or split the string. |

Empty search: the **Halls** header stays, with `home.halls.searchEmpty`. An empty catalog uses `home.halls.empty`.

## Backend

`/api/**` is already public. Add the two reads below. Do not change `AdminHallController.HallResponse`.

### 1. List

`GET /api/halls`

Join-fetch `hall.cinema` inside the read transaction. Order by cinema name, then hall name.

```
[
  {
    "id": 1,
    "name": "Legend Sen Sok · Atmos",
    "type": "ATMOS",
    "city": "ភ្នំពេញ",
    "address": "...",
    "totalSeats": 60,
    "hasDolbyAtmos": true,
    "hasScreenX": false,
    "amenities": "Dolby Atmos, អេក្រង់ 4K, កៅអីរាងអង្គុយ",
    "cinemaId": "<uuid>",
    "cinemaName": "រោងភាពយន្ត Legend Aeon Sen Sok",
    "openingHours": "09:00 - 23:00"
  }
]
```

`openingHours` comes from the cinema. Leave latitude and longitude off this payload.

### 2. Schedule

`GET /api/halls/{id}/showtimes?date=YYYY-MM-DD`

`date` is optional.

| Field | Value |
| --- | --- |
| `hall` | The same object as one list row |
| `availableDates` | Dates that still have a bookable show at this hall, ascending |
| `selectedDate` | The query date when it is in `availableDates`; otherwise the first available date; `null` when none |
| `showtimes` | Bookable rows on `selectedDate`, ordered by `showTime` |

A showtime is bookable when `blocked` is false and `showDate` + `showTime` is still in the future in `Asia/Phnom_Penh`. This is the same customer rule as `GET /movies/{id}` (sprint 2). An unknown id is `404` with `{error, type}` and no `code`.

Each showtime:

| Field | Notes |
| --- | --- |
| `id` | Showtime id. This is what the seat map loads. |
| `showDate` | ISO date |
| `showTime` | `HH:mm[:ss]` |
| `movieId`, `movieTitle`, `imagePath` | `imagePath` stays relative (`/uploads/movies/...`). The app prefixes `API_BASE_URL`. |
| `normalPrice`, `couplePrice` | JSON numbers, the showtime’s own prices. The view formats them. It does not add them. |

### Tests

1. List returns every hall with `cinemaName` and `openingHours`, ordered by cinema then hall, with the cinema join fetched.
2. Schedule drops a blocked show and a show whose start is already past, and orders the rest by time.
3. Omitting `date` selects the first remaining bookable date.
4. Unknown hall id is `404`.

## Flutter

Feature folder: `catalog` (home already lives there). One bloc for the home section, one for the hall page.

1. DTOs match the JSON above. Entities are freezed. Mapper builds absolute poster URLs and groups rows by `cinemaId` without changing order.
2. `HallListBloc`: `LoadRequested`, `RefreshRequested`. States: `initial`, `loading`, `ready`, `failure`. Register a factory in GetIt. `MovieHomeView` provides it.
3. Place the section **after** the movie `BlocBuilder`, as its own builder, so the two failures stay separate. The existing `RefreshIndicator` also sends `RefreshRequested` to `HallListBloc`.
4. Read the current search string from `MovieListBloc` and filter the ready list in the hall builder (name, cinema name, city, case-insensitive). Do not send genre into this filter.
5. `HallScheduleBloc` loads `GET /api/halls/{id}/showtimes` and reloads on `DateSelected`. Route name `hallSchedule`, argument the hall id.
6. Time chip → existing `AppRoutes.seatMap` with `SeatMapArgs(showtimeId, date, options)`. `options` are the showtimes on the selected date at this hall (`id`, `HH:mm`, this hall’s name). Poster or title → existing movie detail.
7. Skeletons use the same motion tokens as Home. Reduced motion still shows the final list.
8. Keys: `section.halls`, `hall.{id}`, `hall.schedule`, `hall.date.{yyyy-MM-dd}`, `hall.showtime.{id}`.

### Copy

Add both languages in the same change.

| Key | English |
| --- | --- |
| `home.halls` | Halls |
| `home.halls.empty` | No halls yet |
| `home.halls.searchEmpty` | No halls match your search |
| `home.halls.seats` | `{count} seats` |
| `home.halls.type.atmos` | Atmos |
| `home.halls.type.standard` | Standard |
| `home.halls.dolby` | Dolby Atmos |
| `home.halls.screenX` | ScreenX |
| `hall.schedule.empty` | No showtimes on this date |
| `hall.schedule.amenities` | Amenities |

Khmer lives in `km.json` for the same keys. Cinema names, hall names, cities, and amenities stay as the API returned them.

### Tests

1. Mapper groups by cinema and keeps server order; poster URL is absolute; a blocked row is dropped if the payload still contains one.
2. `HallListBloc` emits ready and failure. Widget: section sits under `rail.nowShowing`; search hides a non-matching hall; a genre chip does not; movie failure still shows halls; hall failure still shows the rail.
3. Schedule: date change requests that date; a time tap builds `SeatMapArgs` with the sibling times; prices are rendered from the payload with no sum.

## Out of scope

Admin create, edit, and delete. A map. A city picker. Pagination. Changing the carousel, the genre list, or the now-showing rail. Holds, quotes, and payment. Translating names stored in the database.
