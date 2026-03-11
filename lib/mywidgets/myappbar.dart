import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';

class Myappbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget widget;
  const Myappbar({super.key, required this.widget});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget,
      centerTitle: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 8,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    );
  }
}
