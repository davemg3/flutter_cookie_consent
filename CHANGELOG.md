# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-05-18

### Changed

- Improved web platform implementation to use localStorage directly

## [1.0.1] - 2025-04-21

### Added

- Added shared_preferences support for mobile platforms (Android/iOS)
- Improved storage implementation for cookie preferences

### Changed

- Updated platform support information in README
- Improved documentation and examples

### Fixed

- Fixed cookie preferences persistence on mobile platforms
- Fixed platform-specific storage implementation

## [1.0.0] - 2025-04-18

### Added

- Initial release of Flutter Cookie Consent
- Basic cookie consent banner implementation
- Support for multiple cookie categories (Essential, Analytics, Marketing)
- Customizable banner position (top/bottom)
- Settings dialog for detailed cookie preferences
- Persistent storage of user preferences
- Platform-specific implementations for Web, Android, and iOS
- Comprehensive documentation and examples
- Dark mode support
- Localization support
- Customizable animations
- Accessibility support
- Windows, macOS, and Linux platform support

### Changed

- Improved banner UI/UX design
- Enhanced performance and memory usage
- Optimized storage implementation
- Updated dependencies to latest versions
- Converted all UI text and comments to English

### Fixed

- Fixed banner positioning issues on some devices
- Resolved storage permission problems on Android
- Fixed localization loading issues
- Addressed accessibility concerns

### Security

- Implemented secure storage for user preferences
- Added data encryption for sensitive information
- Enhanced privacy protection measures

## [0.0.1] - 2025-04-18

### Added

- Initial project setup
- Basic cookie consent functionality
- Web platform implementation
- Android platform implementation
- iOS platform implementation
- Basic documentation

### Changed

- Initial release
