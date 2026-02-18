import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final IconData? icon;
  const Mycard({super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
              color: MyColors.lightBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Icon(icon, color: MyColors.darkYellow),
                title: Text(
                  getword(context, label),
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: onTap,
              ),
            );
  }
}