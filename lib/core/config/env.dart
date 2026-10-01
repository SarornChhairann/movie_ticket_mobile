import 'package:flutter/foundation.dart';

/// Compile-time override. Pass `--dart-define=API_BASE_URL=...` to point at
/// another host. Debug and profile builds fall back to the local API on 8010.
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

const String localApiBaseUrl = 'http://localhost:8010';

/// Android emulator loopback to the host machine. `localhost` inside the
/// emulator is the emulator itself, not the machine running Spring Boot.
const String androidEmulatorApiBaseUrl = 'http://10.0.2.2:8010';

/// Host the Dio client should call.
///
/// Release builds still require [apiBaseUrl] so a store build cannot silently
/// talk to a developer machine.
String requireApiBaseUrl() {
  if (apiBaseUrl.isNotEmpty) {
    return apiBaseUrl;
  }
  if (kReleaseMode) {
    throw StateError(
      'API_BASE_URL is not set. Run with '
      '--dart-define=API_BASE_URL=$androidEmulatorApiBaseUrl (Android emulator) or '
      '--dart-define=API_BASE_URL=$localApiBaseUrl (iOS simulator, desktop, Chrome).',
    );
  }
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return androidEmulatorApiBaseUrl;
  }
  return localApiBaseUrl;
}
