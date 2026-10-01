/// Compile-time configuration. Pass values with `--dart-define`.
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

/// Returns [apiBaseUrl] or fails fast so a misconfigured build never ships
/// requests to an empty host.
String requireApiBaseUrl() {
  if (apiBaseUrl.isEmpty) {
    throw StateError(
      'API_BASE_URL is not set. Run with '
      '--dart-define=API_BASE_URL=http://10.0.2.2:8010 (Android emulator) or '
      'http://localhost:8010 (iOS simulator).',
    );
  }
  return apiBaseUrl;
}
