import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMyFToast(String textMsg) => Fluttertoast.showToast(
  msg: textMsg,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.TOP,
  backgroundColor: Colors.indigo,
  textColor: Colors.white,
  fontSize: 16,
);
