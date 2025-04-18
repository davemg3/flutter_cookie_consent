import 'package:flutter/material.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent.dart';
import 'package:flutter_cookie_consent/ui/cookie_settings_dialog.dart';

Future<void> showCookieModal(
    BuildContext context, FlutterCookieConsent cookieConsent) async {
  if (!context.mounted) return;

  await showDialog(
    context: context,
    builder: (context) => CookieSettingsDialog(
      cookiePreferences: cookieConsent.preferences,
      onSave: (preferences) {
        cookieConsent.savePreferences(preferences);
        Navigator.of(context).pop();
      },
    ),
  );
}
