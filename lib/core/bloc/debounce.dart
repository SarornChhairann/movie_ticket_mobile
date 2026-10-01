import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Waits for [duration] of quiet before handling the latest event.
EventTransformer<E> debounce<E>(Duration duration) =>
    (events, mapper) => _debounced(events, duration).asyncExpand(mapper);

Stream<T> _debounced<T>(Stream<T> source, Duration duration) {
  Timer? timer;
  StreamSubscription<T>? subscription;
  late final StreamController<T> controller;
  controller = StreamController<T>(
    onListen: () {
      subscription = source.listen(
        (event) {
          timer?.cancel();
          timer = Timer(duration, () => controller.add(event));
        },
        onError: controller.addError,
        onDone: () {
          timer?.cancel();
          controller.close();
        },
      );
    },
    onCancel: () {
      timer?.cancel();
      return subscription?.cancel();
    },
  );
  return controller.stream;
}
