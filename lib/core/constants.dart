import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const int numOfDoc = 10;

const primaryColor = MaterialColor(
  0xFF2FA887,
  <int, Color>{
    50: Color(0xFFE0F3E4),
    100: Color(0xFFB3E0C7),
    200: Color(0xFF80CCAA),
    300: Color(0xFF4DB892),
    400: Color(0xFF26AA7A),
    500: Color(0xFF2FA887),
    600: Color(0xFF268170),
    700: Color(0xFF1F6A5A),
    800: Color(0xFF185442),
    900: Color(0xFF0F3D2B),
  },
);

void toast(String message, ToastType toastType, {bool isLong = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: isLong ? Toast.LENGTH_SHORT : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: toastType == ToastType.error
        ? Colors.red
        : toastType == ToastType.success
            ? Colors.green
            : null,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastType { success, error, normal }

const whiteColor = Colors.white;

class FirebaseConst {
  static String courses = "Courses";
  static String ustaz = "Ustaz";
  static String category = "Category";
}

class DatabaseConst {
  static String savedCourses = "SavedCourses";
}
