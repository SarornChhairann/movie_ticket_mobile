# Sprint 9 — ABA PayWay (KHQR)

## Goal

The customer pays the server total with ABA KHQR. Checkout does not list a payment method. **Pay** opens a sheet with the amount and one method. The app then opens PayWay’s checkout page in an in-app web view, and either hands off to the ABA app or stays on that page. Seats become `BOOKED` only after PayWay reports the payment approved.

Depends on: sprint 5 confirm transaction. Analytics sections 3.4, 3.5, and 6.3. PayWay: [Ecommerce Checkout](https://developer.payway.com.kh/ecommerce-checkout-3158159f0.md), [Purchase](https://developer.payway.com.kh/purchase-14530820e0.md), [Check transaction](https://developer.payway.com.kh/check-transaction-14530826e0.md).

Sandbox host: `https://checkout-sandbox.payway.com.kh`. Credentials stay in environment variables. Do not copy `docs/credential.md` into source, logs, or this sprint.

## Acceptance

- [x] Checkout has no payment-method row. **Pay** opens a bottom sheet.
- [x] The sheet title is the pay title. Directly under it is the server `totalAmount`. The only tile is **ABA KHQR**, subtitle “Pay with another bank partner”.
- [x] **Process payment** on the sheet calls the backend. The amount sent to PayWay is that same server total, currency `USD`. The app does not add the total.
- [x] Backend creates the purchase with `payment_option=abapay_khqr_deeplink` and returns `checkoutUrl` from PayWay’s `checkout_qr_url`, plus `abaDeeplink` from `abapay_deeplink`.
- [x] If the device can open the ABA deeplink, an in-app web view loads `checkoutUrl` and is allowed to follow that deeplink into the ABA app. `return_deeplink` brings the user back to CineKH.
- [x] If the device cannot open the ABA deeplink, the same web view loads `checkoutUrl` and does not leave the app.
- [x] While the web view is open, the app polls the backend every 3 seconds. The backend calls PayWay Check transaction. Polling stops on `APPROVED`, `DECLINED`, or `CANCELLED`.
- [x] `APPROVED` runs the existing paid path once: booking `CONFIRMED`, tickets, seats `BOOKED`, promo use, points, email, holds released.
- [x] `DECLINED`, `CANCELLED`, user dismiss, or hold expiry leaves seats `AVAILABLE`, writes no tickets, and closes the PayWay transaction.
- [x] The mock gateway remains the test double. The PayWay client is used only when the sandbox keys are set.

*Verified by backend `PaywaySignerTest` (purchase, transaction, and callback HMAC vectors computed with `openssl`) and `PaywayCheckoutIntegrationTest` on H2 with a mocked `PaywayClient` (start writes `PENDING` only; `APPROVED` confirms once and a second poll or callback adds nothing; `DECLINED` cancels and closes; close keeps the hold; bad callback HMAC is `401`; under 3 minutes is `HOLD_EXPIRED` without Purchase; Purchase failure is `402`), plus Flutter checkout/PayWay bloc, repository, navigation-decision, and widget tests. A live sandbox payment on a device (real keys, whitelisted callback domain, ABA app hand-off) is still pending. Translation keys are `pay.abaKhqr.title`/`pay.abaKhqr.subtitle` because `pay.abaKhqr` cannot be both a string and a parent in nested JSON; the tile's widget key is `pay.abaKhqr`.*

## Journey

```
Checkout (seats, food, promo, guest, total)
  → Pay
      → Bottom sheet
          title
          amount = quote.totalAmount
          tile: ABA KHQR
          subtitle: Pay with another bank partner
          Process payment
      → POST start-payway
      → In-app web view of checkoutUrl
          ABA app installed → web view may open abapay_deeplink
          ABA app missing  → web view stays on checkoutUrl
      → poll every 3s
          APPROVED → success screen
          DECLINED or CANCELLED → payment-failed dialog, hold kept if still alive
          hold reaches 0 → close transaction, back to the seat map
```

## Backend

### Secrets

| Env | Use |
| --- | --- |
| `PAYWAY_BASE_URL` | `https://checkout-sandbox.payway.com.kh` |
| `PAYWAY_MERCHANT_ID` | Merchant id |
| `PAYWAY_API_KEY` | HMAC key (the sandbox “public key”, not the RSA key) |
| `PAYWAY_RETURN_URL` | Public URL of the callback below |

The RSA key pair in the sandbox mail is not used for this purchase hash.

### 1. Start payment

`POST /bookings/payway/{showtimeId}`

Same body as confirm: seat ids, promo, food map, guest fields when there is no user. Same `X-Session-Id` rule.

Inside one transaction, reuse the confirm steps that already exist in `BookingService.confirmCheckout` up to and including the `PENDING` booking and food lines:

1. Lock seats, recompute the quote, reject a bad couple pair, promo, or blocked account.
2. Require an active hold owned by this session.
3. Save booking `PENDING`, payment method `ABA_KHQR`, payment row `PENDING`.
4. Do not call `PaymentGateway.charge`. Do not issue tickets. Do not mark seats `BOOKED`. Do not release the hold.

Then call PayWay Purchase. If Purchase fails, mark the booking `CANCELLED` and the payment `FAILED`, keep the hold, and return `402` `PAYMENT_FAILED`.

Purchase is `POST {PAYWAY_BASE_URL}/api/payment-gateway/v1/payments/purchase` as `multipart/form-data`.

| Field | Value |
| --- | --- |
| `req_time` | UTC `YYYYMMDDHHmmss` |
| `merchant_id` | env |
| `tran_id` | Unique, max 20 characters. Store it on the payment. |
| `amount` | Booking `totalAmount`, scale 2 |
| `currency` | `USD` |
| `type` | `purchase` |
| `payment_option` | `abapay_khqr_deeplink` |
| `payment_gate` | `0` |
| `view_type` | `hosted_view` |
| `firstname`, `lastname`, `email`, `phone` | From the signed-in user or the guest form. Split the name on the first space; a single token is the first name and the last name is `-`. |
| `items` | Base64 JSON array of seat codes and food lines. PayWay does not price this list. |
| `shipping` | `0` |
| `lifetime` | Whole minutes left on the hold. PayWay minimum is 3. If fewer than 3 minutes remain, do not call Purchase; return `409` `HOLD_EXPIRED`. |
| `return_url` | Base64 of `PAYWAY_RETURN_URL` |
| `return_deeplink` | Base64 JSON `{"ios_scheme":"cinekh://payway/return","android_scheme":"cinekh://payway/return"}` |
| `skip_success_page` | `1` |
| `hash` | Base64 HMAC-SHA512 of the concatenation in the Purchase doc, in that field order, using `PAYWAY_API_KEY`. Empty optional fields are empty strings. |

PayWay’s JSON for `abapay_khqr_deeplink` includes `checkout_qr_url` and `abapay_deeplink`. Map those to the response. Do not rename them on the wire to PayWay.

```json
{
  "bookingId": 0,
  "tranId": "",
  "amount": 0,
  "checkoutUrl": "",
  "abaDeeplink": ""
}
```

`checkoutUrl` is `checkout_qr_url`. `abaDeeplink` is `abapay_deeplink`.

### 2. Poll

`GET /bookings/payway/{tranId}`

The caller must own the booking (same user, or the guest session that started it).

Server calls `POST {PAYWAY_BASE_URL}/api/payment-gateway/v1/payments/check-transaction-2` with JSON:

| Field | Value |
| --- | --- |
| `req_time` | UTC `YYYYMMDDHHmmss` |
| `merchant_id` | env |
| `tran_id` | stored id |
| `hash` | Base64 HMAC-SHA512 of `req_time + merchant_id + tran_id` |

Read `data.payment_status`:

| PayWay | This app |
| --- | --- |
| `PENDING` (`payment_status_code` 2) | Stay `PENDING`. Response `{ "status": "PENDING" }`. |
| `APPROVED` (`0`) | Run the paid completion once. Response `{ "status": "APPROVED", "confirmation": <same body as confirm> }`. |
| `DECLINED` (`3`) or `CANCELLED` (`7`) | Booking `CANCELLED`, payment `FAILED`, seats stay `AVAILABLE`, hold kept. Response `{ "status": "DECLINED" }` or `"CANCELLED"`. |

Check transaction only sees rows newer than 7 days. This flow finishes inside the hold, so that limit is enough.

Completion must be idempotent. A second poll or the callback after the first `APPROVED` returns the same confirmation and does not issue a second ticket or add points twice.

### 3. Callback

`POST /api/payway/callback` is public and accepts `application/json`.

Verify header `X-Payway-Hmac-Sha512` the way the checkout guide describes: sort the JSON keys, concatenate the values, HMAC-SHA512 with `PAYWAY_API_KEY`, Base64-compare. A bad signature is `401` and changes nothing.

`status` `"0"` completes the booking the same way as `APPROVED`. Any other status is stored and does not confirm the booking.

Whitelist this URL’s domain on the sandbox merchant profile.

### 4. Close

Call PayWay Close transaction when:

- the customer closes the web view while status is still `PENDING`, or
- the hold expires before `APPROVED`.

A closed transaction must not later become `CONFIRMED`. Seats stay `AVAILABLE`.

### What stays

`PaymentGateway` and `MockPaymentGateway` stay for tests and for `POST /bookings/checkout/{showtimeId}` until this sprint’s pay button no longer calls that route. Customer Pay uses the PayWay endpoints above.

## Frontend

Packages: `webview_flutter` for the checkout page, and the existing `url_launcher` only to test whether `abaDeeplink` can open. Register both in the iOS and Android manifests. Android `queries` and iOS `LSApplicationQueriesSchemes` must include the scheme of `abapay_deeplink` (ABA uses `abamobile`). Add the app scheme `cinekh` so PayWay can return.

### Checkout page

Delete the payment-method `ListTile`. The price block, food, promo, guest form, countdown, and sticky total stay.

**Pay** is enabled on the same `canPay` rule as today. It does not call confirm. It opens the sheet.

### Bottom sheet

Modal sheet, navy surface, top radius, safe area.

1. Title: `pay.title`.
2. Under the title, label `checkout.total` and the server total (`quote.totalAmount`).
3. One tile, key `pay.abaKhqr`: leading KHQR mark, title **ABA KHQR**, subtitle `pay.abaKhqr.subtitle` (“Pay with another bank partner”).
4. Full-width **Process payment** (`pay.process`). Disabled while the purchase request is in flight.

The tile is the selected method. There is no second method in this sprint.

### Web view

After a successful start response:

1. Ask the platform whether `abaDeeplink` can be opened.
2. Push a full-screen in-app web view to `checkoutUrl`.
3. If the device can open ABA, allow a navigation whose URL is `abaDeeplink` or starts with `abamobile:` to leave the web view and open that URL. When CineKH resumes through `cinekh://payway/return`, poll once immediately.
4. If the device cannot open ABA, cancel navigations that leave `https` on the PayWay host so the KHQR page stays in the web view.
5. App bar close asks for confirmation, then `POST` is not required from the client beyond calling `POST /bookings/payway/{tranId}/close` and popping the web view.

### Polling

Start a 3-second timer when the web view opens. Each tick calls `GET /bookings/payway/{tranId}`.

| Status | UI |
| --- | --- |
| `PENDING` | Keep the web view. |
| `APPROVED` | Cancel the timer, close the web view, `pushNamedAndRemoveUntil` the existing success screen with the confirmation. |
| `DECLINED` or `CANCELLED` | Cancel the timer, close the web view, show the existing payment-failed dialog. **Try again** returns to checkout with the hold. **Pick seats** when the hold is dead. |
| Network error | Keep polling. Surface the message after three failures in a row without closing the web view. |

Stop the timer when the web view is disposed.

### Copy

`en` and `km`:

| Key | English |
| --- | --- |
| `pay.title` | Payment |
| `pay.process` | Process payment |
| `pay.abaKhqr` | ABA KHQR |
| `pay.abaKhqr.subtitle` | Pay with another bank partner |
| `pay.checking` | Waiting for payment… |
| `pay.closeConfirm` | Leave payment? The seats stay held until the timer ends. |

Khmer subtitle: `បង់តាមធនាគារដៃគូផ្សេង`.

## Tests

Backend:

- Purchase hash matches a known vector (fixed `req_time`, amount, empty optional fields).
- Start payment with a live hold writes `PENDING` and does not insert a ticket or set a seat `BOOKED`.
- Check mapping: PayWay `APPROVED` confirms once; a second call does not add points again.
- PayWay `DECLINED` cancels the booking and leaves the seat `AVAILABLE`.
- Callback with a bad HMAC does not confirm.
- Remaining hold under 3 minutes returns `HOLD_EXPIRED` and does not call Purchase.

Flutter:

- Checkout page finds no payment-method tile.
- Pay opens the sheet; the sheet shows the quote total and the ABA KHQR subtitle.
- Process payment calls the repository once.
- Poll `PENDING` then `APPROVED` navigates to success and cancels the timer.
- `canLaunch` true allows the deeplink navigation; false blocks it. Test the decision function, not a real ABA install.

## Out of scope

Cards, Alipay, WeChat, Google Pay, saved ABA tokens, refunds, and pre-auth. Admin still does not take payment.
