# Sprint 11 — Home filters

## Goal

The tune button on Home stops being a second copy of the genre chips. It opens one filter sheet. Movies can be narrowed by genre, language, and rating. Halls can be narrowed by city, hall type, Dolby Atmos, and ScreenX. Search stays a title and hall-name query.

Depends on: sprint 2 catalog and sprint 10 hall list. Analytics section 3.2. No new endpoint, no price math, no seat status, no role change.

## What is wrong today

`CatalogSearch` sends `search` to `GET /movies?tab=&search=` (movie title, 300 ms debounce). The same text filters halls by hall name, cinema name, and city. The tune button (`search.filter`) opens a sheet that only lists genres, then closes. The genre chip row under Coming soon does the same pick. Genre is an exact match on movies already loaded. It does not hide halls.

`GET /movies` also accepts `genre`, `language`, `format`, `rating`, and `city`. Do not start sending those. Server `genre` and `language` are substring matches, server `format` is exact, and `city` on that route filters an unused hall array, not the movie list. The app already has `language` and `rating` on each movie, and `city`, `type`, `hasDolbyAtmos`, and `hasScreenX` on each hall. Filter those in memory. Every seeded movie is format `2D`, so format is not a filter.

## Acceptance

- [x] The tune button opens a sheet titled with `catalog.filter`. The sheet stays open while a chip is tapped. **Done** closes it.
- [x] Movie group: **Genre**, **Language**, **Rating**. Each group starts with **All**. Choices are the distinct non-empty values on the loaded now-showing and coming-soon lists, sorted A–Z ignoring case. A selected value stays in its list after a search that no longer returns it, so it can be cleared.
- [x] The genre chip row and the sheet’s genre chips are the same selection. Picking one updates the other.
- [x] A movie is shown only when it matches every selected movie filter: genre, language, and rating, each an exact trim match. **All** means that field is not applied. Search still limits which movies were loaded.
- [x] Coming soon, **Now in Cinemas**, and Explore all use that movie filter. **See all** keeps it.
- [x] Hall group, on the same sheet: **City**, **Type**, **Dolby Atmos**, **ScreenX**. City and type use **All** plus the distinct values on the loaded halls. Dolby and ScreenX are on/off. Type shows `home.halls.type.atmos` and `home.halls.type.standard` for those stored values; any other type is shown as stored.
- [x] A hall is shown only when it matches the search text and every selected hall filter. Movie filters do not hide halls. Hall filters do not hide movies.
- [x] **Clear** resets genre, language, rating, city, type, Dolby, and ScreenX. It does not clear the search field and does not refetch.
- [x] The tune button shows a badge with the count of active filters (a movie field that is not All, a hall field that is not All, Dolby on, ScreenX on). No badge at zero.
- [x] Changing a filter does not call the API. Search and pull-to-refresh still do.
- [x] Copy keys exist in `en.json` and `km.json`. Genre, language, rating, city, and unknown type strings are shown as the API stored them.

*Verified by `catalog_filters_test.dart` (`moviesFor` AND rules, choices, `filterHalls` with search and the four hall filters, both blocs filtering and clearing without a repository call, filters surviving a load) and `filter_sheet_test.dart` (real blocs over mocked repositories: one sheet that stays open on a chip tap, genre row ↔ sheet sync, badge count, a language chip hides a movie but no hall, a city chip hides a hall but no movie, Clear keeps the search, no API calls). Notes: group labels use new keys `catalog.genre` and `catalog.hallType` (the doc lists none for Genre and Type; `home.halls.type` is already a parent key). Hall filters appear only on Home (`CatalogSearch(includeHalls: true)`); Explore's sheet and badge show the movie filters only.*

## Sheet

```
Filter
  Genre          All · (values on the loaded movies)
  Language       All · (values on the loaded movies)
  Rating         All · (values on the loaded movies)
  City           All · (values on the loaded halls)
  Type           All · Atmos · Standard
  Dolby Atmos    off / on
  ScreenX        off / on
  Clear          Done
```

Genre, language, and rating are read from `MovieListBloc`. City, type, Dolby, and ScreenX are read from `HallListBloc`. The sheet is given both blocs with `BlocProvider.value`.

## Apply rules

| Control | Movies (both rails and Explore) | Halls |
| --- | --- | --- |
| Search text | Server title search, unchanged | Hall name, cinema name, or city, unchanged |
| Genre, language, rating | Exact trim match, AND | Ignored |
| City | Ignored | Exact trim match on `hall.city` |
| Type | Ignored | Exact match on `hall.type` |
| Dolby on | Ignored | `hasDolbyAtmos` is true |
| ScreenX on | Ignored | `hasScreenX` is true |

Empty movie rails keep `catalog.empty`. When the hall search text is empty and hall filters hide every hall, use `home.halls.filterEmpty`. When the search text itself matches nothing, keep `home.halls.searchEmpty`.

## Flutter

1. Extend `MovieListState` with `language` and `rating` (`String?`, null is All) on every union case. `moviesFor` applies genre, then language, then rating. Add `languages` and `ratings` the same way `genres` is built. Events: `LanguageSelected`, `RatingSelected`, `MovieFiltersCleared`. `GenreSelected` stays. Search and refresh copy the three filters through, the same way genre is copied today.
2. Extend `HallListBloc` state with `city`, `type`, `dolbyOnly`, `screenXOnly`. Events: `HallCitySelected`, `HallTypeSelected`, `HallDolbyToggled`, `HallScreenXToggled`, `HallFiltersCleared`. `filterHalls` keeps the search rule and adds these four. Do not refetch.
3. Replace `showGenreSheet` with this sheet. `GenreChipRow` still sends `GenreSelected` only.
4. `SearchPill` grows an optional `filterCount`. `CatalogSearch` passes the active count. Badge key: `search.filter.count`.
5. Home and Explore already share `MovieListBloc`, so language and rating follow **See all** with no extra wiring. Hall filters exist only on the home hall section.

### Copy

| Key | English |
| --- | --- |
| `catalog.filter` | Filter |
| `catalog.language` | Language |
| `catalog.rating` | Rating |
| `catalog.city` | City |
| `catalog.clear` | Clear |
| `catalog.done` | Done |
| `home.halls.filterEmpty` | No halls match these filters |

`catalog.filter` is already “Genres”. Change that English string and the Khmer string together. `catalog.allGenres` stays the **All** chip for every group.

### Tests

1. `moviesFor`: genre AND language AND rating; a null field does not remove rows; search results are whatever the ready list already contains.
2. `filterHalls`: search plus city, type, Dolby, and ScreenX; a movie-only filter is not a parameter of this function.
3. Bloc: selecting language does not call the repository; clear sets the three movie fields back to null and leaves `search` as it was.
4. Widget: tune opens the sheet and does not pop on a chip tap; genre chip row and sheet stay in sync; badge is absent at zero and shows the count when language and Dolby are on; a language chip hides a movie and leaves halls; a city chip hides a hall and leaves the movie rail.

## Out of scope

Sending `genre`, `language`, `format`, `rating`, or `city` on `GET /movies`. A format chip. A new facet endpoint. Filtering showtimes inside a hall schedule. Changing hold, quote, or payment.
