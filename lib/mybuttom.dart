import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';

class MyButtom extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final IconData icon;
  final double? width;
  final double allamount;
  const MyButtom({
    super.key,
    required this.text,
    this.onTap,
    this.icon = Icons.arrow_upward,
    this.width,
    required this.allamount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyColors.lightBlack,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        height: 70,
        width: width,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: MyColors.darkYellow),
            SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: MyColors.darkYellow,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(allamount.toString(), style: TextStyle(color: MyColors.darkYellow, fontSize: 15, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
