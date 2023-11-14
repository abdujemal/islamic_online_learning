import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const int numOfDoc = 20;

const Color cardColor = Color(0xfffcffea);

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
    toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
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
  static String faq = "FAQ";
}

class DatabaseConst {
  static String savedCourses = "SavedCourses";
}

TargetFocus getTutorial({
  required GlobalKey key,
  required String identify,
  required ContentAlign align,
  required String title,
  required String subtitle,
}) {
  return TargetFocus(
    identify: identify,
    keyTarget: key,
    contents: [
      TargetContent(
        align: align,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                subtitle,
              ),
            )
          ],
        ),
      ),
    ],
  );
}

Future<File?> displayImage(String? id, String name, WidgetRef ref) async {
  final directory = await getApplicationSupportDirectory();
  final filePath = "${directory.path}/Images/$name.jpg";
  // print(filePath);
  if (await File(filePath).exists()) {
    // print("file exsists: ${filePath}");
    return File(filePath);
  } else if (id != null) {
    try {
      String url = await ref.read(cdDataSrcProvider).loadFileOnline(id, false);

      await Dio().download(url, filePath);

      // Return the downloaded file
      return File(filePath);
    } catch (e) {
      print(e.toString());
      return File("");
    }
  } else {
    return null;
  }
}

String formatFileSize(int sizeInBytes) {
  if (sizeInBytes < 1024) {
    return '$sizeInBytes B';
  } else if (sizeInBytes < 1024 * 1024) {
    double sizeInKB = sizeInBytes / 1024;
    return '${sizeInKB.toStringAsFixed(2)} KB';
  } else if (sizeInBytes < 1024 * 1024 * 1024) {
    double sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(2)} MB';
  } else if (sizeInBytes < 1024 * 1024 * 1024 * 1024) {
    double sizeInGB = sizeInBytes / (1024 * 1024 * 1024);
    return '${sizeInGB.toStringAsFixed(2)} GB';
  } else {
    double sizeInTB = sizeInBytes / (1024 * 1024 * 1024 * 1024);
    return '${sizeInTB.toStringAsFixed(2)} TB';
  }
}

bool isPlayingCourseThisCourse(String courseId, WidgetRef ref,
    {bool alsoIsNotIdle = false}) {
  final audioPlayer = ref.read(audioProvider);
  final metaData = audioPlayer.sequenceState?.currentSource?.tag;
  if (metaData == null) {
    return false;
  }
  MediaItem mediaItem = metaData as MediaItem;
  if (mediaItem.extras?["courseId"] == courseId) {
    if (alsoIsNotIdle) {
      if (audioPlayer.processingState != ProcessingState.idle) {
        return true;
      }
    } else {
      
      return true;
    }
  }
  return false;
}
