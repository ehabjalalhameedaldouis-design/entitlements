import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';

class Myappbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const Myappbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        getword(context, title),
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 8,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    );
  }
}
