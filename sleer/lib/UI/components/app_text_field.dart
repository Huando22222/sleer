import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final Widget? label;
  const AppTextField({super.key, this.hintText, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        label: label,
      ),
    );
  }
}
