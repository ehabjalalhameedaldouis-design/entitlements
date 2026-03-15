import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final IconData? iconsuf;
  final IconData? iconpre;
  final Function(String)? onChanged;
  final bool isPassword;
  const MyTextField({
    required this.hintText,
    this.iconsuf,
    this.iconpre,
    this.onChanged,
    this.isPassword = false,
    this.controller,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          cursorColor: primary,
          style: TextStyle(color: primary),
          decoration: InputDecoration(
            fillColor: surface,
            filled: true,
            suffixIcon: iconsuf != null ? Icon(iconsuf, color: primary) : null,
            prefixIcon: iconpre != null ? Icon(iconpre, color: primary) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: primary.withValues(alpha: 0.6)),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}