import 'package:json_annotation/json_annotation.dart';

import '../../../../core/model/dto/booking_detail_dto.dart';

part 'payway_dtos.g.dart';

/// `POST /bookings/payway/{showtimeId}`. `checkoutUrl` is PayWay's `checkout_qr_url`,
/// `abaDeeplink` its `abapay_deeplink`.
@JsonSerializable(createToJson: false)
class PaywayStartResponseDto {
  const PaywayStartResponseDto({
    required this.bookingId,
    this.reference,
    required this.tranId,
    required this.amount,
    required this.checkoutUrl,
    this.abaDeeplink,
  });

  factory PaywayStartResponseDto.fromJson(Map<String, dynamic> json) => _$PaywayStartResponseDtoFromJson(json);

  final int bookingId;
  final String? reference;
  final String tranId;
  final num amount;
  final String checkoutUrl;
  final String? abaDeeplink;
}

/// `GET /bookings/payway/{tranId}` and `POST .../close`.
@JsonSerializable(createToJson: false)
class PaywayStatusDto {
  const PaywayStatusDto({required this.status, this.confirmation});

  factory PaywayStatusDto.fromJson(Map<String, dynamic> json) => _$PaywayStatusDtoFromJson(json);

  /// `PENDING | APPROVED | DECLINED | CANCELLED`.
  final String status;

  /// The confirm body; only with `APPROVED`.
  final BookingDetailDto? confirmation;
}
