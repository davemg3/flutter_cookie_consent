import 'package:flutter/material.dart';

class CookieSettingsTexts {
  final String dialogTitle;
  final String essentialTitle;
  final String essentialDescription;
  final String analyticsTitle;
  final String analyticsDescription;
  final String marketingTitle;
  final String marketingDescription;
  final String cancelButton;
  final String saveButton;

  const CookieSettingsTexts({
    this.dialogTitle = 'Cookie Settings',
    this.essentialTitle = 'Essential Cookies',
    this.essentialDescription =
        'These cookies are necessary for the website to function and cannot be switched off.',
    this.analyticsTitle = 'Analytics Cookies',
    this.analyticsDescription =
        'These cookies help us understand how visitors interact with our website.',
    this.marketingTitle = 'Marketing Cookies',
    this.marketingDescription =
        'These cookies are used to track visitors across websites.',
    this.cancelButton = 'Cancel',
    this.saveButton = 'Save',
  });
}

class CookieSettingsStyle {
  final Color dialogBackgroundColor;
  final EdgeInsets dialogPadding;
  final EdgeInsets contentPadding;
  final double dialogElevation;
  final double dialogBorderRadius;
  final TextStyle titleTextStyle;
  final TextStyle cookieTitleTextStyle;
  final TextStyle cookieDescriptionTextStyle;
  final Color switchActiveColor;
  final Color switchInactiveColor;
  final double switchTrackHeight;
  final double switchThumbRadius;
  final double spacingBetweenItems;

  const CookieSettingsStyle({
    this.dialogBackgroundColor = Colors.white,
    this.dialogPadding = const EdgeInsets.all(24.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.dialogElevation = 8.0,
    this.dialogBorderRadius = 12.0,
    this.titleTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    this.cookieTitleTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    this.cookieDescriptionTextStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
    this.switchActiveColor = Colors.blue,
    this.switchInactiveColor = Colors.grey,
    this.switchTrackHeight = 24.0,
    this.switchThumbRadius = 10.0,
    this.spacingBetweenItems = 16.0,
  });
}

class CookieSettingsDialog extends StatefulWidget {
  final Map<String, bool> cookiePreferences;
  final Function(Map<String, bool>) onSave;
  final CookieSettingsTexts texts;
  final CookieSettingsStyle style;

  const CookieSettingsDialog({
    super.key,
    required this.cookiePreferences,
    required this.onSave,
    this.texts = const CookieSettingsTexts(),
    this.style = const CookieSettingsStyle(),
  });

  @override
  State<CookieSettingsDialog> createState() => _CookieSettingsDialogState();
}

class _CookieSettingsDialogState extends State<CookieSettingsDialog> {
  late Map<String, bool> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = Map.from(widget.cookiePreferences);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.style.dialogBackgroundColor,
      contentPadding: widget.style.dialogPadding,
      elevation: widget.style.dialogElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.style.dialogBorderRadius),
      ),
      title: Text(
        widget.texts.dialogTitle,
        style: widget.style.titleTextStyle,
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: widget.style.contentPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCookieType(
                widget.texts.essentialTitle,
                widget.texts.essentialDescription,
                'essential',
                true,
                true,
              ),
              SizedBox(height: widget.style.spacingBetweenItems),
              _buildCookieType(
                widget.texts.analyticsTitle,
                widget.texts.analyticsDescription,
                'analytics',
                _preferences['analytics'] ?? false,
                false,
              ),
              SizedBox(height: widget.style.spacingBetweenItems),
              _buildCookieType(
                widget.texts.marketingTitle,
                widget.texts.marketingDescription,
                'marketing',
                _preferences['marketing'] ?? false,
                false,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.texts.cancelButton),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_preferences);
            Navigator.pop(context);
          },
          child: Text(widget.texts.saveButton),
        ),
      ],
    );
  }

  Widget _buildCookieType(
    String title,
    String description,
    String key,
    bool value,
    bool disabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: widget.style.cookieTitleTextStyle,
              ),
            ),
            if (!disabled)
              Switch(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    _preferences[key] = newValue;
                  });
                },
                activeTrackColor: widget.style.switchActiveColor.withAlpha(77),
                inactiveTrackColor:
                    widget.style.switchInactiveColor.withAlpha(77),
                trackOutlineColor:
                    WidgetStateProperty.all(widget.style.switchInactiveColor),
                thumbColor:
                    WidgetStateProperty.all(widget.style.switchActiveColor),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: widget.style.cookieDescriptionTextStyle,
        ),
      ],
    );
  }
}
