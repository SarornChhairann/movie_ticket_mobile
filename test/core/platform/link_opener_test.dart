import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/platform/link_opener.dart';

void main() {
  test('only http(s) links with a host are handed to the launcher', () async {
    // Rejected before url_launcher is called, so no platform plugin is needed.
    expect(await openExternalLink(''), isFalse);
    expect(await openExternalLink('not a url'), isFalse);
    expect(await openExternalLink('javascript:alert(1)'), isFalse);
    expect(await openExternalLink('file:///etc/passwd'), isFalse);
    expect(await openExternalLink('https://'), isFalse);
  });
}
