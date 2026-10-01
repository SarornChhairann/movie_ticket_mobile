# Sprint 4 — Checkout quote

## Goal

With a live hold, the user sees the server quote: seats, morning discount, weekend surcharge, subtotal, promo, tax, service fee, food, total. Nothing is charged and nothing is written.

Depends on: sprint 3. Analytics sections 3.4 and 3.8. Gap rows G11, G12, G13, G14.

## Acceptance

- [x] Screen calls `POST /bookings/quote/{showtimeId}` with seat ids from the active hold, optional promo, and the food map.
- [x] Every price line on screen comes from the server. The app never adds, multiplies, or applies a rate.
- [x] Promo: applying a code re-quotes. Success shows the discount line; `PROMO_INVALID` shows the server message and keeps the previous quote. Discount applies to subtotal only.
- [x] `minPurchase` is enforced for promos (it is not today).
- [x] Food lists only available items. Quantity ≥ 0, capped by `stockQuantity` when it is not 0 (0 = unlimited). Changing quantity re-quotes (debounced 300 ms). Lines use server prices.
- [x] Guest must enter name and phone before continue; email optional and validated if present. Signed-in user sees their name/phone prefilled and no guest form.
- [x] Hold countdown from sprint 3 continues on this screen. At zero, or on `HOLD_EXPIRED`, return to the seat map.
- [x] **Change seats** returns to the map; the map releases the old hold before taking a new one.
- [x] Quote inserts no booking, payment, ticket, or hold, and does not set seats `BOOKED`.

*Verified by backend `BookingServiceTest` (8 formula cases + unavailable food) and `BookingControllerQuoteTest` (quote never holds or books; no hold → `HOLD_EXPIRED`), and Flutter checkout repository/bloc/widget tests. A live walk-through against the running API is still pending. Pay shows a "coming next" notice until sprint 5.*

## API contract

All calls send `X-Session-Id`. Bearer when signed in.

| Call | Request | Response / errors |
| --- | --- | --- |
| `POST /bookings/quote/{showtimeId}` (new) | `{ seatIds: [id], promoCode?: string, foodItems?: { "<foodItemId>": qty } }` | `QuoteResponse` below. 409 `HOLD_EXPIRED`, `SEAT_HELD`, `SEAT_BOOKED`. 400 `COUPLE_PAIR_INVALID`, `PROMO_INVALID`. |
| `GET /bookings/checkout/{showtimeId}` | — | Kept for old clients. **Not used by the app** because it places a hold and ignores food (G11). |
| `POST /bookings/promo/validate` | — | **Not used** (always 200, ignores `minPurchase`, G14). Re-quote instead. |

`QuoteResponse`:

```json
{
  "showtime": { "id", "showDate", "showTime", "movieTitle", "hallName", "hallCity", ... },
  "seats": [{ "id", "seatCode", "seatType", "rowNumber", "status" }],
  "baseAmount": 0, "morningDiscount": 0, "weekendSurcharge": 0, "subtotal": 0,
  "promoCode": "SAVE10", "discountAmount": 0,
  "taxAmount": 0, "serviceFee": 0,
  "foodLines": [{ "foodItemId", "name", "unitPrice", "quantity", "lineTotal" }],
  "foodTotal": 0, "totalAmount": 0,
  "availableFoodItems": [{ "id", "name", "description", "price", "imageUrl", "available", "stockQuantity" }],
  "user": { "id", "name", "email", "phone" } | null
}
```

The hold expiry is not repeated in the quote: the app already has it from the hold response (sprint 3) and passes the `Hold` to this screen.

## Step 1 — UX/UI

1. Screen: movie/hall/time header, seat summary, food list, promo field, price lines, guest form, sticky total, Pay button (disabled this sprint; enabled when the quote is loaded and guest fields are valid — wiring lands in sprint 5).
2. Price lines in this order: base, morning discount, weekend surcharge, subtotal, promo, tax, service fee, food, total. Hide zero discount/surcharge lines.
3. Keys under `checkout.*`: `checkout.title`, `checkout.base`, `checkout.morningDiscount`, `checkout.weekendSurcharge`, `checkout.subtotal`, `checkout.promo`, `checkout.applyPromo`, `checkout.tax`, `checkout.serviceFee`, `checkout.food`, `checkout.total`, `checkout.guestName`, `checkout.guestPhone`, `checkout.guestEmail`, `checkout.changeSeats`, `checkout.pay`.

