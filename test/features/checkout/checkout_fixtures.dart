import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';

final testNow = DateTime(2026, 10, 7, 13, 50);
final testHold = Hold(showtimeId: 50, seatIds: {1, 2}, expiresAt: testNow.add(const Duration(minutes: 10)));

const popcorn = FoodItem(id: 7, name: 'Popcorn', price: 3, stockQuantity: 2);
const water = FoodItem(id: 8, name: 'Water', price: 1, stockQuantity: 0);

Quote testQuote({String? promo, num discount = 0, num total = 12.5, num foodTotal = 0, QuoteUser? user}) => Quote(
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      showDate: '2026-10-07',
      showTime: '14:00:00',
      seatCodes: const ['D1', 'D2'],
      baseAmount: 10,
      morningDiscount: 0,
      weekendSurcharge: 0,
      subtotal: 10,
      promoCode: promo,
      discountAmount: discount,
      taxAmount: 1,
      serviceFee: 1.5,
      foodLines: const [],
      foodTotal: foodTotal,
      totalAmount: total,
      foodItems: const [popcorn, water],
      user: user,
    );

Map<String, dynamic> quoteJson() => {
      'showtime': {'id': 50, 'showDate': '2026-10-07', 'showTime': '14:00:00', 'movieTitle': 'Dune', 'hallName': 'Hall 1'},
      'seats': [
        {'id': 2, 'seatCode': 'D2', 'seatType': 'NORMAL', 'rowNumber': 4, 'status': 'AVAILABLE'},
        {'id': 1, 'seatCode': 'D1', 'seatType': 'NORMAL', 'rowNumber': 4, 'status': 'AVAILABLE'},
      ],
      'baseAmount': 10.00,
      'morningDiscount': 0,
      'weekendSurcharge': 0,
      'subtotal': 10.00,
      'promoCode': 'SAVE20',
      'discountAmount': 2.00,
      'taxAmount': 1.00,
      'serviceFee': 1.50,
      'foodLines': [
        {'foodItemId': 7, 'name': 'Popcorn', 'unitPrice': 3.00, 'quantity': 2, 'lineTotal': 6.00},
      ],
      'foodTotal': 6.00,
      'totalAmount': 16.50,
      'availableFoodItems': [
        {'id': 7, 'name': 'Popcorn', 'price': 3.00, 'available': true, 'stockQuantity': 0, 'imageUrl': '/uploads/food/popcorn.jpg'},
        {'id': 9, 'name': 'Nachos', 'price': 4.00, 'available': false, 'stockQuantity': 0},
      ],
      'user': null,
    };
