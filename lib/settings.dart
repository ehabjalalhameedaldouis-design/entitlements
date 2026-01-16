import 'package:entitlements/appwords.dart';
import 'package:entitlements/main.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getword(context, 'settings'))),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text(getword(context, 'arabic_language')),
            value: 'ar',
            groupValue: Localizations.localeOf(context).languageCode,
            onChanged: (value) {
              DebtManager.setLocale(context, Locale('ar', 'SA'));
            },
          ),
          RadioListTile<String>(
            title: Text(getword(context, 'chinese_language')),
            value: 'zh',
            groupValue: Localizations.localeOf(context).languageCode,
            onChanged: (value) {
              DebtManager.setLocale(context, Locale('zh', 'CN'));
            },
          ),
          RadioListTile<String>(
            title: Text(getword(context, 'english_language')),
            value: 'en',
            groupValue: Localizations.localeOf(context).languageCode,
            onChanged: (value) {
              DebtManager.setLocale(context, Locale('en', 'US'));
            },
          ),
        ],
      ),
    );
  }
}
