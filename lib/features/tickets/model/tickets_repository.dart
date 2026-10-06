import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/model/dto/booking_detail_dto.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../../../core/storage/booking_cache.dart';
import 'tickets_failure.dart';

/// Bookings to show, and whether they are the device copy because the server
/// could not be reached.
typedef BookingList = ({List<BookingSummary> bookings, bool offline});

/// A ticket's QR, and whether it is the device copy.
typedef TicketQr = ({Uint8List png, bool offline});

/// Network first. The [BookingCache] is written on every successful read and
/// read back only when there is no connection (timeout, refused, DNS) — never
/// on a server answer such as a 4xx (sprint 13).
class TicketsRepository {
  TicketsRepository(this._dio, this._cache);

  final Dio _dio;
  final BookingCache _cache;

  /// The signed-in user's bookings, in the server's order (newest first).
  Future<Result<BookingList, TicketsFailure>> myBookings() async {
    try {
      final response = await _dio.get<List<dynamic>>('/bookings/my-bookings');
      final bookings = [
        for (final json in response.data ?? const [])
          BookingSummary.fromDto(BookingDetailDto.fromJson(json as Map<String, dynamic>)),
      ];
      await _cache.putAll(BookingOwner.account, bookings);
      _prefetchQrs(bookings);
      return Ok((bookings: bookings, offline: false));
    } on DioException catch (e) {
      final failure = ApiFailure.fromDioException(e);
      if (failure is ApiFailureNetwork) {
        final cached = await _cache.entries(BookingOwner.account);
        return Ok((bookings: _newestFirst([for (final c in cached) c.booking]), offline: true));
      }
      return Err(TicketsFailure.fromApi(failure));
    }
  }

  /// Bookings a guest made or found on this phone, each refreshed by reference +
  /// phone. Offline (or a server miss) keeps the device copy of that booking.
  Future<Result<BookingList, TicketsFailure>> guestBookings() async {
    final cached = await _cache.entries(BookingOwner.guest);
    var offline = false;
    final bookings = <BookingSummary>[];
    for (final entry in cached) {
      final phone = entry.phone;
      if (offline || phone == null || entry.booking.reference.isEmpty) {
        bookings.add(entry.booking);
        continue;
      }
      switch (await _lookup(entry.booking.reference, phone)) {
        case Ok(:final value):
          bookings.add(value);
        case Err(failure: TicketsNetwork()):
          offline = true;
          bookings.add(entry.booking);
        case Err():
          bookings.add(entry.booking);
      }
    }
    return Ok((bookings: _newestFirst(bookings), offline: offline));
  }

  /// Finds a booking by [reference] + [phone] and keeps it on this phone.
  Future<Result<BookingSummary, TicketsFailure>> lookup(String reference, String phone) =>
      _lookup(reference.trim(), phone.trim());

  Future<Result<BookingSummary, TicketsFailure>> _lookup(String reference, String phone) => _guard(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '/bookings/lookup',
          data: {'reference': reference, 'phone': phone},
        );
        final booking = BookingSummary.fromDto(BookingDetailDto.fromJson(response.data!));
        await _cache.put(BookingOwner.guest, booking, phone: phone);
        _prefetchQrs([booking]);
        return booking;
      });

  /// A guest removes a booking from this phone. The booking itself is untouched.
  Future<void> forget(int bookingId) => _cache.remove(bookingId);

  Future<Result<BookingSummary, TicketsFailure>> booking(int id) => _guard(() async {
        final response = await _dio.get<Map<String, dynamic>>('/bookings/confirmation/$id');
        final booking = BookingSummary.fromDto(BookingDetailDto.fromJson(response.data!));
        await _cache.put(BookingOwner.account, booking);
        return booking;
      });

  /// Cancels booking [id]; the value is the server's confirmation message.
  Future<Result<String, TicketsFailure>> cancel(int id) => _guard(() async {
        final response = await _dio.post<Map<String, dynamic>>('/bookings/cancel/$id');
        return (response.data?['message'] as String?) ?? '';
      });

  /// The ticket's QR as PNG bytes; the device copy when there is no connection.
  Future<Result<TicketQr, TicketsFailure>> qrBytes(String code) async {
    try {
      final png = await _fetchQr(code);
      await _cache.writeQr(code, png);
      return Ok((png: png, offline: false));
    } on DioException catch (e) {
      final failure = ApiFailure.fromDioException(e);
      if (failure is ApiFailureNetwork) {
        final cached = await _cache.readQr(code);
        if (cached != null) return Ok((png: cached, offline: true));
      }
      return Err(TicketsFailure.fromApi(failure));
    }
  }

  /// The URL is only ever built here.
  Future<Uint8List> _fetchQr(String code) async {
    final response = await _dio.get<List<int>>(
      '/tickets/${Uri.encodeComponent(code)}/qr',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  /// Saves the QR of every active ticket not on the device yet, in the background,
  /// so a booking that was opened once still shows its tickets offline.
  void _prefetchQrs(List<BookingSummary> bookings) {
    unawaited(() async {
      for (final booking in bookings.where((b) => b.status == BookingStatus.confirmed)) {
        for (final t in booking.tickets.where((t) => !t.cancelled)) {
          try {
            if (await _cache.hasQr(t.code)) continue;
            await _cache.writeQr(t.code, await _fetchQr(t.code));
          } on Object {
            return; // Offline or the server refused: try again on the next read.
          }
        }
      }
    }());
  }

  static List<BookingSummary> _newestFirst(List<BookingSummary> bookings) =>
      [...bookings]..sort((a, b) => (b.bookedAt ?? '').compareTo(a.bookedAt ?? ''));

  static Future<Result<T, TicketsFailure>> _guard<T>(Future<T> Function() call) async {
    try {
      return Ok(await call());
    } on DioException catch (e) {
      return Err(TicketsFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }
}
