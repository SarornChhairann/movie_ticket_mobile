import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/booking_summary.dart';

/// Whose copy a cached booking is. Only one account is signed in at a time, and
/// sign-out removes its copies, so the account needs no further key.
enum BookingOwner { account, guest }

/// A booking kept on the device, with what a guest needs to look it up again.
class CachedBooking {
  const CachedBooking({required this.owner, required this.booking, this.phone});

  final BookingOwner owner;
  final BookingSummary booking;

  /// The guest phone the booking was found or made with; null for the account.
  final String? phone;
}

/// The device copy of bookings (sprint 13): the list in secure storage, each
/// ticket's QR PNG in the app documents folder. Read only when the network is
/// unreachable; every successful read from the server overwrites it.
class BookingCache {
  BookingCache(this._storage, this._documentsDir);

  static const _key = 'tickets.cache.v1';

  final FlutterSecureStorage _storage;

  /// The app documents folder (`getApplicationDocumentsDirectory` in the app).
  final Future<Directory> Function() _documentsDir;

  Future<List<CachedBooking>> entries(BookingOwner owner) async =>
      [for (final e in await _readAll()) if (e.owner == owner) e];

  /// Saves [booking] under [owner], replacing an earlier copy. A booking that is no
  /// longer confirmed keeps its entry (the list shows it cancelled) but loses its QR files.
  Future<void> put(BookingOwner owner, BookingSummary booking, {String? phone}) => putAll(owner, [booking], phone: phone);

  Future<void> putAll(BookingOwner owner, List<BookingSummary> bookings, {String? phone}) async {
    if (bookings.isEmpty) return;
    final all = await _readAll();
    for (final booking in bookings) {
      final i = all.indexWhere((e) => e.booking.bookingId == booking.bookingId);
      final keepPhone = phone ?? (i >= 0 ? all[i].phone : null);
      final entry = CachedBooking(owner: owner, booking: booking, phone: keepPhone);
      if (i >= 0) {
        all[i] = entry;
      } else {
        all.add(entry);
      }
      if (booking.status != BookingStatus.confirmed) await _deleteQrs(booking);
    }
    await _writeAll(all);
  }

  /// A guest removes a booking from this phone (swipe).
  Future<void> remove(int bookingId) async {
    final all = await _readAll();
    for (final e in all.where((e) => e.booking.bookingId == bookingId)) {
      await _deleteQrs(e.booking);
    }
    await _writeAll([for (final e in all) if (e.booking.bookingId != bookingId) e]);
  }

  /// Sign-out: the account's bookings leave the device; guest bookings stay.
  Future<void> clearAccount() async {
    final all = await _readAll();
    for (final e in all.where((e) => e.owner == BookingOwner.account)) {
      await _deleteQrs(e.booking);
    }
    await _writeAll([for (final e in all) if (e.owner == BookingOwner.guest) e]);
  }

  Future<Uint8List?> readQr(String ticketCode) async {
    final file = await _qrFile(ticketCode);
    return await file.exists() ? file.readAsBytes() : null;
  }

  Future<bool> hasQr(String ticketCode) async => (await _qrFile(ticketCode)).exists();

  /// When the QR for [ticketCode] was saved, or null when it is not on the device.
  Future<DateTime?> qrSavedAt(String ticketCode) async {
    final file = await _qrFile(ticketCode);
    return await file.exists() ? file.lastModified() : null;
  }

  Future<void> writeQr(String ticketCode, Uint8List png) async {
    final file = await _qrFile(ticketCode);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(png, flush: true);
  }

  Future<void> _deleteQrs(BookingSummary booking) async {
    for (final t in booking.tickets) {
      final file = await _qrFile(t.code);
      if (await file.exists()) await file.delete();
    }
  }

  Future<File> _qrFile(String ticketCode) async {
    final safe = ticketCode.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final dir = await _documentsDir();
    return File('${dir.path}/ticket_qr/$safe.png');
  }

  Future<List<CachedBooking>> _readAll() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return [];
    try {
      return [
        for (final item in jsonDecode(raw) as List<dynamic>)
          if (_decode(item as Map<String, dynamic>) case final CachedBooking entry) entry,
      ];
    } on FormatException {
      return [];
    }
  }

  Future<void> _writeAll(List<CachedBooking> all) =>
      _storage.write(key: _key, value: jsonEncode([for (final e in all) _encode(e)]));

  static Map<String, dynamic> _encode(CachedBooking e) {
    final b = e.booking;
    return {
      'owner': e.owner.name,
      'phone': e.phone,
      'bookingId': b.bookingId,
      'reference': b.reference,
      'status': b.status.name,
      'movieTitle': b.movieTitle,
      'hallName': b.hallName,
      'showDate': b.showDate,
      'showTime': b.showTime,
      'totalAmount': b.totalAmount,
      'bookedAt': b.bookedAt,
      'refund': b.refund.name,
      'tickets': [
        for (final t in b.tickets) {'code': t.code, 'seatCode': t.seatCode, 'status': t.status},
      ],
    };
  }

  static CachedBooking? _decode(Map<String, dynamic> json) {
    final owner = BookingOwner.values.asNameMap()[json['owner']];
    final id = json['bookingId'];
    if (owner == null || id is! int) return null;
    final reference = json['reference'] as String? ?? '';
    return CachedBooking(
      owner: owner,
      phone: json['phone'] as String?,
      booking: BookingSummary(
        bookingId: id,
        reference: reference,
        status: BookingStatus.values.asNameMap()[json['status']] ?? BookingStatus.unknown,
        movieTitle: json['movieTitle'] as String? ?? '',
        hallName: json['hallName'] as String? ?? '',
        showDate: json['showDate'] as String?,
        showTime: json['showTime'] as String?,
        totalAmount: json['totalAmount'] as num? ?? 0,
        bookedAt: json['bookedAt'] as String?,
        refund: RefundState.values.asNameMap()[json['refund']] ?? RefundState.none,
        tickets: [
          for (final t in json['tickets'] as List<dynamic>? ?? const [])
            TicketPass(
              code: (t as Map<String, dynamic>)['code'] as String,
              seatCode: t['seatCode'] as String? ?? '',
              status: t['status'] as String? ?? '',
              bookingReference: reference,
            ),
        ],
      ),
    );
  }
}
