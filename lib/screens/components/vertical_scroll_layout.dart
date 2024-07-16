import 'package:flutter/material.dart';

class VerticalScrollLayout extends StatelessWidget {
  final Widget widget;
  const VerticalScrollLayout({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: widget,
        ),
      ),
    );
  }
}
