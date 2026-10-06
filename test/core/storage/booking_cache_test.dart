import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/storage/booking_cache.dart';

import '../../features/tickets/tickets_fixtures.dart';

void main() {
  late Directory docs;
  late BookingCache cache;
  final png = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    docs = await Directory.systemTemp.createTemp('booking_cache_test');
    cache = BookingCache(const FlutterSecureStorage(), () async => docs);
  });

  tearDown(() => docs.delete(recursive: true));

  test('a booking reads back with every field the screens show', () async {
    final booking = testBooking(id: 7, refund: RefundState.pending).copyWith(reference: 'AB3DEF7H');

    await cache.put(BookingOwner.guest, booking, phone: '012345678');
    final entry = (await cache.entries(BookingOwner.guest)).single;

    expect(entry.booking, booking.copyWith(
      tickets: [for (final t in booking.tickets) t.copyWith(bookingReference: 'AB3DEF7H')],
    ));
    expect(entry.phone, '012345678');
    expect(await cache.entries(BookingOwner.account), isEmpty);
  });

  test('a later copy replaces the earlier one and keeps the phone', () async {
    await cache.put(BookingOwner.guest, testBooking(id: 7), phone: '012');
    await cache.put(BookingOwner.guest, testBooking(id: 7, status: BookingStatus.cancelled));

    final entry = (await cache.entries(BookingOwner.guest)).single;
    expect(entry.booking.status, BookingStatus.cancelled);
    expect(entry.phone, '012');
  });

  test('a cancelled booking loses its QR files', () async {
    await cache.put(BookingOwner.account, testBooking(id: 7));
    await cache.writeQr('T-7-1', png);
    expect(await cache.readQr('T-7-1'), png);

    await cache.put(BookingOwner.account, testBooking(id: 7, status: BookingStatus.cancelled, ticketStatus: 'CANCELLED'));

    expect(await cache.readQr('T-7-1'), isNull);
  });

  test('sign-out clears the account copies and QRs; guest bookings stay', () async {
    await cache.put(BookingOwner.account, testBooking(id: 1));
    await cache.put(BookingOwner.guest, testBooking(id: 2), phone: '012');
    await cache.writeQr('T-1-1', png);
    await cache.writeQr('T-2-1', png);

    await cache.clearAccount();

    expect(await cache.entries(BookingOwner.account), isEmpty);
    expect((await cache.entries(BookingOwner.guest)).single.booking.bookingId, 2);
    expect(await cache.hasQr('T-1-1'), isFalse);
    expect(await cache.hasQr('T-2-1'), isTrue);
  });

  test('remove takes one booking and its QRs off the phone', () async {
    await cache.put(BookingOwner.guest, testBooking(id: 2), phone: '012');
    await cache.writeQr('T-2-1', png);

    await cache.remove(2);

    expect(await cache.entries(BookingOwner.guest), isEmpty);
    expect(await cache.hasQr('T-2-1'), isFalse);
  });
}
