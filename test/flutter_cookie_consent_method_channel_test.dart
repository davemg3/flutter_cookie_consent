import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterCookieConsent platform =
      MethodChannelFlutterCookieConsent();
  const MethodChannel channel = MethodChannel('flutter_cookie_consent');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getCookiePreferences':
            return {'essential': true, 'analytics': true};
          case 'saveCookiePreferences':
            return null;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getCookiePreferences', () async {
    final preferences = await platform.getCookiePreferences();
    expect(preferences, isNotNull);
    expect(preferences!['essential'], true);
    expect(preferences['analytics'], true);
  });

  test('saveCookiePreferences', () async {
    await expectLater(
      platform.saveCookiePreferences({
        'essential': true,
        'analytics': true,
        'marketing': false,
      }),
      completes,
    );
  });
}
