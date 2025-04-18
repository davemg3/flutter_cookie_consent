import 'package:flutter/material.dart';
import 'package:flutter_cookie_consent/flutter_cookie_consent.dart';
import 'package:flutter_cookie_consent/ui/cookie_settings_dialog.dart';
import 'package:flutter_cookie_consent/ui/flutter_cookie_consent_banner.dart';

class CookieExamplePage extends StatefulWidget {
  const CookieExamplePage({super.key});

  @override
  State<CookieExamplePage> createState() => _CookieExamplePageState();
}

class _CookieExamplePageState extends State<CookieExamplePage> {
  final FlutterCookieConsent _cookieConsent = FlutterCookieConsent();
  late final Future<void> _initFuture;

  // 스타일 조절을 위한 상태 변수들
  bool _useCustomStyle = false;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  Color _buttonColor = Colors.blue;
  Color _buttonTextColor = Colors.white;
  double _padding = 16.0;

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
          body: Column(
            children: [
              // 스타일 조절 섹션
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '스타일 설정',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('커스텀 스타일 사용'),
                        value: _useCustomStyle,
                        onChanged: (value) {
                          setState(() {
                            _useCustomStyle = value;
                          });
                        },
                      ),
                      if (_useCustomStyle) ...[
                        const SizedBox(height: 8),
                        _buildColorPicker(
                          '배경색',
                          _backgroundColor,
                          (color) => setState(() => _backgroundColor = color),
                        ),
                        _buildColorPicker(
                          '텍스트 색상',
                          _textColor,
                          (color) => setState(() => _textColor = color),
                        ),
                        _buildColorPicker(
                          '버튼 색상',
                          _buttonColor,
                          (color) => setState(() => _buttonColor = color),
                        ),
                        _buildColorPicker(
                          '버튼 텍스트 색상',
                          _buttonTextColor,
                          (color) => setState(() => _buttonTextColor = color),
                        ),
                        const SizedBox(height: 8),
                        _buildSlider(
                          '여백',
                          _padding,
                          8.0,
                          32.0,
                          (value) => setState(() => _padding = value),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // 메인 콘텐츠
              Expanded(
                child: Stack(
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
                      style: _useCustomStyle
                          ? CookieConsentStyle(
                              backgroundColor: _backgroundColor,
                              titleStyle: TextStyle(
                                color: _textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              messageStyle: TextStyle(
                                color: _textColor,
                                fontSize: 14,
                              ),
                              acceptButtonStyle: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(_buttonColor),
                                foregroundColor:
                                    WidgetStateProperty.all(_buttonTextColor),
                              ),
                              declineButtonStyle: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(_buttonColor),
                                foregroundColor:
                                    WidgetStateProperty.all(_buttonTextColor),
                              ),
                              settingsButtonStyle: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(_buttonColor),
                                foregroundColor:
                                    WidgetStateProperty.all(_buttonTextColor),
                              ),
                              contentPadding: EdgeInsets.all(_padding),
                              spacingBetweenElements: _padding / 2,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorPicker(
      String label, Color color, ValueChanged<Color> onChanged) {
    return ListTile(
      title: Text(label),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onTap: () async {
        final newColor = await showDialog<Color>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('$label 선택'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: color,
                onColorChanged: onChanged,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
        if (newColor != null) {
          onChanged(newColor);
        }
      },
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 20,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// 간단한 색상 선택 위젯
class ColorPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.pink,
        Colors.brown,
        Colors.grey,
        Colors.black,
        Colors.white,
      ].map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: color == pickerColor ? Colors.black : Colors.grey,
                width: color == pickerColor ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
