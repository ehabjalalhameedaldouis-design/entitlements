import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final String hintText;
  final IconData icon;
  const MyTextField({super.key, required this.hintText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color.fromARGB(255, 222, 169, 10),
      style: TextStyle(color: Color.fromARGB(255, 222, 169, 10)),
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(255, 54, 44, 44),
        filled: true,
        suffixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 222, 169, 10),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 222, 169, 10)),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Color.fromARGB(255, 222, 169, 10)),
        focusColor: Color.fromARGB(255, 222, 169, 10),
      ),
    );
  }
}
