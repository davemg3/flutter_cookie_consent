import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_cookie_consent_platform_interface.dart';

/// Platform-specific implementation of [FlutterCookieConsentPlatform] for mobile platforms.
///
/// This implementation uses method channels to communicate with native code
/// for storing and retrieving cookie preferences.
class MethodChannelFlutterCookieConsent extends FlutterCookieConsentPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('flutter_cookie_consent');

  /// Retrieves cookie preferences from native platform storage.
  ///
  /// Handles various platform-specific errors and returns null if preferences
  /// cannot be retrieved.
  @override
  Future<Map<String, dynamic>?> getCookiePreferences() async {
    try {
      final preferences = await _methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('getCookiePreferences');
      return preferences?.cast<String, dynamic>();
    } on PlatformException catch (e) {
      debugPrint('Error getting cookie preferences: ${e.message}');
      if (e.code == 'not_implemented') {
        debugPrint('Method not implemented on the native platform');
      } else if (e.code == 'storage_error') {
        debugPrint('Error accessing storage on the native platform');
      }
      return null;
    } catch (e) {
      debugPrint('Unexpected error getting cookie preferences: $e');
      return null;
    }
  }

  /// Saves cookie preferences to native platform storage.
  ///
  /// Throws an exception if saving fails, with detailed error information
  /// about the failure.
  @override
  Future<void> saveCookiePreferences(Map<String, dynamic> preferences) async {
    try {
      await _methodChannel.invokeMethod('saveCookiePreferences', preferences);
    } on PlatformException catch (e) {
      debugPrint('Error saving cookie preferences: ${e.message}');
      if (e.code == 'not_implemented') {
        debugPrint('Method not implemented on the native platform');
      } else if (e.code == 'storage_error') {
        debugPrint('Error accessing storage on the native platform');
      }
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error saving cookie preferences: $e');
      rethrow;
    }
  }
}
