import 'package:flutter/material.dart';
import 'package:entitlements/mywidgets/mycolors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final IconData? iconsuf;
  final IconData? iconpre;  
  final Function(String)? onChanged;
  final bool isPassword;
  const MyTextField({
    super.key,
    required this.hintText,
    this.iconsuf,
    this.iconpre,
    this.onChanged,
    this.isPassword = false,
    this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: MyColors.darkYellow,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          cursorColor: MyColors.darkYellow,
          style: TextStyle(color: MyColors.darkYellow),
          decoration: InputDecoration(
            fillColor: MyColors.lightBlack,
            filled: true,
            suffixIcon: Icon(iconsuf, color: MyColors.darkYellow),
            prefixIcon: Icon(iconpre, color: MyColors.darkYellow),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.darkYellow),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: hintText,
            hintStyle: TextStyle(color: MyColors.darkYellow),
            focusColor: MyColors.darkYellow,  
          ),
          onChanged: onChanged,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
