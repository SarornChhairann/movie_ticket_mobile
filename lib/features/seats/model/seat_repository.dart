import 'dart:async';

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

  final _holdChanges = StreamController<Hold>.broadcast();

  /// A hold changed outside the seat map (an extend from checkout), so the map's
  /// countdown follows it.
  Stream<Hold> get holdChanges => _holdChanges.stream;

  /// Holding again keeps the running expiry on the server (one clock per visit).
  Future<Result<Hold, ApiFailure>> hold(int showtimeId, Set<int> seatIds) =>
      _postHold('/api/seat-holds/hold', showtimeId, seatIds);

  /// The one extend for [hold] (`POST /api/seat-holds/extend`): 409 `HOLD_EXTEND_LIMIT`
  /// when it was used, 409 `HOLD_EXPIRED` when nothing is held.
  Future<Result<Hold, ApiFailure>> extend(Hold hold) async {
    final result = await _postHold('/api/seat-holds/extend', hold.showtimeId, hold.seatIds);
    if (result case Ok(:final value)) _holdChanges.add(value);
    return result;
  }

  Future<Result<Hold, ApiFailure>> _postHold(String path, int showtimeId, Set<int> seatIds) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: SeatIdsRequestDto(showtimeId: showtimeId, seatIds: seatIds.toList()..sort()).toJson(),
      );
      final dto = HoldResponseDto.fromJson(response.data!);
      return Ok(Hold(
        showtimeId: dto.showtimeId,
        seatIds: seatIds,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(dto.expiresAtEpochMs),
        extended: dto.extended,
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

  /// Seats this session holds right now, or null on failure.
  Future<Set<int>?> heldByMe(int showtimeId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/seat-holds/state',
        queryParameters: {'showtimeId': showtimeId},
      );
      return HoldStateDto.fromJson(response.data!).heldByMe.toSet();
    } on DioException {
      return null;
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
