import 'package:entitlements/connected.dart';
import 'package:entitlements/firebase_options.dart';
import 'package:entitlements/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(
    serverClientId: DefaultFirebaseOptions.currentPlatform.androidClientId,
  );
  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString('language') ?? 'ar';
  runApp(DebtManager(language: savedLanguage));
}

class DebtManager extends StatefulWidget {
  const DebtManager({super.key, required this.language});
  final String language;
  static void setLocale(BuildContext context, Locale locale) {
    (context as Element)
        .findAncestorStateOfType<_DebtManagerState>()!
        .setLocale(locale);
  }

  static void setTheme(BuildContext context, ThemeMode mode) {
    (context as Element)
        .findAncestorStateOfType<_DebtManagerState>()!
        .setThemeMode(mode);
  }

  @override
  State<DebtManager> createState() => _DebtManagerState();
}

class _DebtManagerState extends State<DebtManager> {
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF19E26A),
      secondary: Color(0xFF19E26A),
      surface: Color(0xFF0F2C22),
      error: Color(0xFFFF5E5E),
      onPrimary: Color(0xFF061A13),
      onSurface: Color(0xFFE9FFF3),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF061A13),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF061A13),
      titleTextStyle: TextStyle(
        color: Color(0xFFE9FFF3),
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
    cardColor: const Color(0xFF0F2C22),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF0E3A2B),
      contentTextStyle: const TextStyle(
        color: Color(0xFFE9FFF3),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE8F5E9),
      secondary: Color(0xFF1B8C4E),
      surface: Color(0xFFE8F5E9),
      error: Color(0xFFD32F2F),
      onPrimary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF1F8F4),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B8C4E),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
    cardColor: const Color(0xFFE8F5E9),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF1B8C4E),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
  late Locale locale;
  ThemeMode _themeMode = ThemeMode.dark;

  void setThemeMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  @override
  void initState() {
    locale = Locale(widget.language);
    _loadTheme();
    super.initState();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode') ?? 'dark';
    setState(() {
      _themeMode = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void setLocale(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      locale: locale,
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: ConnectivityWrapper(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const Homepage();
            }
            return const SignInScreen();
          },
        ),
      ),
    );
  }
}
