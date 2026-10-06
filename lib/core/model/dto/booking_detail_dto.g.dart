// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowtimeInfoDto _$ShowtimeInfoDtoFromJson(Map<String, dynamic> json) =>
    ShowtimeInfoDto(
      id: (json['id'] as num).toInt(),
      showDate: json['showDate'] as String?,
      showTime: json['showTime'] as String?,
      movieTitle: json['movieTitle'] as String?,
      hallName: json['hallName'] as String?,
    );

BookingDetailDto _$BookingDetailDtoFromJson(Map<String, dynamic> json) =>
    BookingDetailDto(
      id: (json['id'] as num).toInt(),
      reference: json['reference'] as String?,
      showtime: ShowtimeInfoDto.fromJson(
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
      paymentStatus: json['paymentStatus'] as String?,
    );

TicketSummaryDto _$TicketSummaryDtoFromJson(Map<String, dynamic> json) =>
    TicketSummaryDto(
      id: (json['id'] as num).toInt(),
      ticketCode: json['ticketCode'] as String,
      status: json['status'] as String,
      seatCode: json['seatCode'] as String?,
      seatType: json['seatType'] as String?,
    );
