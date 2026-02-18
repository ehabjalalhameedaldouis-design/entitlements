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
        style: TextStyle(
          color: MyColors.title,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      backgroundColor: MyColors.background,
      elevation: 8,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    );
  }
}
