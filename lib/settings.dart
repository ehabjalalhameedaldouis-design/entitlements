import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/main.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLanguage(String code, BuildContext context) async {
    if (code == Localizations.localeOf(context).languageCode) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
    if (!context.mounted) return;
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
    final primary = Theme.of(context).colorScheme.primary;
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
                      _changeLanguage('ar', context);
                    },
                    icon: Icon(
                      currentLang == 'ar'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: primary,
                    ),
                    label: Text(getword(context, 'arabic_language')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _changeLanguage('en', context);
                    },
                    icon: Icon(
                      currentLang == 'en'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: primary,
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
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: Myappbar(
        widget: Text(
          getword(context, "settings"),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _showLanguagePickerSnack,
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.language, color: primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        getword(context, 'choose_language'),
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: onSurface),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                DebtManager.setTheme(
                  context,
                  isDark ? ThemeMode.light : ThemeMode.dark,
                );
              },
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        Theme.of(context).brightness == Brightness.dark
                            ? getword(context, 'dark_mode')
                            : getword(context, 'light_mode'),
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: onSurface),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () async {
      final Uri url = Uri.parse('https://wa.me/967717471102');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    },
    child: Ink(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.chat_rounded, color: primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              getword(context, 'contact_developer'),
              style: TextStyle(
                color: onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: onSurface),
        ],
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}