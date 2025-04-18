# Flutter Cookie Consent

[![pub package](https://img.shields.io/pub/v/flutter_cookie_consent.svg)](https://pub.dev/packages/flutter_cookie_consent)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

A Flutter plugin for displaying cookie consent banners and managing cookie preferences in your Flutter applications. This plugin helps you comply with GDPR, CCPA, and other privacy regulations by providing a customizable cookie consent solution.

## Features

- Display customizable cookie consent banners
- Support for multiple cookie categories (Essential, Analytics, Marketing)
- Customizable banner position (top or bottom)
- Settings dialog for detailed cookie preferences
- Persistent storage of user preferences
- Platform-specific implementations (Web, Android, iOS)
- Dark mode support
- Localization support
- Customizable animations
- Accessibility support

## Platform Support

| Platform | Support |
|----------|---------|
| Web      | ✅      |
| Android  | ✅      |
| iOS      | ✅      |
| Windows  | ✅      |
| macOS    | ✅      |
| Linux    | ✅      |

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

### Flutter Version Compatibility

| Flutter Version | Package Version |
|----------------|-----------------|
| >=3.3.0        | ^1.0.0         |

## Usage

### Basic Usage

```dart
import 'package:flutter_cookie_consent/flutter_cookie_consent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CookieConsentBanner(
          title: 'Cookie Consent',
          message: 'We use cookies to enhance your experience...',
          acceptButtonText: 'Accept All',
          declineButtonText: 'Decline',
          settingsButtonText: 'Settings',
        ),
      ),
    );
  }
}
```

### Advanced Usage

```dart
CookieConsentBanner(
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
    borderRadius: 8.0,
    padding: const EdgeInsets.all(16.0),
  ),
  categories: [
    CookieCategory(
      id: 'essential',
      title: 'Essential',
      description: 'Required for the website to function',
      isRequired: true,
    ),
    CookieCategory(
      id: 'analytics',
      title: 'Analytics',
      description: 'Help us understand how visitors interact',
    ),
    CookieCategory(
      id: 'marketing',
      title: 'Marketing',
      description: 'Used for advertising purposes',
    ),
  ],
  onAccept: (Map<String, bool> preferences) {
    // Handle accept
    print('Accepted preferences: $preferences');
  },
  onDecline: (Map<String, bool> preferences) {
    // Handle decline
    print('Declined preferences: $preferences');
  },
  onSettings: () {
    // Handle settings
    print('Settings opened');
  },
);
```

### Checking Consent Status

```dart
final cookieConsent = FlutterCookieConsent();

// Check if user has given consent
if (cookieConsent.hasConsent) {
  final preferences = cookieConsent.preferences;
  // Use preferences to determine which cookies to set
}

// Check if banner should be shown
if (cookieConsent.shouldShowBanner) {
  // Show banner
}
```

## API Reference

### FlutterCookieConsent

The main class for managing cookie consent.

#### Methods

- `initialize()`: Initialize the cookie consent manager
- `savePreferences(Map<String, bool> preferences)`: Save user cookie preferences
- `createBanner({...})`: Create a cookie consent banner
- `resetPreferences()`: Reset all cookie preferences
- `getPreferences()`: Get current cookie preferences
- `setLanguage(String languageCode)`: Set the language for the banner

#### Properties

- `hasConsent`: Check if user has given consent
- `preferences`: Get current cookie preferences
- `shouldShowBanner`: Check if banner should be shown
- `isInitialized`: Check if the consent manager is initialized

### BannerPosition

Enum for specifying banner position:
- `top`: Display banner at the top of the screen
- `bottom`: Display banner at the bottom of the screen

## Localization

The plugin supports multiple languages. To add a new language, create a new file in the `lib/l10n` directory following the naming convention `cookie_consent_<language_code>.arb`.

Example:
```json
{
  "cookieConsentTitle": "Cookie Consent",
  "cookieConsentMessage": "We use cookies to enhance your experience...",
  "acceptButtonText": "Accept All",
  "declineButtonText": "Decline",
  "settingsButtonText": "Settings"
}
```

## Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please make sure to:
- Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Write tests for new features
- Update the documentation
- Update the CHANGELOG.md

## Troubleshooting

### Common Issues

1. **Banner not showing**
   - Make sure you've initialized the consent manager
   - Check if `shouldShowBanner` is true
   - Verify that the banner is properly added to your widget tree

2. **Preferences not saving**
   - Check if you have proper storage permissions
   - Verify that the storage implementation is working correctly

3. **Localization not working**
   - Ensure the language code is supported
   - Check if the localization files are properly formatted

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please:
- Open an issue on GitHub
- Check the [documentation](https://github.com/redhotsixbull/flutter_cookie_consent#readme)
- Join our [Discord community](https://discord.gg/your-discord-link)

