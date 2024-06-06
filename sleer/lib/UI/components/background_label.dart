import 'package:flutter/material.dart';

class BackgroundLabel extends StatelessWidget {
  final Widget child;
  final double? opacity;
  final double? radius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const BackgroundLabel({
    super.key,
    required this.child,
    this.opacity,
    this.radius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(opacity ?? 0.1),
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 16),
        ),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
