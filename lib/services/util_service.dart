import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UtilService {
  static void showToast({
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

  static Future<XFile?> pickImage({
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      debugPrint("success${pickedFile.path}");
      return pickedFile;
    } else {
      debugPrint("false");
      debugPrint('No image selected.');
      return null;
    }
  }
}
