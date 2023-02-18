import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/icon_broken.dart';

void showFlutterToast(
    {required String msg,
    Color backgrounfclr = Colors.red,
    Color txtColor = Colors.white}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgrounfclr,
      textColor: txtColor,
      fontSize: 16.0);
}

