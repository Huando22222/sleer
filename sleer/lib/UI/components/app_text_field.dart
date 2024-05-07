import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  const AppTextField({super.key, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
      ),
    );
  }
}
