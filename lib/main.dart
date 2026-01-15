import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'datastructure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Person>('clientsBox');
  runApp(const DebtManager());
}

class DebtManager extends StatefulWidget {
  const DebtManager({super.key});

  @override
  State<DebtManager> createState() => _DebtManagerState();
}

class _DebtManagerState extends State<DebtManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: MyColors.background,
        ),
        scaffoldBackgroundColor: MyColors.background,
        primaryColor: MyColors.darkYellow,
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: MyColors.darkYellow,
          cursorColor: MyColors.darkYellow,
          selectionColor: MyColors.darkYellow.withValues(alpha: 0.5),
        ),
      ),
      home: Homepage(),
    );
  }
}
