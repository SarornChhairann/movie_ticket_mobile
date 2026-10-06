import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/checkout/model/payway.dart';

void main() {
  const session = PaywaySession(
    bookingId: 1,
    tranId: 'CK1T1',
    amount: 12.5,
    checkoutUrl: 'https://checkout-sandbox.payway.com.kh/eyJzdGF0dXMi',
    abaDeeplink: 'abamobilebank://ababank.com?type=payway&qrcode=000201',
  );

  PaywayNavigation decide(String url, {required bool canOpenAba, bool isMainFrame = true}) =>
      decidePaywayNavigation(url, session: session, canOpenAba: canOpenAba, isMainFrame: isMainFrame);

  test('ABA installed: the deeplink leaves for the app', () {
    expect(decide(session.abaDeeplink, canOpenAba: true), PaywayNavigation.openApp);
    expect(decide('abamobile://pay?x=1', canOpenAba: true), PaywayNavigation.openApp);
  });

  test('ABA missing: the deeplink is blocked and the KHQR page stays', () {
    expect(decide(session.abaDeeplink, canOpenAba: false), PaywayNavigation.block);
    expect(decide('abamobile://pay?x=1', canOpenAba: false), PaywayNavigation.block);
  });

  test('https on the PayWay host stays in the web view; anything else is blocked', () {
    for (final canOpenAba in [true, false]) {
      expect(decide(session.checkoutUrl, canOpenAba: canOpenAba), PaywayNavigation.allow);
      expect(decide('https://checkout-sandbox.payway.com.kh/next', canOpenAba: canOpenAba), PaywayNavigation.allow);
      expect(decide('https://example.com/', canOpenAba: canOpenAba), PaywayNavigation.block);
      expect(decide('http://checkout-sandbox.payway.com.kh/', canOpenAba: canOpenAba), PaywayNavigation.block);
      expect(decide('intent://scan#Intent;end', canOpenAba: canOpenAba), PaywayNavigation.block);
    }
  });

  test('the return deeplink means back in CineKH', () {
    expect(decide('cinekh://payway/return', canOpenAba: true), PaywayNavigation.returned);
  });

  test('sub-frame loads are never blocked', () {
    expect(decide('https://example.com/widget', canOpenAba: false, isMainFrame: false), PaywayNavigation.allow);
  });
}
