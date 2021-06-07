import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastMessage(
    {@required String text, MaterialAccentColor bgColor = Colors.greenAccent}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0);
}