import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../../../core/session/session_id_provider.dart';
import 'dto/seat_dtos.dart';
import 'seat_map.dart';
import 'seat_realtime.dart';

/// Seat map, hold, release, and live seat changes. `X-Session-Id` is added to
/// every call by the network layer.
class SeatRepository {
  SeatRepository(this._dio, this._sessionIdProvider, this._realtime);

  final Dio _dio;
  final SessionIdProvider _sessionIdProvider;
  final SeatRealtime _realtime;

  /// This client's hold owner id; events carrying it are our own.
  String get sessionId => _sessionIdProvider.sessionId;

  Future<Result<SeatMapData, ApiFailure>> loadMap(int showtimeId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/bookings/seats/$showtimeId');
      return Ok(SeatMapData.fromDto(SeatMapResponseDto.fromJson(response.data!)));
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }

  Future<Result<Hold, ApiFailure>> hold(int showtimeId, Set<int> seatIds) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/seat-holds/hold',
        data: SeatIdsRequestDto(showtimeId: showtimeId, seatIds: seatIds.toList()..sort()).toJson(),
      );
      final dto = HoldResponseDto.fromJson(response.data!);
      return Ok(Hold(
        showtimeId: dto.showtimeId,
        seatIds: seatIds,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(dto.expiresAtEpochMs),
      ));
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }

  Future<void> release(int showtimeId, Set<int> seatIds) async {
    if (seatIds.isEmpty) {
      return;
    }
    try {
      await _dio.post<void>(
        '/api/seat-holds/release',
        data: SeatIdsRequestDto(showtimeId: showtimeId, seatIds: seatIds.toList()..sort()).toJson(),
      );
    } on DioException {
      // Best effort: the server TTL frees the seats anyway.
    }
  }

  /// Seats other sessions hold right now, or null on failure.
  Future<Set<int>?> heldByOthers(int showtimeId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/seat-holds/state',
        queryParameters: {'showtimeId': showtimeId},
      );
      return HoldStateDto.fromJson(response.data!).heldByOthers.toSet();
    } on DioException {
      return null;
    }
  }

  Stream<SeatEvent> watch(int showtimeId) =>
      _realtime.watch(showtimeId, () => heldByOthers(showtimeId));
}
