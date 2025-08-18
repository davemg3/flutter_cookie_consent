// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'package:universal_html/html.dart' as html;
// Use typed Registrar on web, empty stub on other platforms (e.g., tests)
import 'src/web_registrar_stub.dart'
    if (dart.library.ui_web) 'src/web_registrar_real.dart';
import 'package:flutter/foundation.dart';

import 'flutter_cookie_consent_platform_interface.dart';

/// A web implementation of the FlutterCookieConsentPlatform of the FlutterCookieConsent plugin.
class FlutterCookieConsentWeb extends FlutterCookieConsentPlatform {
  static const String _storageKey = 'flutter_cookie_consent_preferences';

  /// Constructs a FlutterCookieConsentWeb
  FlutterCookieConsentWeb();

  static void registerWith(Registrar registrar) {
    FlutterCookieConsentPlatform.instance = FlutterCookieConsentWeb();
  }

  @override
  Future<Map<String, dynamic>?> getCookiePreferences() async {
    try {
      final storage = html.window.localStorage;

      final preferences = storage[_storageKey];
      if (preferences == null) {
        debugPrint('No cookie preferences found in local storage');
        return null;
      }

      try {
        return Map<String, dynamic>.from(
          const JsonDecoder().convert(preferences),
        );
      } on FormatException catch (e) {
        debugPrint('Error parsing cookie preferences: ${e.message}');
        return null;
      }
    } on Exception catch (e) {
      debugPrint('Error accessing local storage: $e');
      return null;
    }
  }

  @override
  Future<void> saveCookiePreferences(Map<String, dynamic> preferences) async {
    try {
      final storage = html.window.localStorage;

      try {
        final jsonString = const JsonEncoder().convert(preferences);
        storage[_storageKey] = jsonString;
      } on Exception catch (e) {
        debugPrint('Error converting preferences to JSON: $e');
        rethrow;
      }
    } on Exception catch (e) {
      debugPrint('Error saving cookie preferences: $e');
      rethrow;
    }
  }
}
