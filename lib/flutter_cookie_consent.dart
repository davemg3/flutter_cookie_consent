import 'package:flutter/material.dart';
import 'flutter_cookie_consent_platform_interface.dart';
import 'ui/flutter_cookie_consent_banner.dart';
import 'ui/cookie_settings_dialog.dart';

/// Represents the position where the cookie consent banner should be displayed.
///
/// The banner can be positioned either at the top or bottom of the screen.
/// This affects both the visual appearance and the user experience.
///
/// Example:
/// ```dart
/// CookieConsentBanner(
///   position: BannerPosition.bottom,
///   // ... other properties
/// )
/// ```
enum BannerPosition {
  /// Banner appears at the top of the screen
  top,

  /// Banner appears at the bottom of the screen
  bottom,
}

/// Main class for managing cookie consent in a Flutter application.
///
/// This class provides functionality to:
/// - Initialize and manage cookie preferences
/// - Display a cookie consent banner
/// - Save user preferences
/// - Check consent status
///
/// Example:
/// ```dart
/// final cookieConsent = FlutterCookieConsent();
/// await cookieConsent.initialize();
///
/// if (cookieConsent.shouldShowBanner) {
///   // Show the banner
///   cookieConsent.createBanner(
///     context: context,
///     title: 'Cookie Consent',
///     message: 'We use cookies...',
///   );
/// }
/// ```
class FlutterCookieConsent {
  static final FlutterCookieConsent _instance = FlutterCookieConsent._internal();
  factory FlutterCookieConsent() => _instance;
  FlutterCookieConsent._internal();

  /// Platform-specific implementation for cookie consent
  final FlutterCookieConsentPlatform _platform = FlutterCookieConsentPlatform.instance;

  /// Notifier for tracking banner visibility state
  final ValueNotifier<bool> _bannerVisibilityNotifier = ValueNotifier<bool>(true);

  /// Default cookie preferences with essential cookies enabled by default
  Map<String, bool> _cookiePreferences = {
    'essential': true,
    'analytics': false,
    'marketing': false,
  };

  /// Tracks if user has given consent
  bool _hasConsent = false;

  /// Controls if banner should be shown
  bool _showBanner = true;

  /// Tracks initialization state
  bool _isInitialized = false;

  /// Stores the last error message if any
  String? _lastError;

  /// Getter for banner visibility notifier
  ValueNotifier<bool> get bannerVisibilityNotifier => _bannerVisibilityNotifier;

  /// Getter for last error message
  String? get lastError => _lastError;

  /// Initializes the cookie consent manager.
  ///
  /// This method:
  /// - Loads saved preferences if they exist
  /// - Sets up initial consent state
  /// - Handles any initialization errors
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final savedPreferences = await _platform.getCookiePreferences();
      if (savedPreferences != null && savedPreferences!.isNotEmpty) {
        _cookiePreferences = Map<String, bool>.from(savedPreferences);
        _hasConsent = true;
        _showBanner = false;
      } else {
        _showBanner = true;
      }
      _bannerVisibilityNotifier.value = _showBanner;
      _isInitialized = true;
      _lastError = null;
    } catch (e) {
      _lastError = 'Failed to initialize cookie consent: $e';
      debugPrint(_lastError);
      _showBanner = true;
      _bannerVisibilityNotifier.value = true;
    }
  }

  /// Saves user's cookie preferences.
  ///
  /// [preferences] should be a map of cookie types to their consent status.
  /// Throws an exception if saving fails.
  Future<void> savePreferences(Map<String, bool> preferences) async {
    try {
      _cookiePreferences = Map<String, bool>.from(preferences);
      await _platform.saveCookiePreferences(_cookiePreferences);
      _hasConsent = true;
      _showBanner = false;
      _bannerVisibilityNotifier.value = false;
      _lastError = null;
    } catch (e) {
      _lastError = 'Failed to save cookie preferences: $e';
      debugPrint(_lastError);
      rethrow;
    }
  }

  /// Returns whether user has given consent
  bool get hasConsent => _hasConsent;

  /// Returns current cookie preferences
  Map<String, bool> get preferences => Map<String, bool>.from(_cookiePreferences);

  /// Returns whether banner should be shown
  bool get shouldShowBanner => _showBanner;

  /// Creates and returns a cookie consent banner widget.
  ///
  /// The banner can be customized with various properties:
  /// - [title]: The main heading of the banner
  /// - [message]: The descriptive text explaining cookie usage
  /// - [acceptButtonText]: Text for the accept button
  /// - [declineButtonText]: Text for the decline button
  /// - [settingsButtonText]: Text for the settings button
  /// - [showSettings]: Whether to show the settings button
  /// - [style]: Custom styling for the banner
  /// - [position]: Where to display the banner (top or bottom)
  ///
  /// Example:
  /// ```dart
  /// cookieConsent.createBanner(
  ///   context: context,
  ///   title: 'Cookie Consent',
  ///   message: 'We use cookies to enhance your experience...',
  ///   acceptButtonText: 'Accept All',
  ///   declineButtonText: 'Decline',
  ///   settingsButtonText: 'Settings',
  ///   showSettings: true,
  ///   position: BannerPosition.bottom,
  ///   style: CookieConsentStyle(
  ///     backgroundColor: Colors.white,
  ///     textColor: Colors.black,
  ///   ),
  ///   onAccept: (preferences) {
  ///     print('Accepted preferences: $preferences');
  ///   },
  /// );
  /// ```
  Widget createBanner({
    required BuildContext context,
    String? title,
    String? message,
    String? acceptButtonText,
    String? declineButtonText,
    String? settingsButtonText,
    bool showSettings = true,
    CookieConsentStyle? style,
    Function(bool)? onAccept,
    Function(bool)? onDecline,
    Function()? onSettings,
    BannerPosition position = BannerPosition.top,
  }) {
    return FutureBuilder(
      future: initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red[100],
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return _CookieConsentBanner(
          title: title ?? 'Cookie Consent',
          message: message ??
              'We use cookies to enhance your experience. By continuing to visit this site you agree to our use of cookies.',
          acceptButtonText: acceptButtonText ?? 'Accept',
          declineButtonText: declineButtonText ?? 'Decline',
          settingsButtonText: settingsButtonText ?? 'Settings',
          showSettings: showSettings,
          style: style ?? const CookieConsentStyle(),
          onAccept: onAccept,
          onDecline: onDecline,
          onSettings: onSettings,
          position: position,
        );
      },
    );
  }
}

