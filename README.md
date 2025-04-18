# Flutter Cookie Consent

A Flutter plugin for displaying cookie consent banners and managing cookie preferences in your Flutter applications.

## Features

- Display customizable cookie consent banners
- Support for multiple cookie categories (Essential, Analytics, Marketing)
- Customizable banner position (top or bottom)
- Settings dialog for detailed cookie preferences
- Persistent storage of user preferences
- Platform-specific implementations (Web, Android, iOS)

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_cookie_consent: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:flutter_cookie_consent/flutter_cookie_consent.dart';

// Initialize the cookie consent
final cookieConsent = FlutterCookieConsent();

// Create a banner in your widget tree
cookieConsent.createBanner(
  context: context,
  title: 'Cookie Consent',
  message: 'We use cookies to enhance your experience...',
  acceptButtonText: 'Accept All',
  declineButtonText: 'Decline',
  settingsButtonText: 'Settings',
);
```

### Customization

You can customize the banner appearance and behavior:

```dart
cookieConsent.createBanner(
  context: context,
  title: 'Cookie Consent',
  message: 'We use cookies to enhance your experience...',
  acceptButtonText: 'Accept All',
  declineButtonText: 'Decline',
  settingsButtonText: 'Settings',
  showSettings: true,
  position: BannerPosition.bottom,
  style: CookieConsentStyle(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    buttonColor: Colors.blue,
    buttonTextColor: Colors.white,
  ),
  onAccept: (value) {
    // Handle accept
  },
  onDecline: (value) {
    // Handle decline
  },
  onSettings: () {
    // Handle settings
  },
);
```

### Checking Consent Status

```dart
if (cookieConsent.hasConsent) {
  // User has given consent
  final preferences = cookieConsent.preferences;
  // Use preferences to determine which cookies to set
}
```

## API Reference

### FlutterCookieConsent

The main class for managing cookie consent.

#### Methods

- `initialize()`: Initialize the cookie consent manager
- `savePreferences(Map<String, bool> preferences)`: Save user cookie preferences
- `createBanner({...})`: Create a cookie consent banner

#### Properties

- `hasConsent`: Check if user has given consent
- `preferences`: Get current cookie preferences
- `shouldShowBanner`: Check if banner should be shown

### BannerPosition

Enum for specifying banner position:
- `top`: Display banner at the top of the screen
- `bottom`: Display banner at the bottom of the screen

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

