import 'package:flutter/material.dart';

class VerticalScrollLayout extends StatelessWidget {
  final Widget widget;
  final Future<void> Function()? onRefresh;
  const VerticalScrollLayout({
    super.key,
    required this.widget,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: widget,
          ),
        ),
      ),
    );
  }
}
