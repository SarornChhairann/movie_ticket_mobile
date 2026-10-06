# Checkout concessions

Replace the full food stepper list on checkout with a short section. Tapping it opens a shop screen: search, category tabs, and add-to-cart. The existing `CheckoutBloc` food map stays the cart. The server still prices every line.

## Journey

```
Seat map (hold starts)
  → Checkout summary
      → Food & drinks section
          → Concessions page (search, tabs, add)
          → Done
      → Checkout shows the chosen lines and the server total
  → Pay
```

The hold countdown stays visible on both screens. When it hits zero, or the quote returns `HOLD_EXPIRED`, both screens leave and the seat map returns. Changing seats still pops only back to the map and keeps the same release rule as today.

## What already exists

- The quote returns `availableFoodItems` (id, name, description, price, imageUrl, stockQuantity). `stockQuantity` 0 means unlimited.
- `CheckoutBloc.food` is `Map<int, int>` of item id to quantity. `FoodChanged` clamps to `0…maxQuantity` and drops zeros.
- `FoodRequoteRequested` waits 300 ms, then `POST /bookings/quote/{showtimeId}` sends that map. Confirm sends the same map.
- Promo never reduces food. The sticky total is `quote.totalAmount`. The food line is `quote.foodTotal`. Line amounts come from `quote.foodLines`.
- The app does not add or multiply money.

Do not add a cart table, a second bloc, or a food search endpoint. The menu is the list already on the quote.

## Checkout section

Remove the per-item plus and minus rows from `CheckoutPage`.

In their place, one card under the seat summary:

| State | What the card shows |
| --- | --- |
| Nothing chosen | Title, one-line hint, and a horizontal row of up to 4 item photos. The row is a preview, not a second catalog. |
| Something chosen | Title, “N items”, and one compact row per chosen line: photo, name, quantity, `foodLines.lineTotal`. |
| Menu empty | Hide the card. |

The whole card is the tap target. It pushes the concessions route. A text button on the card says “Browse” when the cart is empty and “Edit” when it is not.

The price block is unchanged. Food still appears there only when `foodTotal` is not zero, using the server number.

## Concessions page

New route `/checkout/concessions`. Push it with `BlocProvider.value` of the checkout bloc that is already quoting this hold. Popping returns to checkout with the same quantities.

### App bar

Back button, title, and the same `mm:ss` hold label used on checkout. Back does not clear the cart.

### Search

One field under the app bar, pinned while the grid scrolls. It filters the quote list by name and description, case-insensitive, including Khmer. Filter on the device. Wait about 200 ms after typing before applying the filter so the grid does not rebuild on every key. Clearing the field restores the current tab.

### Tabs

The API has no category column. Tabs are display groups over that same list, in this order:

| Tab | Item is included when the name or description contains |
| --- | --- |
| All | every available item |
| Popcorn | `popcorn` or `ពោត` |
| Drinks | `cola`, `coffee`, `tea`, `soda`, `សូដា`, `កាហ្វេ`, `តែ` |
| Snacks | everything else |

An item that matches Popcorn or Drinks does not also appear under Snacks. A tab with no items after the current search is hidden. If search matches nothing, the grid shows the empty state and the tabs stay.

Keep this keyword map in one place in the concessions model. It is a label for the screen, not a stored category.

### Item card

Two-column grid. Card surface is `navyRaised`, radius consistent with other cards, image on top at 1:1.

- Photo from `imageUrl`, resolved the same way movie posters are (`/uploads/...` plus the API host). Missing image uses a simple food placeholder.
- Name, one line, then the server unit `price`.
- Quantity 0: one blue **Add** button.
- Quantity 1 or more: the button becomes `−  quantity  +` on that same card. Minus at 1 goes back to **Add** (quantity 0). Plus stops at `maxQuantity` when stock is limited.
- Each tap sends the existing `FoodChanged` event. The number on the card updates immediately from `state.food`. The money in the bottom bar updates when the debounced requote returns.

### Bottom bar

Fixed above the safe area, same shape as the checkout pay bar.

- Left: count of chosen units, and `quote.foodTotal` once a quote including food has returned. While `quoting` is true, keep the previous food total and show the thin progress line already used on checkout.
- Right: **Done**, which pops this route.

Do not put Pay on this page. Pay stays on checkout.

## States

| State | Screen |
| --- | --- |
| First paint | Checkout already has the menu. The concessions page reads it. No second loading spinner unless checkout itself is still loading. |
| Search miss | Short empty message under the search field. |
| Tab miss | That tab is not shown. |
| Requote error | Keep the quantities and the previous quote. Show the server message in a snack bar, same as a failed promo. |
| Hold expired | Snack bar, then pop until the seat map. |
| Stock cap | Plus is disabled. No error dialog. |

## Copy

Add keys in `en` and `km`:

`checkout.foodTitle`, `checkout.foodHint`, `checkout.foodBrowse`, `checkout.foodEdit`, `checkout.foodCount`, `checkout.foodSearch`, `checkout.foodEmpty`, `checkout.foodAdd`, `checkout.foodDone`, `checkout.foodAll`, `checkout.foodPopcorn`, `checkout.foodDrinks`, `checkout.foodSnacks`.

Reuse `checkout.food` for the price line and `seats.expiresIn` for the countdown.

## Files

| Piece | Where |
| --- | --- |
| Section card | `features/checkout/view/checkout_page.dart` |
| Shop screen | `features/checkout/view/concessions_page.dart` |
| Tab filter | `features/checkout/model/food_groups.dart` |
| Route | `AppRoutes.concessions` in `app_router.dart`, `BlocProvider.value` |
| Bloc | No new events. Keep `FoodChanged` and the 300 ms requote. |

## Tests

- Grouping: a popcorn name lands on Popcorn, a cola name on Drinks, an unmatched name on Snacks, and every item on All.
- Search narrows the visible list and does not change `state.food`.
- Add sets quantity 1. Plus and minus follow the current stock clamp. Quantity 0 removes the key.
- Widget: checkout card navigates; after a quantity is set, the card lists that line. Concessions **Done** pops.
- The quote request body is still the food map with string keys. No test should assert a client-computed total.

## Out of scope

A `category` column, combo deals, a cart that survives leaving checkout, and paying from the concessions page.
