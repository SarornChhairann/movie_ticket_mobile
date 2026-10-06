import 'dart:async';

import 'package:flutter/widgets.dart';

/// Bottom-bar tab indexes, shared with screens that sit above the shell.
abstract final class ShellTabIndex {
  static const home = 0;
  static const explore = 1;
  static const bookings = 2;
  static const profile = 3;
}

/// A screen above the shell asks it to show a tab — e.g. Success → Bookings.
/// [flightFrom] is the global rect of what should fly into the tab icon.
class ShellTabRequest {
  const ShellTabRequest(this.index, {this.flightFrom});

  final int index;
  final Rect? flightFrom;
}

/// App-wide channel for [ShellTabRequest]s (sprint 16). Registered once in
/// GetIt and handed to the shell and the success screen by the router.
class ShellTabs {
  final _requests = StreamController<ShellTabRequest>.broadcast();

  Stream<ShellTabRequest> get requests => _requests.stream;

  void open(int index, {Rect? flightFrom}) => _requests.add(ShellTabRequest(index, flightFrom: flightFrom));

  Future<void> dispose() => _requests.close();
}
