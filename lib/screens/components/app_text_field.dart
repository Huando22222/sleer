// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? label;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const AppTextField({
    super.key,
    this.hintText,
    this.label,
    this.onChanged,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      onChanged: onChanged,
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
