import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';

const sA1 = SeatView(id: 1, code: 'A1', row: 1, number: 1, couple: false, booked: false);
const sA2 = SeatView(id: 2, code: 'A2', row: 1, number: 2, couple: false, booked: false);
const sA3 = SeatView(id: 3, code: 'A3', row: 1, number: 3, couple: false, booked: true);
const cB1 = SeatView(id: 11, code: 'B1', row: 2, number: 1, couple: true, booked: false);
const cB2 = SeatView(id: 12, code: 'B2', row: 2, number: 2, couple: true, booked: false);
const cB3 = SeatView(id: 13, code: 'B3', row: 2, number: 3, couple: true, booked: false);
const cB4 = SeatView(id: 14, code: 'B4', row: 2, number: 4, couple: true, booked: true);

SeatMapData seatMap({Set<int> heldByOthers = const {}, int maxSeats = 0}) => SeatMapData(
      showtimeId: 50,
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      showDate: '2026-10-02',
      showTime: '19:30:00',
      seats: const [sA1, sA2, sA3, cB1, cB2, cB3, cB4],
      heldByOthers: heldByOthers,
      holdMinutes: 10,
      maxSeats: maxSeats,
    );

Map<String, dynamic> seatMapJson() => {
      'showtimeId': 50,
      'showtime': {
        'id': 50,
        'showDate': '2026-10-02',
        'showTime': '19:30:00',
        'normalPrice': 6.5,
        'couplePrice': 12,
        'blocked': false,
        'movieTitle': 'Dune',
        'hallId': 1,
        'hallName': 'Hall 1',
        'hallCity': 'Phnom Penh',
      },
      'seats': [
        {'id': 1, 'seatCode': 'A1', 'seatType': 'NORMAL', 'rowNumber': 1, 'status': 'AVAILABLE'},
        {'id': 3, 'seatCode': 'A3', 'seatType': 'NORMAL', 'rowNumber': 1, 'status': 'BOOKED'},
        {'id': 11, 'seatCode': 'B1', 'seatType': 'COUPLE', 'rowNumber': 2, 'status': 'AVAILABLE'},
      ],
      'heldByOthers': [2],
      'heldByMe': [],
      'sessionId': 'abc',
      'holdMinutes': 10,
      'isWeekend': false,
      'isMorning': false,
      'maxSeats': 8,
    };
