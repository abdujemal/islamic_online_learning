import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const String databaseUrl =
    "https://b2.ilmfelagi.com/file/ilm-Felagi2/Database/DB.db";

const String dbPath = "/Islamic Online Learning/db/myDB.db";
const String serverUrl = "https://ilmfelagi.com/api";

//main apis
const String mainUrl = "https://ilmfelagi-pro-backend.onrender.com";
const String baseUrl = "$mainUrl/api/v1";
//livekit token generater
const String LIVEKIT_URL = "wss://islamic-lms-w13mlg50.livekit.cloud";
// const String LIVEKIT_URL = "wss://livekit.ilmfelagi.com";
const String TOKEN_ENDPOINT = "$baseUrl/discussions/livekit/token";
//sub apis
//curriculums
const String curriculumsApi = "$baseUrl/curriculums/all";
const String getCurriculumApi = "$baseUrl/curriculums";
const String lessonsApi = "$baseUrl/curriculums/:courseId/lessons";
const String getQuizzesApi = "$baseUrl/curriculums/{lessonId}/quizzes";
//prerequisite test
const String getPrerequisiteTestApi =
    "$baseUrl/custom-tests/prerequisite/{level}";
//confusions
const String confusionsApi = "$baseUrl/confusions";
//discussions
const String discussionsApi = "$baseUrl/discussions";
const String discussionQuizzesApi = "$discussionsApi/quizzes";
const String discussionQuestionsApi = "$discussionsApi/questions";
const String submitDiscussionTasksApi = "$discussionsApi/submit";
//tests
const String getTestQuestionApi = "$baseUrl/tests";
const String getGivenTimeApi = "$baseUrl/tests/givenTime";
const String getCheckTestApi = "$baseUrl/tests/checkTest";
const String addTestAttemptApi = "$baseUrl/tests/start";
const String submitTestApi = "$baseUrl/tests/submit";
//quizAttempts
const String quizAttemptsApi = "$baseUrl/quizAttempts";
const String submitQuizApi = "$baseUrl/quizAttempts/submit";
//streaks
const String addStreakApi = "$baseUrl/streaks";
const String getStreaksApi = "$baseUrl/streaks/{year}/{month}";
//auth
const String refreshTokenApi = "$baseUrl/auth/otp/refresh-token";
const String requestOtpApi = "$baseUrl/auth/otp";
const String googleAuthApi = "$baseUrl/auth/google";
const String verifyOtpApi = "$baseUrl/auth/otp/verify";
const String similarGroupsApi = "$baseUrl/auth/user/groups";
const String registerApi = "$baseUrl/auth/user";
const String getMyInfoApi = "$baseUrl/auth/user/me";
const String updateMyInfoApi = "$baseUrl/auth/user/me";
const String getMyCourseInfoApi = "$baseUrl/auth/user/courseData";
const String getScoresApi = "$baseUrl/auth/user/scores";
const String getStreakNumApi = "$baseUrl/auth/user/streak";
//payments
const String paymentProvidersApi = "$baseUrl/payments/providers";
//chats
const String chatsApi = "$baseUrl/chats";
//notifications
const String notificationsApi = "$baseUrl/notifications";
const String readNotificationsApi = "$baseUrl/notifications/readAll";

///payments
const String paymentPricesApi = "$baseUrl/payments/prices";
const String paymentApi = "$baseUrl/payments";
const String paymentStatusApi = "$baseUrl/payments/status";

//questinnaire
const String getActiveQuestionnaireApi = "$baseUrl/questionnaires";
const String submitQuestionnaireApi = "$baseUrl/questionnaires/submit";
//feedback
const String submitFeedbackApi = "$baseUrl/feedback/submit";

const String hivePath = "/Islamic Online Learning/db/MyNoteBook";

const int numOfDoc = 20;

const String playStoreUrl =
    "https://play.google.com/store/apps/details?id=com.aj.islamic_online_learning_dev";

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
const Color cardColor = Color(0xfffcffea);

const Color darkCardColor = Color(0xff3f3f3d);

void toast(String message, ToastType toastType, BuildContext context,
    {bool isLong = false}) {
  if (context.mounted) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: whiteColor),
      ),
      dismissDirection: DismissDirection.down,
      duration: Duration(milliseconds: isLong ? 4000 : 1200),
      backgroundColor: toastType == ToastType.error
          ? Colors.red
          : toastType == ToastType.success
              ? primaryColor
              : Colors.black,
    );

    // // Show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: toastType == ToastType.error
    //       ? Colors.red
    //       : toastType == ToastType.success
    //           ? Colors.green
    //           : null,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
  }
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

