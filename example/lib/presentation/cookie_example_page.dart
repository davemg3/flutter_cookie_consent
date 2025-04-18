import 'package:flutter/material.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent.dart';
import 'package:flutter_cookie_consent/ui/cookie_settings_dialog.dart';

class CookieExamplePage extends StatefulWidget {
  const CookieExamplePage({super.key});

  @override
  State<CookieExamplePage> createState() => _CookieExamplePageState();
}

class _CookieExamplePageState extends State<CookieExamplePage> {
  final FlutterCookieConsent _cookieConsent = FlutterCookieConsent();
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _cookieConsent.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cookie Consent Example'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CookieSettingsDialog(
                      cookiePreferences: _cookieConsent.preferences,
                      onSave: (preferences) async {
                        await _cookieConsent.savePreferences(preferences);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              const Center(
                child: Text(
                  'Welcome to our app!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _cookieConsent.createBanner(
                context: context,
                title: 'Cookie Settings',
                message:
                    'We use cookies to enhance your browsing experience, serve personalized ads or content, and analyze our traffic. By clicking "Accept", you consent to our use of cookies.',
                acceptButtonText: 'Accept',
                declineButtonText: 'Decline',
                settingsButtonText: 'Settings',
                showSettings: true,
                position: BannerPosition.top,
              ),
            ],
          ),
        );
      },
    );
  }
}