## Step 2 — Backend

1. **Pure quote endpoint (G11).** Add `POST /bookings/quote/{showtimeId}` in `BookingController` with a nested `QuoteRequest` record. It:
   - resolves the session id (sprint 3), rejects with `HOLD_EXPIRED` unless `seatHoldService.ownsActiveHolds(seatIds, sessionId)`;
   - calls `bookingService.buildCheckout(showtimeId, seatIds, email, promoCode, foodItems)` (add the food parameter; `resolveCheckoutData` already computes food);
   - takes **no** lock and writes nothing. It must not call `holdSeatsRealtime`.
   - `@Transactional(readOnly = true)` so the DTO mapping runs with the session open.
   Add the path to `SecurityConfig` permitAll **only if** `/bookings/checkout/**` style matching does not already cover it — `/bookings/quote/**` is new, so add it next to `/bookings/checkout/**`.
2. **Full breakdown (G12).** Add `subtotal`, `foodTotal`, and `foodLines` to `CheckoutData` and the new `QuoteResponse`. Compute them in `resolveCheckoutData`; do not duplicate math in the controller. Only `available` food items may be priced — reject unavailable ones with 400.
3. **Promo `minPurchase` (G13).** In `resolveCheckoutData`, call `promoCodeService.validateWithSubtotal(code, subtotal)`. Wrap its `IllegalArgumentException` as `ApiException(BAD_REQUEST, "PROMO_INVALID", message)`.
4. Leave `GET /bookings/checkout/{id}` and `POST /bookings/promo/validate` in place (G14).
5. Unit tests in `BookingServiceTest` for the formula in analytics 3.4:
   - weekday afternoon, two normal seats
   - morning show, discount applied before weekend math
   - Sunday morning show, surcharge on the post-morning base
   - promo percent does not reduce food, tax, or service fee
   - promo under `minPurchase` rejected with `PROMO_INVALID`
   - couple pair priced once
   - odd couple count rejected
   - rates read from `SystemSettingService` (change the tax rate in the mock, total follows)
6. Controller test: quote creates no `seat_holds` row and no booking (verify `seatHoldService`/`bookingRepository` write methods never called).

## Step 3 — Frontend

Feature `checkout`:

1. DTOs: `QuoteRequestDto`, `QuoteResponseDto`, `FoodItemDto`, `FoodLineDto`. Money parsed from JSON numbers without `double` arithmetic.
2. Entities: freezed `Quote` (all lines), `FoodItem`, `FoodLine`, `GuestInfo(name, phone, email)`.
3. `CheckoutFailure`: `holdExpired`, `seatConflict`, `promoInvalid(message)`, `pairInvalid`, `network`, `unknown(message)`.
4. `CheckoutRepository` (lazy singleton) sends seat ids from the `Hold` passed by the route only.
5. `CheckoutBloc` (factory) events: `QuoteRequested`, `PromoApplied(code)`, `PromoCleared`, `FoodChanged(id, qty)`, `GuestEdited(GuestInfo)`, `HoldTicked`, `HoldExpired`. State keeps the last good `Quote` so a failed promo does not blank the screen; a one-shot `failure` flag drives the snackbar.
6. Guest validation (non-empty name/phone, optional email format) lives in the bloc; the view only reads `canPay`.
7. View formats money with the active locale. It does not add tax itself.

## Step 4 — Testing

1. Bloc tests: initial quote loads; promo success updates discount; promo failure keeps the previous quote and sets an error; food change re-quotes once after debounce; `HOLD_EXPIRED` emits navigate-back; guest `canPay` false until name and phone are set.
2. Repository test: body contains seat ids, promo, and food map with string keys; error codes map to failures.
3. Widget test: Pay disabled for a guest until name and phone are non-empty; price lines render in the specified order.
4. Backend tests from step 2.

## Definition of done

The eight formula cases pass. Opening and re-quoting the checkout screen creates no booking and no extra hold rows (checked in the DB or by the controller test). Promo below `minPurchase` is rejected.

## Out of scope

Payment capture, ticket QR, cancel.
