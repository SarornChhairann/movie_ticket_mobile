/// Repository return type: a value or a failure, so blocs never catch Dio
/// exceptions themselves.
sealed class Result<T, F> {
  const Result();
}

final class Ok<T, F> extends Result<T, F> {
  const Ok(this.value, {this.savedAt});

  final T value;

  /// Set when [value] is the copy saved on this phone because the server could
  /// not be reached (sprint 21): when that copy was saved. Null for fresh data.
  final DateTime? savedAt;
}

final class Err<T, F> extends Result<T, F> {
  const Err(this.failure);

  final F failure;
}
