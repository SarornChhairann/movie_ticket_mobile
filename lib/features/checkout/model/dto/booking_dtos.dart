import 'package:json_annotation/json_annotation.dart';

part 'booking_dtos.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class ConfirmRequestDto {
  const ConfirmRequestDto({
    required this.seatIds,
    this.guestName,
    this.guestPhone,
    this.guestEmail,
    this.promoCode,
    required this.paymentMethod,
    this.foodItems,
  });

  final List<int> seatIds;
  final String? guestName;
  final String? guestPhone;
  final String? guestEmail;
  final String? promoCode;
  final String paymentMethod;

  /// `{ "<foodItemId>": quantity }`. No total is ever sent: the server recomputes it.
  final Map<String, int>? foodItems;

  Map<String, dynamic> toJson() => _$ConfirmRequestDtoToJson(this);
}
