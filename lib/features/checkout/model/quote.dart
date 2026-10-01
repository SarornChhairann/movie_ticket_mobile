import 'package:freezed_annotation/freezed_annotation.dart';

import 'dto/quote_dtos.dart';

part 'quote.freezed.dart';

@freezed
abstract class FoodItem with _$FoodItem {
  const FoodItem._();

  const factory FoodItem({
    required int id,
    required String name,
    String? description,
    required num price,
    String? imageUrl,

    /// 0 = unlimited.
    required int stockQuantity,
  }) = _FoodItem;

  /// Highest selectable quantity, or null when unlimited.
  int? get maxQuantity => stockQuantity > 0 ? stockQuantity : null;
}

@freezed
abstract class FoodLine with _$FoodLine {
  const factory FoodLine({
    required int foodItemId,
    required String name,
    required num unitPrice,
    required int quantity,
    required num lineTotal,
  }) = _FoodLine;
}

/// The server quote. Display only: the app never adds, multiplies, or applies a rate.
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required String movieTitle,
    required String hallName,
    String? showDate,
    String? showTime,
    required List<String> seatCodes,
    required num baseAmount,
    required num morningDiscount,
    required num weekendSurcharge,
    required num subtotal,
    String? promoCode,
    required num discountAmount,
    required num taxAmount,
    required num serviceFee,
    required List<FoodLine> foodLines,
    required num foodTotal,
    required num totalAmount,
    required List<FoodItem> foodItems,

    /// Signed-in customer; null for a guest.
    QuoteUser? user,
  }) = _Quote;

  factory Quote.fromDto(QuoteResponseDto dto) => Quote(
        movieTitle: dto.showtime.movieTitle ?? '',
        hallName: dto.showtime.hallName ?? '',
        showDate: dto.showtime.showDate,
        showTime: dto.showtime.showTime,
        seatCodes: dto.seats.map((s) => s.seatCode).toList()..sort(),
        baseAmount: dto.baseAmount,
        morningDiscount: dto.morningDiscount,
        weekendSurcharge: dto.weekendSurcharge,
        subtotal: dto.subtotal,
        promoCode: dto.promoCode,
        discountAmount: dto.discountAmount,
        taxAmount: dto.taxAmount,
        serviceFee: dto.serviceFee,
        foodLines: [
          for (final l in dto.foodLines)
            FoodLine(
              foodItemId: l.foodItemId,
              name: l.name,
              unitPrice: l.unitPrice,
              quantity: l.quantity,
              lineTotal: l.lineTotal,
            ),
        ],
        foodTotal: dto.foodTotal,
        totalAmount: dto.totalAmount,
        foodItems: [
          for (final f in dto.availableFoodItems)
            if (f.available)
              FoodItem(
                id: f.id,
                name: f.name,
                description: f.description,
                price: f.price,
                imageUrl: f.imageUrl,
                stockQuantity: f.stockQuantity,
              ),
        ],
        user: dto.user == null
            ? null
            : QuoteUser(name: dto.user!.name ?? '', email: dto.user!.email, phone: dto.user!.phone),
      );
}

@freezed
abstract class QuoteUser with _$QuoteUser {
  const factory QuoteUser({required String name, String? email, String? phone}) = _QuoteUser;
}

@freezed
abstract class GuestInfo with _$GuestInfo {
  const factory GuestInfo({@Default('') String name, @Default('') String phone, @Default('') String email}) =
      _GuestInfo;
}
