// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const AppButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(),
        maximumSize: Size(300, 80),
        minimumSize: Size(200, 40),
      ),
      child: Text(title),
    );
  }
}
