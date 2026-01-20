import 'package:flutter/material.dart';
import 'package:entitlements/mycolors.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Function(String)? onChanged;
  const MyTextField({super.key, required this.hintText, required this.icon, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: MyColors.darkYellow,
      style: TextStyle(color: MyColors.darkYellow),
      decoration: InputDecoration(
        fillColor: MyColors.lightBlack,
        filled: true,
        suffixIcon: Icon(icon, color: MyColors.darkYellow),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.darkYellow),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: MyColors.darkYellow),
        focusColor: MyColors.darkYellow,
      ),
      onChanged: onChanged,
    );
  }
}
