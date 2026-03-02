import 'package:entitlements/signin.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize(
    serverClientId: '849413315878-9439fpb3k2goffpflb5us7qonaeoqg9t.apps.googleusercontent.com',
  );
  runApp(DebtManager(language: 'en'));
}

class DebtManager extends StatefulWidget {
  const DebtManager({super.key, required this.language});
  final String language;
  static void setLocale(BuildContext context, Locale locale) {
    (context as Element)
        .findAncestorStateOfType<_DebtManagerState>()!
        .setLocale(locale);
  }

  @override
  State<DebtManager> createState() => _DebtManagerState();
}

class _DebtManagerState extends State<DebtManager> {
  late Locale locale;

  @override
  void initState() {
    super.initState();
    locale = Locale(widget.language);
  }

  void setLocale(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: MyColors.background),
        scaffoldBackgroundColor: MyColors.background,
        primaryColor: MyColors.darkYellow,
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: MyColors.darkYellow,
          cursorColor: MyColors.darkYellow,
          selectionColor: MyColors.darkYellow.withValues(alpha: 0.5),
        ),
      ),
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: StreamBuilder<User?>(
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
    );
  }
}
