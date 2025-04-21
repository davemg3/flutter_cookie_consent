import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'flutter_cookie_consent_platform_interface.dart';

/// Platform-specific implementation of [FlutterCookieConsentPlatform] for mobile platforms.
///
/// This implementation uses shared_preferences to store and retrieve cookie preferences.
class MethodChannelFlutterCookieConsent extends FlutterCookieConsentPlatform {
  static const String _prefsKey = 'flutter_cookie_consent_preferences';

  /// Retrieves cookie preferences from shared preferences.
  @override
  Future<Map<String, dynamic>?> getCookiePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString(_prefsKey);
      if (preferencesJson == null) {
        return {};
      }
      return json.decode(preferencesJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting cookie preferences: $e');
      return null;
    }
  }

  /// Saves cookie preferences to shared preferences.
  @override
  Future<void> saveCookiePreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, json.encode(preferences));
    } catch (e) {
      debugPrint('Error saving cookie preferences: $e');
      rethrow;
    }
  }
}
