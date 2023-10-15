import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

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
    backgroundColor: toastType == ToastType.error ? Colors.red : Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastType { success, error }

const whiteColor = Colors.white;

class FirebaseConst {
  static String courses = "Courses";
  static String ustaz = "Ustaz";
  static String category = "Category";
}

class DatabaseConst {
  static String savedCourses = "SavedCourses";
}

Future<String?> downloadAudio(String fileId, String name) async {
  try {
    Directory? dir = await getExternalStorageDirectory();

    const String botToken = "6152316528:AAH3NEDElz5ApQz_8Qb1Xw9YJXaeTOOCoZ4";
    String filePath = "${dir!.path}/$name";
    final dio = Dio();
    final fileUrl =
        'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    final response = await dio.get(fileUrl);
    final fileData = response.data['result'];
    final fileDownloadUrl =
        'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
    await dio.download(fileDownloadUrl, filePath);

    return filePath;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<String?> getUrlOfAudio(String fileId) async {
  try {
    const String botToken = "6152316528:AAH3NEDElz5ApQz_8Qb1Xw9YJXaeTOOCoZ4";
    final dio = Dio();
    final fileUrl =
        'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    final response = await dio.get(fileUrl);
    final fileData = response.data['result'];
    final fileDownloadUrl =
        'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';

    return fileDownloadUrl;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
