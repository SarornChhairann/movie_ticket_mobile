// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$QuoteRequestDtoToJson(QuoteRequestDto instance) =>
    <String, dynamic>{
      'seatIds': instance.seatIds,
      'promoCode': ?instance.promoCode,
      'foodItems': ?instance.foodItems,
    };

QuoteResponseDto _$QuoteResponseDtoFromJson(Map<String, dynamic> json) =>
    QuoteResponseDto(
      showtime: QuoteShowtimeDto.fromJson(
        json['showtime'] as Map<String, dynamic>,
      ),
      seats:
          (json['seats'] as List<dynamic>?)
              ?.map((e) => QuoteSeatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      baseAmount: json['baseAmount'] as num,
      morningDiscount: json['morningDiscount'] as num,
      weekendSurcharge: json['weekendSurcharge'] as num,
      subtotal: json['subtotal'] as num,
      promoCode: json['promoCode'] as String?,
      discountAmount: json['discountAmount'] as num,
      taxAmount: json['taxAmount'] as num,
      serviceFee: json['serviceFee'] as num,
      foodLines:
          (json['foodLines'] as List<dynamic>?)
              ?.map((e) => FoodLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      foodTotal: json['foodTotal'] as num,
      totalAmount: json['totalAmount'] as num,
      availableFoodItems:
          (json['availableFoodItems'] as List<dynamic>?)
              ?.map((e) => FoodItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      user: json['user'] == null
          ? null
          : QuoteUserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

QuoteShowtimeDto _$QuoteShowtimeDtoFromJson(Map<String, dynamic> json) =>
    QuoteShowtimeDto(
      id: (json['id'] as num).toInt(),
      showDate: json['showDate'] as String?,
      showTime: json['showTime'] as String?,
      movieTitle: json['movieTitle'] as String?,
      hallName: json['hallName'] as String?,
    );

QuoteSeatDto _$QuoteSeatDtoFromJson(Map<String, dynamic> json) => QuoteSeatDto(
  id: (json['id'] as num).toInt(),
  seatCode: json['seatCode'] as String,
);

FoodLineDto _$FoodLineDtoFromJson(Map<String, dynamic> json) => FoodLineDto(
  foodItemId: (json['foodItemId'] as num).toInt(),
  name: json['name'] as String,
  unitPrice: json['unitPrice'] as num,
  quantity: (json['quantity'] as num).toInt(),
  lineTotal: json['lineTotal'] as num,
);

FoodItemDto _$FoodItemDtoFromJson(Map<String, dynamic> json) => FoodItemDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: json['price'] as num,
  imageUrl: json['imageUrl'] as String?,
  available: json['available'] as bool? ?? true,
  stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
);

QuoteUserDto _$QuoteUserDtoFromJson(Map<String, dynamic> json) => QuoteUserDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);
