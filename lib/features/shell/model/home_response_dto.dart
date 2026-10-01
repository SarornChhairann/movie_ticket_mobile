import 'package:json_annotation/json_annotation.dart';

part 'home_response_dto.g.dart';

/// `GET /` body. Only the list sizes are used in sprint 0.
@JsonSerializable(createToJson: false)
class HomeResponseDto {
  const HomeResponseDto({
    this.nowShowing = const [],
    this.comingSoon = const [],
    this.cinemas = const [],
  });

  factory HomeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseDtoFromJson(json);

  final List<Object?> nowShowing;
  final List<Object?> comingSoon;
  final List<Object?> cinemas;
}
