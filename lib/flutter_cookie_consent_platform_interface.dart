import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_cookie_consent_method_channel.dart';
import 'flutter_cookie_consent_web.dart';

/// Platform interface for cookie consent functionality.
///
/// This interface defines the contract that platform-specific implementations
/// must follow to handle cookie consent storage and retrieval.
abstract class FlutterCookieConsentPlatform extends PlatformInterface {
  /// Constructs a FlutterCookieConsentPlatform.
  FlutterCookieConsentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCookieConsentPlatform _instance = _getPlatformImplementation();

  static FlutterCookieConsentPlatform _getPlatformImplementation() {
    if (kIsWeb) {
      return FlutterCookieConsentWeb();
    }
    return MethodChannelFlutterCookieConsent();
  }

  /// The default instance of [FlutterCookieConsentPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCookieConsent] for mobile platforms
  /// and [FlutterCookieConsentWeb] for web platform.
  static FlutterCookieConsentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCookieConsentPlatform] when
  /// they register themselves.
  static set instance(FlutterCookieConsentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Retrieves the current cookie preferences from platform storage.
  ///
  /// Returns a map of cookie types to their consent status, or null if no
  /// preferences are stored.
  Future<Map<String, dynamic>?> getCookiePreferences() {
    throw UnimplementedError(
        'getCookiePreferences() has not been implemented.');
  }

  /// Saves the given cookie preferences to platform storage.
  ///
  /// [preferences] should be a map of cookie types to their consent status.
  Future<void> saveCookiePreferences(Map<String, dynamic> preferences) {
    throw UnimplementedError(
        'saveCookiePreferences() has not been implemented.');
  }
}
