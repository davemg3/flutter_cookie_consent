import 'package:flutter/material.dart';

class CookieConsentStyle {
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final ButtonStyle? acceptButtonStyle;
  final ButtonStyle? declineButtonStyle;
  final ButtonStyle? settingsButtonStyle;
  final EdgeInsets contentPadding;
  final double spacingBetweenElements;

  const CookieConsentStyle({
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
    this.acceptButtonStyle,
    this.declineButtonStyle,
    this.settingsButtonStyle,
    this.contentPadding = const EdgeInsets.all(16),
    this.spacingBetweenElements = 8,
  });

  static const TextStyle defaultTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle defaultMessageStyle = TextStyle(
    color: Colors.black,
  );

  static ButtonStyle get defaultAcceptButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      );

  static ButtonStyle get defaultDeclineButtonStyle => TextButton.styleFrom(
        foregroundColor: Colors.blue,
      );

  static ButtonStyle get defaultSettingsButtonStyle => TextButton.styleFrom(
        foregroundColor: Colors.blue,
      );
}

class FlutterCookieConsentBanner extends StatefulWidget {
  final String title;
  final String message;
  final String acceptButtonText;
  final String declineButtonText;
  final String settingsButtonText;
  final Function(bool) onAccept;
  final Function(bool) onDecline;
  final Function() onSettings;
  final bool showSettings;
  final CookieConsentStyle style;

  const FlutterCookieConsentBanner({
    super.key,
    this.title = 'Cookie Consent',
    this.message =
        'We use cookies to enhance your experience. By continuing to visit this site you agree to our use of cookies.',
    this.acceptButtonText = 'Accept',
    this.declineButtonText = 'Decline',
    this.settingsButtonText = 'Settings',
    required this.onAccept,
    required this.onDecline,
    required this.onSettings,
    this.showSettings = true,
    this.style = const CookieConsentStyle(),
  });

  @override
  State<FlutterCookieConsentBanner> createState() =>
      _FlutterCookieConsentBannerState();
}

class _FlutterCookieConsentBannerState
    extends State<FlutterCookieConsentBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.style.contentPadding,
      decoration: BoxDecoration(
        color: widget.style.backgroundColor ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style:
                widget.style.titleStyle ?? CookieConsentStyle.defaultTitleStyle,
          ),
          SizedBox(height: widget.style.spacingBetweenElements),
          Text(
            widget.message,
            style: widget.style.messageStyle ??
                CookieConsentStyle.defaultMessageStyle,
          ),
          SizedBox(height: widget.style.spacingBetweenElements * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.showSettings)
                TextButton(
                  onPressed: widget.onSettings,
                  style: widget.style.settingsButtonStyle ??
                      CookieConsentStyle.defaultSettingsButtonStyle,
                  child: Text(widget.settingsButtonText),
                ),
              SizedBox(width: widget.style.spacingBetweenElements),
              TextButton(
                onPressed: () => widget.onDecline(false),
                style: widget.style.declineButtonStyle ??
                    CookieConsentStyle.defaultDeclineButtonStyle,
                child: Text(widget.declineButtonText),
              ),
              SizedBox(width: widget.style.spacingBetweenElements),
              ElevatedButton(
                onPressed: () => widget.onAccept(true),
                style: widget.style.acceptButtonStyle ??
                    CookieConsentStyle.defaultAcceptButtonStyle,
                child: Text(widget.acceptButtonText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
