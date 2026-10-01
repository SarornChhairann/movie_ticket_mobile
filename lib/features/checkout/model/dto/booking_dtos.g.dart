// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ConfirmRequestDtoToJson(ConfirmRequestDto instance) =>
    <String, dynamic>{
      'seatIds': instance.seatIds,
      'guestName': ?instance.guestName,
      'guestPhone': ?instance.guestPhone,
      'guestEmail': ?instance.guestEmail,
      'promoCode': ?instance.promoCode,
      'paymentMethod': instance.paymentMethod,
      'foodItems': ?instance.foodItems,
    };

BookingDetailDto _$BookingDetailDtoFromJson(Map<String, dynamic> json) =>
    BookingDetailDto(
      id: (json['id'] as num).toInt(),
      showtime: QuoteShowtimeDto.fromJson(
        json['showtime'] as Map<String, dynamic>,
      ),
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
      totalAmount: json['totalAmount'] as num,
      promoCode: json['promoCode'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      status: json['status'] as String,
      bookedAt: json['bookedAt'] as String?,
      tickets:
          (json['tickets'] as List<dynamic>?)
              ?.map((e) => TicketSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

TicketSummaryDto _$TicketSummaryDtoFromJson(Map<String, dynamic> json) =>
    TicketSummaryDto(
      id: (json['id'] as num).toInt(),
      ticketCode: json['ticketCode'] as String,
      status: json['status'] as String,
      seatCode: json['seatCode'] as String?,
      seatType: json['seatType'] as String?,
    );
