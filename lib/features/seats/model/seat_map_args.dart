/// Seat map route argument: the chosen showtime plus the other showtimes of the
/// same day from the detail screen, so the time chips switch between real
/// showtimes and never invent one.
class SeatMapArgs {
  const SeatMapArgs({required this.showtimeId, this.date, this.options = const [], this.posterUrl});

  final int showtimeId;

  /// The movie's poster, for the booking capsule (sprint 16).
  final String? posterUrl;
  final DateTime? date;
  final List<ShowtimeOption> options;
}

class ShowtimeOption {
  const ShowtimeOption({required this.id, required this.time, required this.hallName});

  final int id;

  /// `HH:mm`, cinema local time.
  final String time;
  final String hallName;
}
