import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent_platform_interface.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCookieConsentPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCookieConsentPlatform {
  Map<String, dynamic>? _savedPreferences;

  @override
  Future<Map<String, dynamic>?> getCookiePreferences() =>
      Future.value(_savedPreferences);

  @override
  Future<void> saveCookiePreferences(Map<String, dynamic> preferences) async {
    _savedPreferences = Map<String, dynamic>.from(preferences);
  }
}

void main() {
  final FlutterCookieConsentPlatform initialPlatform =
      FlutterCookieConsentPlatform.instance;

  group('Platform Interface Tests', () {
    test('$MethodChannelFlutterCookieConsent is the default instance', () {
      expect(
          initialPlatform, isInstanceOf<MethodChannelFlutterCookieConsent>());
    });

    test('saveCookiePreferences', () async {
      MockFlutterCookieConsentPlatform fakePlatform =
          MockFlutterCookieConsentPlatform();
      FlutterCookieConsentPlatform.instance = fakePlatform;

      await expectLater(
        fakePlatform.saveCookiePreferences({
          'analytics': true,
          'marketing': true,
        }),
        completes,
      );
    });
  });

  group('FlutterCookieConsent Tests', () {
    late MockFlutterCookieConsentPlatform mockPlatform;
    late FlutterCookieConsent cookieConsent;

    setUp(() async {
      mockPlatform = MockFlutterCookieConsentPlatform();
      FlutterCookieConsentPlatform.instance = mockPlatform;
      cookieConsent = FlutterCookieConsent();
      await cookieConsent.initialize();
    });

    test('initialize with no saved preferences', () async {
      expect(cookieConsent.hasConsent, false);
      expect(cookieConsent.shouldShowBanner, true);
      expect(cookieConsent.bannerVisibilityNotifier.value, true);
    });

    test('initialize with saved preferences', () async {
      await cookieConsent.savePreferences({
        'essential': true,
        'analytics': true,
        'marketing': false,
      });

      final newCookieConsent = FlutterCookieConsent();
      await newCookieConsent.initialize();
      expect(newCookieConsent.hasConsent, true);
      expect(newCookieConsent.shouldShowBanner, false);
      expect(newCookieConsent.preferences['analytics'], true);
      expect(newCookieConsent.preferences['marketing'], false);
    });

    test('savePreferences updates state correctly', () async {
      final newPreferences = {
        'essential': true,
        'analytics': true,
        'marketing': true,
      };

      await cookieConsent.savePreferences(newPreferences);
      expect(cookieConsent.hasConsent, true);
      expect(cookieConsent.shouldShowBanner, false);
      expect(cookieConsent.preferences, equals(newPreferences));
    });

    test('preferences are immutable', () async {
      await cookieConsent.savePreferences({
        'essential': true,
        'analytics': false,
        'marketing': false,
      });

      final preferences = cookieConsent.preferences;
      preferences['analytics'] = true;
      expect(cookieConsent.preferences['analytics'], false);
    });
  });
}
