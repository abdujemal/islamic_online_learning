import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const String databaseUrl =
    "https://b2.ilmfelagi.com/file/ilm-Felagi2/Database/DB.db";

const String dbPath = "/Islamic Online Learning/db/myDB.db";

const int numOfDoc = 20;

const String playStoreUrl =
    "https://play.google.com/store/apps/details?id=com.aj.islamic_online_learning";

const Color cardColor = Color(0xfffcffea);

const Color darkCardColor = Color(0xff3f3f3d);

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

void toast(String message, ToastType toastType, BuildContext context,
    {bool isLong = false}) {
  // final snackbar = SnackBar(
  //   content: Text(
  //     message,
  //     style: const TextStyle(color: whiteColor),
  //   ),
  //   duration: Duration(seconds: isLong ? 5 : 1),
  //   backgroundColor: toastType == ToastType.error
  //       ? Colors.red
  //       : toastType == ToastType.success
  //           ? primaryColor
  //           : Colors.black,
  // );

  // // Show the snackbar
  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
  static String savedCourses = "Courses";
  static String cateogry = "Category";
  static String ustaz = "Ustaz";
  static String faq = "FAQ";
  static String content = "Content";
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
    shape: ShapeLightFocus.RRect,
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
                color: whiteColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: whiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

double getPersentage(CourseModel courseModel) {
  // double percentage =
  //     (courseModel.pausedAtAudioNum + 1) / courseModel.noOfRecord;
  int numOfAudio = courseModel.courseIds.split(",").length;
  double avgAudio = courseModel.totalDuration / numOfAudio;
  int pausedAtAudioNum = courseModel.pausedAtAudioNum + 1;
  int pausedAtSec = courseModel.pausedAtAudioSec;

  double percnt = ((avgAudio * (pausedAtAudioNum - 1)) + pausedAtSec) /
      courseModel.totalDuration;

  return percnt > 1 ? 1 : percnt;
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
  print('isPlayingCourseThisCourse');
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
