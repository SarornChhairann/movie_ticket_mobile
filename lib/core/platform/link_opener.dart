import 'package:url_launcher/url_launcher.dart';

/// Opens a web link outside the app. Returns false when the link is not
/// http(s) or nothing on the device can open it.
typedef OpenLink = Future<bool> Function(String url);

/// Default [OpenLink]: hands http(s) links to the browser or the video app.
Future<bool> openExternalLink(String url) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty) {
    return false;
  }
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    return false;
  }
}
