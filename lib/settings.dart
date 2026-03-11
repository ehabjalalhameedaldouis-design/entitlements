import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/main.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void _showLanguageSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(14),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: MyColors.darkYellow),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(String code) {
    if (code == Localizations.localeOf(context).languageCode) return;
    if (code == 'ar') {
      DebtManager.setLocale(context, const Locale('ar', 'SA'));
      _showLanguageSnack(getword(context, 'language_changed_to_arabic'));
    } else {
      DebtManager.setLocale(context, const Locale('en', 'US'));
      _showLanguageSnack(getword(context, 'language_changed_to_english'));
    }
  }

  void _showLanguagePickerSnack() {
    final currentLang = Localizations.localeOf(context).languageCode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 8),
        margin: const EdgeInsets.all(14),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getword(context, 'choose_language'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _changeLanguage('ar');
                    },
                    icon: Icon(
                      currentLang == 'ar'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: MyColors.darkYellow,
                    ),
                    label: Text(getword(context, 'arabic_language')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _changeLanguage('en');
                    },
                    icon: Icon(
                      currentLang == 'en'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: MyColors.darkYellow,
                    ),
                    label: Text(getword(context, 'english_language')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(widget: Text(
          getword(context,"settings"),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _showLanguagePickerSnack,
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: MyColors.lightBlack,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, color: MyColors.darkYellow),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        getword(context, 'choose_language'),
                        style: const TextStyle(
                          color: MyColors.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF245F48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, color: Color(0xFFE9FFF3)),
              label: Text(
                getword(context, 'sign_out'),
                style: const TextStyle(
                  color: Color(0xFFE9FFF3),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
