import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:lottie/lottie.dart'; // add lottie: ^2.6.0 (or latest) in pubspec.yaml
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/pdf_page.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/LessonController/lesson_state.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class LessonNotifier extends StateNotifier<LessonState> {
  LessonNotifier() : super(LessonState());

  void startLesson(Lesson lesson, AssignedCourse course, WidgetRef ref) {
    final audioData = AudioSource.uri(
      Uri.parse(lesson.audioUrl),
      tag: MediaItem(
        id: lesson.id,
        title: lesson.title,
        artist: course.course!.ustaz,
        album: course.course!.category,
        artUri: Uri.parse(course.course!.image),
        extras: course.course!.toMap(),
      ),
    );

    final player = PlaylistHelper.audioPlayer;
    player.setAudioSource(audioData);
    player.play();
    state = state.copyWith(currentLesson: lesson, currentCourse: course);
    downloadPdf(ref, course, lesson);
  }

  Future<String?> getPdfPath(
      WidgetRef ref, CourseModel course, int volume) async {
    final cdNotifier = ref.read(cdNotifierProvider.notifier);
    String? pdfUrl;

    for (int i = 1; i <= (course.pdfId.split(",").length); i++) {
      final cancelToken = CancelToken();
      state = state.copyWith(cancelToken: cancelToken);
      final file = await cdNotifier.downloadFile(
        course.pdfId,
        course.pdfId.contains(",")
            ? "${course.title} $i.pdf"
            : "${course.title}.pdf",
        "PDF",
        cancelToken,
        ref.context,
      );
      if (file != null && i - 1 == volume) {
        pdfUrl = file.path;
      }
    }
    return pdfUrl;
  }

  Future<void> downloadPdf(
      WidgetRef ref, AssignedCourse course, Lesson lesson) async {
    state = state.copyWith(isDownloading: true);
    final pdfId = state.currentCourse?.course?.pdfId;
    if (pdfId == null) return;
    final courseModel =
        await DatabaseHelper().getSingleCourse(course.course!.courseId);
    if (courseModel == null) return;
    String? pdfUrl = await getPdfPath(ref, courseModel, lesson.volume);
    state = state.copyWith(
      isDownloading: false,
      pdfPath: pdfUrl,
      cancelToken: null,
    );

    // print("mmmmmmm courseModel: $courseModel");
    // print("mmmmmmm pdfUrl: $pdfUrl");

    if (ref.context.mounted && pdfUrl != null) {
      Navigator.push(
        ref.context,
        MaterialPageRoute(
          builder: (_) => PdfPage(
            path: pdfUrl,
            volume: lesson.volume.toDouble(),
            courseModel: courseModel,
            isFromPro: true,
          ),
        ),
      );
    }
  }

  Future<T?> showConfusionDialog<T>(BuildContext context) async {
    if (context.mounted == false) return null;
    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/success.json', // 🎉 put a small success/check animation

                      height: 200,
                      repeat: false,
                    ),
                    // const SizedBox(height: 4),
                    const Text(
                      'የዛሬን ደርስ አጠናቀዋል 🎧',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"${state.currentLesson?.title}"ን ተምረው ጨርሰዋል! ማሻአላህ!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        // color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'በዚህ ደርስ ላይ ያልገባዎት ውይም ግር ያልዎት ነገር አለ?',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop('no');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "አይ፣ ምንም የለም 👍",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop('yes');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "አዎ፣ ጥያቄ አለኝ 💭",
                              style: TextStyle(
                                fontSize: 15,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
