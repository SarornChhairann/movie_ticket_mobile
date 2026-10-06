// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payway_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaywayStartResponseDto _$PaywayStartResponseDtoFromJson(
  Map<String, dynamic> json,
) => PaywayStartResponseDto(
  bookingId: (json['bookingId'] as num).toInt(),
  reference: json['reference'] as String?,
  tranId: json['tranId'] as String,
  amount: json['amount'] as num,
  checkoutUrl: json['checkoutUrl'] as String,
  abaDeeplink: json['abaDeeplink'] as String?,
);

PaywayStatusDto _$PaywayStatusDtoFromJson(Map<String, dynamic> json) =>
    PaywayStatusDto(
      status: json['status'] as String,
      confirmation: json['confirmation'] == null
          ? null
          : BookingDetailDto.fromJson(
              json['confirmation'] as Map<String, dynamic>,
            ),
    );
