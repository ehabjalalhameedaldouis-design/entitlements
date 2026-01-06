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
        primaryColor: Color.fromARGB(255, 222, 169, 10),
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Color.fromARGB(255, 222, 169, 10),
          cursorColor: Color.fromARGB(255, 222, 169, 10),
          selectionColor: Color.fromARGB(255, 222, 169, 10).withValues(alpha: 0.5),
        ),
      ),
      home: Homepage(),
    );
  }
}
