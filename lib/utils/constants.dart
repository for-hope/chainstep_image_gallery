import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


final cacheKey = 'image_cache';
final accentColor = Color(0xff0a1e50);
final primaryColor = Color(0xff0A062C);
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