double getPercentage(CourseModel courseModel) {
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

String formatFileSize(int sizeInBytes, {int toFixed = 2}) {
  if (sizeInBytes < 1024) {
    return '$sizeInBytes B';
  } else if (sizeInBytes < 1024 * 1024) {
    double sizeInKB = sizeInBytes / 1024;
    return '${sizeInKB.toStringAsFixed(toFixed)} KB';
  } else if (sizeInBytes < 1024 * 1024 * 1024) {
    double sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(toFixed)} MB';
  } else if (sizeInBytes < 1024 * 1024 * 1024 * 1024) {
    double sizeInGB = sizeInBytes / (1024 * 1024 * 1024);
    return '${sizeInGB.toStringAsFixed(toFixed)} GB';
  } else {
    double sizeInTB = sizeInBytes / (1024 * 1024 * 1024 * 1024);
    return '${sizeInTB.toStringAsFixed(toFixed)} TB';
  }
}

bool isPlayingCourseThisCourse(String courseId, WidgetRef refp,
    {bool alsoIsNotIdle = false}) {
  final audioPlayer = PlaylistHelper.audioPlayer;
  final metaData = audioPlayer.sequenceState.currentSource?.tag;
  if (metaData == null) {
    print('!isPlayingCourseThisCourse');
    return false;
  }
  MediaItem mediaItem = metaData as MediaItem;
  if (mediaItem.extras?["courseId"] == courseId) {
    if (alsoIsNotIdle) {
      if (audioPlayer.processingState != ProcessingState.idle) {
        print('isPlayingCourseThisCourse');
        return true;
      }
    } else {
      print('isPlayingCourseThisCourse');

      return true;
    }
  }
  print('!isPlayingCourseThisCourse');

  return false;
}

void printMap(Map<String, dynamic> map) {
  print("{");
  for (var kv in map.entries) {
    print("${kv.key}: ${kv.value}");
  }
  print("}");
}

String emailBlopper(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (emailRegex.hasMatch(email)) {
    final firstSegment = email.split(".").first.substring(0, 3);
    final middleSegment =
        List.generate(email.split(".").first.substring(3).length, (i) => "*")
            .join("");

    return "$firstSegment$middleSegment.${email.split(".").last}";
  } else {
    return email;
  }
}

String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
}

Future<bool> verifyFileLength({
  // required String url,
  required int expectedSize,
  required String filePath,
  bool aboveTheSize = false,
}) async {
  try {
    final file = File(filePath);

    if (!await file.exists()) return false;

    // Step 4: Validate file size
    final actualSize = await file.length();

    return aboveTheSize
        ? actualSize >= expectedSize
        : actualSize == expectedSize;
  } catch (e) {
    print("Error equating file length: $e");
    return false;
  }
}

Future<void> resumableDownload({
  required String url,
  required String savePath,
  required CancelToken cancelToken,
  required void Function(int received, int total) onProgress,
  required Future<void> Function() onDone,
  required Future<void> Function(Object error) onError, // <-- onError added
}) async {
  final dio = Dio();

  // Allow SSL bypass if needed
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  try {
    final file = File(savePath);

    // Get already downloaded size
    int downloadedBytes = 0;

    if (await file.exists()) {
      downloadedBytes = await file.length();
    } else {
      await file.create(recursive: true);
    }

    // Ask server for full size
    final head = await dio.head(url);
    final fullSize = int.tryParse(head.headers.value('content-length') ?? "0");

    if (fullSize == null || fullSize == 0) {
      throw Exception("Could not determine file size from server.");
    }

    // Already fully downloaded?
    if (downloadedBytes == fullSize) {
      await onDone();
      return;
    }

    // Open file for appending
    final raf = file.openSync(mode: FileMode.append);

    // Stream download from last byte
    final response = await dio.get<ResponseBody>(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Range': 'bytes=$downloadedBytes-',
        },
      ),
      cancelToken: cancelToken,
    );

    int received = downloadedBytes;

    // Stream chunks
    await for (var chunk in response.data!.stream) {
      if (cancelToken.isCancelled) {
        await raf.close();
        return;
      }

      raf.writeFromSync(chunk);
      received += chunk.length;

      onProgress(received, fullSize);
    }

    await raf.close();

    // Finished
    if (received >= fullSize) {
      await onDone();
    }
  } catch (e) {
    await onError(e); // <--- call your onError callback
    print("Download error: $e");
  }
}