/// A widget that displays a cookie consent banner.
///
/// This is an internal implementation of the cookie consent banner.
/// Use [FlutterCookieConsent.createBanner] to create and display the banner.
///
/// The banner includes:
/// - A title and message explaining cookie usage
/// - Accept and decline buttons
/// - An optional settings button
/// - Customizable styling
class _CookieConsentBanner extends StatefulWidget {
  final String title;
  final String message;
  final String acceptButtonText;
  final String declineButtonText;
  final String settingsButtonText;
  final bool showSettings;
  final CookieConsentStyle style;
  final Function(bool)? onAccept;
  final Function(bool)? onDecline;
  final Function()? onSettings;
  final BannerPosition position;

  const _CookieConsentBanner({
    required this.title,
    required this.message,
    required this.acceptButtonText,
    required this.declineButtonText,
    required this.settingsButtonText,
    required this.showSettings,
    required this.style,
    this.onAccept,
    this.onDecline,
    this.onSettings,
    this.position = BannerPosition.bottom,
  });

  @override
  State<_CookieConsentBanner> createState() => _CookieConsentBannerState();
}

/// The state class for [_CookieConsentBanner].
///
/// Manages the visibility state of the banner and handles user interactions.
class _CookieConsentBannerState extends State<_CookieConsentBanner> {
  late final ValueNotifier<bool> _bannerVisibilityNotifier;

  @override
  void initState() {
    super.initState();
    _bannerVisibilityNotifier = FlutterCookieConsent().bannerVisibilityNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _bannerVisibilityNotifier,
      builder: (context, shouldShow, child) {
        if (!shouldShow) {
          return const SizedBox.shrink();
        }
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: widget.position == BannerPosition.top ? 0 : null,
              bottom: widget.position == BannerPosition.bottom ? 0 : null,
              child: FlutterCookieConsentBanner(
                title: widget.title,
                message: widget.message,
                acceptButtonText: widget.acceptButtonText,
                declineButtonText: widget.declineButtonText,
                settingsButtonText: widget.settingsButtonText,
                showSettings: widget.showSettings,
                style: widget.style,
                onAccept: _handleAccept,
                onDecline: _handleDecline,
                onSettings: _handleSettings,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleAccept(bool value) {
    if (widget.onAccept != null) {
      widget.onAccept!(value);
    } else {
      FlutterCookieConsent().savePreferences({
        'essential': true,
        'analytics': true,
        'marketing': true,
      });
    }
  }

  void _handleDecline(bool value) {
    if (widget.onDecline != null) {
      widget.onDecline!(value);
    } else {
      FlutterCookieConsent().savePreferences({
        'essential': true,
        'analytics': false,
        'marketing': false,
      });
    }
  }

  void _handleSettings() {
    if (widget.onSettings != null) {
      widget.onSettings!();
    } else {
      showDialog(
        context: context,
        builder: (context) => CookieSettingsDialog(
          cookiePreferences: FlutterCookieConsent().preferences,
          onSave: (preferences) async {
            await FlutterCookieConsent().savePreferences(preferences);
          },
        ),
      );
    }
  }
}
