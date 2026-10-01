/// Repository return type: a value or a failure, so blocs never catch Dio
/// exceptions themselves.
sealed class Result<T, F> {
  const Result();
}

final class Ok<T, F> extends Result<T, F> {
  const Ok(this.value);

  final T value;
}

final class Err<T, F> extends Result<T, F> {
  const Err(this.failure);

  final F failure;
}
