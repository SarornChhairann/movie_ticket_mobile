import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_failure.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_repository.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/checkout/model/payway.dart';
import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';

import 'checkout_fixtures.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late CheckoutRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
    repository = CheckoutRepository(dio);
  });

  test('sends the hold seat ids, promo, and food map with string keys; maps every line', () async {
    adapter.onPost(
      '/bookings/quote/50',
      (s) => s.reply(200, quoteJson()),
      data: {
        'seatIds': [1, 2],
        'promoCode': 'SAVE20',
        'foodItems': {'7': 2},
      },
    );

    final result = await repository.quote(testHold, promoCode: ' SAVE20 ', food: {7: 2, 8: 0});
    final quote = (result as Ok<Quote, CheckoutFailure>).value;

    expect(quote.seatCodes, ['D1', 'D2']);
    expect(quote.subtotal, 10);
    expect(quote.discountAmount, 2);
    expect(quote.foodLines.single.lineTotal, 6);
    expect(quote.totalAmount, 16.5);
    expect(quote.foodItems.map((f) => f.name), ['Popcorn'], reason: 'unavailable food is not listed');
    expect(quote.foodItems.single.imageUrl, 'http://api.test/uploads/food/popcorn.jpg',
        reason: 'upload paths resolve against the API host like posters');
    expect(quote.user, isNull);
  });

  test('omits promo and food when there are none', () async {
    adapter.onPost('/bookings/quote/50', (s) => s.reply(200, quoteJson()), data: {'seatIds': [1, 2]});

    expect(await repository.quote(testHold), isA<Ok<Quote, CheckoutFailure>>());
  });

  Future<CheckoutFailure> failureFor(int status, String code) async {
    adapter.onPost('/bookings/quote/50', (s) => s.reply(status, {'error': 'msg', 'type': 'X', 'code': code}),
        data: Matchers.any);
    return (await repository.quote(testHold) as Err<Quote, CheckoutFailure>).failure;
  }

  test('error codes map to checkout failures', () async {
    expect(await failureFor(409, 'HOLD_EXPIRED'), const CheckoutFailure.holdExpired());
    expect(await failureFor(409, 'SEAT_BOOKED'), const CheckoutFailure.seatConflict('msg'));
    expect(await failureFor(400, 'PROMO_INVALID'), const CheckoutFailure.promoInvalid('msg'));
    expect(await failureFor(400, 'COUPLE_PAIR_INVALID'), const CheckoutFailure.pairInvalid());
  });

  Map<String, dynamic> bookingJson() => {
        'id': 99,
        'showtime': {'id': 50, 'showDate': '2026-10-07', 'showTime': '14:00:00', 'movieTitle': 'Dune', 'hallName': 'Hall 1'},
        'customerName': 'Dara',
        'customerEmail': null,
        'customerPhone': '012',
        'totalAmount': 16.50,
        'serviceFee': 1.50,
        'taxAmount': 1.00,
        'discountAmount': 2.00,
        'promoCode': 'SAVE20',
        'paymentMethod': 'CARD',
        'status': 'CONFIRMED',
        'bookedAt': '2026-10-07T13:55:00',
        'tickets': [
          {'id': 2, 'ticketCode': 'T-2', 'status': 'ACTIVE', 'seatCode': 'D2', 'seatType': 'NORMAL'},
          {'id': 1, 'ticketCode': 'T-1', 'status': 'ACTIVE', 'seatCode': 'D1', 'seatType': 'NORMAL'},
        ],
        'firstTicketCode': 'T-2',
      };

  test('confirm sends seats, guest, promo, food, and method — never a total', () async {
    adapter.onPost(
      '/bookings/checkout/50',
      (s) => s.reply(200, bookingJson()),
      data: {
        'seatIds': [1, 2],
        'guestName': 'Dara',
        'guestPhone': '012',
        'promoCode': 'SAVE20',
        'paymentMethod': 'CARD',
        'foodItems': {'7': 2},
      },
    );

    final result = await repository.confirm(
      testHold,
      guest: const GuestInfo(name: ' Dara ', phone: '012'),
      promoCode: 'SAVE20',
      food: {7: 2},
    );
    final c = (result as Ok<BookingSummary, CheckoutFailure>).value;

    expect(c.bookingId, 99);
    expect(c.status, BookingStatus.confirmed);
    expect(c.totalAmount, 16.5);
    expect(c.tickets.map((t) => t.seatCode), ['D1', 'D2']);
  });

  test('confirm maps PAYMENT_FAILED and ACCOUNT_BLOCKED', () async {
    adapter.onPost('/bookings/checkout/50',
        (s) => s.reply(402, {'error': 'Card declined.', 'type': 'PAYMENT_REQUIRED', 'code': 'PAYMENT_FAILED'}),
        data: Matchers.any);
    expect((await repository.confirm(testHold) as Err<BookingSummary, CheckoutFailure>).failure,
        const CheckoutFailure.paymentFailed('Card declined.'));

    adapter.onPost('/bookings/checkout/50',
        (s) => s.reply(403, {'error': 'This account is banned.', 'type': 'FORBIDDEN', 'code': 'ACCOUNT_BLOCKED'}),
        data: Matchers.any);
    expect((await repository.confirm(testHold) as Err<BookingSummary, CheckoutFailure>).failure,
        const CheckoutFailure.blocked('This account is banned.'));
  });

  test('confirm maps SEAT_LIMIT and a foreign booking maps BOOKING_NOT_FOUND', () async {
    adapter.onPost('/bookings/checkout/50',
        (s) => s.reply(400, {'error': 'You can book at most 8 seats at a time.', 'type': 'BAD_REQUEST', 'code': 'SEAT_LIMIT'}),
        data: Matchers.any);
    expect((await repository.confirm(testHold) as Err<BookingSummary, CheckoutFailure>).failure,
        const CheckoutFailure.seatLimit('You can book at most 8 seats at a time.'));

    adapter.onGet('/bookings/confirmation/7',
        (s) => s.reply(404, {'error': 'Booking not found.', 'type': 'NOT_FOUND', 'code': 'BOOKING_NOT_FOUND'}));
    expect((await repository.getConfirmation(7) as Err<BookingSummary, CheckoutFailure>).failure,
        const CheckoutFailure.bookingNotFound('Booking not found.'));
  });

  test('getConfirmation re-reads a booking', () async {
    adapter.onGet('/bookings/confirmation/99', (s) => s.reply(200, bookingJson()));

    final c = (await repository.getConfirmation(99) as Ok<BookingSummary, CheckoutFailure>).value;

    expect(c.tickets.first.code, 'T-1');
  });

  group('PayWay', () {
    test('start sends the confirm body and maps the checkout page', () async {
      adapter.onPost(
        '/bookings/payway/50',
        (s) => s.reply(200, {
          'bookingId': 99,
          'tranId': 'CK2RT1',
          'amount': 16.5,
          'checkoutUrl': 'https://checkout-sandbox.payway.com.kh/abc',
          'abaDeeplink': 'abamobilebank://ababank.com?type=payway',
        }),
        data: {
          'seatIds': [1, 2],
          'guestName': 'Dara',
          'guestPhone': '012',
          'paymentMethod': 'ABA_KHQR',
          'foodItems': {'7': 2},
        },
      );

      final result = await repository.startPayway(testHold,
          guest: const GuestInfo(name: 'Dara', phone: '012'), food: {7: 2});
      final session = (result as Ok<PaywaySession, CheckoutFailure>).value;

      expect(session.tranId, 'CK2RT1');
      expect(session.amount, 16.5);
      expect(session.checkoutUrl, 'https://checkout-sandbox.payway.com.kh/abc');
      expect(session.abaDeeplink, 'abamobilebank://ababank.com?type=payway');
    });

    test('poll maps each status; APPROVED carries the confirmation', () async {
      adapter.onGet('/bookings/payway/T1', (s) => s.reply(200, {'status': 'PENDING'}));
      adapter.onGet('/bookings/payway/T2', (s) => s.reply(200, {'status': 'DECLINED'}));
      adapter.onGet('/bookings/payway/T3', (s) => s.reply(200, {'status': 'CANCELLED'}));
      adapter.onGet(
        '/bookings/payway/T4',
        (s) => s.reply(200, {
          'status': 'APPROVED',
          'confirmation': {
            'id': 99,
            'showtime': {'id': 50, 'movieTitle': 'Dune', 'hallName': 'Hall 1'},
            'totalAmount': 16.5,
            'status': 'CONFIRMED',
            'tickets': [
              {'id': 1, 'ticketCode': 'T-1', 'status': 'ACTIVE', 'seatCode': 'D1', 'seatType': 'NORMAL'},
            ],
          },
        }),
      );

      PaywayStatus status(Result<PaywayStatus, CheckoutFailure> r) => (r as Ok<PaywayStatus, CheckoutFailure>).value;
      expect(status(await repository.pollPayway('T1')), const PaywayStatus.pending());
      expect(status(await repository.pollPayway('T2')), const PaywayStatus.declined());
      expect(status(await repository.pollPayway('T3')), const PaywayStatus.cancelled());
      final approved = status(await repository.pollPayway('T4')) as PaywayApproved;
      expect(approved.confirmation.bookingId, 99);
      expect(approved.confirmation.tickets.single.code, 'T-1');
    });

    test('close posts to the close route', () async {
      adapter.onPost('/bookings/payway/T1/close', (s) => s.reply(200, {'status': 'CANCELLED'}));

      final result = await repository.closePayway('T1');
      expect((result as Ok<PaywayStatus, CheckoutFailure>).value, const PaywayStatus.cancelled());
    });

    test('402 PAYMENT_FAILED on start is a payment failure', () async {
      adapter.onPost('/bookings/payway/50',
          (s) => s.reply(402, {'error': 'Wrong hash', 'type': 'PAYMENT_REQUIRED', 'code': 'PAYMENT_FAILED'}),
          data: Matchers.any);

      final result = await repository.startPayway(testHold);
      expect((result as Err<PaywaySession, CheckoutFailure>).failure, const CheckoutFailure.paymentFailed('Wrong hash'));
    });
  });
}
