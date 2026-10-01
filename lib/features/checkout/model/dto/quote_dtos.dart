import 'package:json_annotation/json_annotation.dart';

import '../../../../core/model/dto/booking_detail_dto.dart';

part 'quote_dtos.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class QuoteRequestDto {
  const QuoteRequestDto({required this.seatIds, this.promoCode, this.foodItems});

  final List<int> seatIds;
  final String? promoCode;

  /// `{ "<foodItemId>": quantity }` — JSON object keys are strings.
  final Map<String, int>? foodItems;

  Map<String, dynamic> toJson() => _$QuoteRequestDtoToJson(this);
}

/// `POST /bookings/quote/{showtimeId}` body. Every amount is server-computed.
@JsonSerializable(createToJson: false)
class QuoteResponseDto {
  const QuoteResponseDto({
    required this.showtime,
    this.seats = const [],
    required this.baseAmount,
    required this.morningDiscount,
    required this.weekendSurcharge,
    required this.subtotal,
    this.promoCode,
    required this.discountAmount,
    required this.taxAmount,
    required this.serviceFee,
    this.foodLines = const [],
    required this.foodTotal,
    required this.totalAmount,
    this.availableFoodItems = const [],
    this.user,
  });

  factory QuoteResponseDto.fromJson(Map<String, dynamic> json) => _$QuoteResponseDtoFromJson(json);

  final ShowtimeInfoDto showtime;
  final List<QuoteSeatDto> seats;
  final num baseAmount;
  final num morningDiscount;
  final num weekendSurcharge;
  final num subtotal;
  final String? promoCode;
  final num discountAmount;
  final num taxAmount;
  final num serviceFee;
  final List<FoodLineDto> foodLines;
  final num foodTotal;
  final num totalAmount;
  final List<FoodItemDto> availableFoodItems;
  final QuoteUserDto? user;
}

@JsonSerializable(createToJson: false)
class QuoteSeatDto {
  const QuoteSeatDto({required this.id, required this.seatCode});

  factory QuoteSeatDto.fromJson(Map<String, dynamic> json) => _$QuoteSeatDtoFromJson(json);

  final int id;
  final String seatCode;
}

@JsonSerializable(createToJson: false)
class FoodLineDto {
  const FoodLineDto({
    required this.foodItemId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  factory FoodLineDto.fromJson(Map<String, dynamic> json) => _$FoodLineDtoFromJson(json);

  final int foodItemId;
  final String name;
  final num unitPrice;
  final int quantity;
  final num lineTotal;
}

@JsonSerializable(createToJson: false)
class FoodItemDto {
  const FoodItemDto({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.available = true,
    this.stockQuantity = 0,
  });

  factory FoodItemDto.fromJson(Map<String, dynamic> json) => _$FoodItemDtoFromJson(json);

  final int id;
  final String name;
  final String? description;
  final num price;
  final String? imageUrl;
  final bool available;

  /// 0 = unlimited.
  final int stockQuantity;
}

@JsonSerializable(createToJson: false)
class QuoteUserDto {
  const QuoteUserDto({required this.id, this.name, this.email, this.phone});

  factory QuoteUserDto.fromJson(Map<String, dynamic> json) => _$QuoteUserDtoFromJson(json);

  final int id;
  final String? name;
  final String? email;
  final String? phone;
}
