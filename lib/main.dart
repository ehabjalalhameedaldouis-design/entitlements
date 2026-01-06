import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
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
        // scaffoldBackgroundColor: MyColors.darkYellow,
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
