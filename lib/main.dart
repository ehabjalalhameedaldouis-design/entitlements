import 'package:entitlements/signup.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/datastructure.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Person>('clientsBox');
  await Hive.openBox("settingsBox");
  var box = Hive.box("settingsBox");
  var language = box.get('language', defaultValue: 'en');
  runApp(DebtManager(language: language));
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
  bool signupCondition = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        signupCondition = true;
      } else {
        signupCondition = false;
      }
      setState(() {});
    });
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
      home: signupCondition ? SignUpScreen() : Homepage(),
    );
  }
}
