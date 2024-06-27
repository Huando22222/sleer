import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String msg,
  ToastGravity gravity = ToastGravity.TOP,
  Color backgroundColor = Colors.green,
  Color textColor = Colors.white,
  int timeInSecForIosWeb = 1,
  double fontSize = 16.0,
  Toast toastLength = Toast.LENGTH_SHORT,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}
