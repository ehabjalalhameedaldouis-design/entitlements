import 'package:entitlements/data/appwords.dart';
import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final IconData? icon;
  const Mycard({super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return Card(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(
          getword(context, label),
          style: TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}