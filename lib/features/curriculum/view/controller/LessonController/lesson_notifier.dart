import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/pages/quiz_page.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LessonNotifier extends StateNotifier<LessonState> {
  final Ref ref;
  LessonNotifier(this.ref) : super(LessonState());

  Future<void> startLesson(Lesson lesson, AssignedCourse course, WidgetRef ref,
      {bool isPast = false}) async {
    // print("mmmmmm pdfId: ${course.course?.pdfId}");
    // return;
    state = state.copyWith(currentLesson: lesson, currentCourse: course);
    await downloadPdf(ref, course, lesson, isPast);
    if (!isPast) {
      playLesson();
    }
  }

  Future<void> playLesson() async {
    final audioData = AudioSource.uri(
      Uri.parse(state.currentLesson!.audioUrl),
      tag: MediaItem(
        id: state.currentLesson!.id,
        title: state.currentLesson!.title,
        artist: state.currentCourse!.course!.ustaz,
        album: state.currentCourse!.course!.category,
        artUri: Uri.parse(
          state.currentCourse!.course!.image,
        ),
        extras: state.currentCourse!.course!.toMap(),
      ),
    );
    final player = PlaylistHelper.audioPlayer;
    await player.setAudioSource(audioData);
    player.play();
  }

  Future<String?> getPdfPath(WidgetRef ref, CourseModel course, String title,
      int volume, int fileSize) async {
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
        fileSize: fileSize,
        ref.context,
      );
      if (file != null && i - 1 == volume) {
        pdfUrl = file.path;
      }
    }
    return pdfUrl;
  }

  Future<void> downloadPdf(
      WidgetRef ref, AssignedCourse course, Lesson lesson, bool isPast) async {
    state = state.copyWith(isDownloading: true);
    final pdfId = state.currentCourse?.course?.pdfId;
    // final courseModel = state.currentCourse?.course;
    print("mmmmmmm pdfId: $pdfId");
    if (pdfId == null) return;
    final courseModel =
        await DatabaseHelper().getSingleCourse(course.course!.courseId);
    print("mmmmmmm courseModel: $courseModel");
    if (courseModel == null) return;
    String? pdfUrl = await getPdfPath(ref, courseModel, course.title,
        lesson.volume, course.course!.pdfSize[lesson.volume]);
    state = state.copyWith(
      isDownloading: false,
      pdfPath: pdfUrl,
      cancelToken: null,
    );

    print("mmmmmmm pdfUrl: $pdfUrl");

    if (ref.context.mounted && pdfUrl != null) {
      Navigator.push(
        ref.context,
        MaterialPageRoute(
          builder: (_) => PdfPage(
              path: pdfUrl,
              pageNum: lesson.startPage,
              volume: lesson.volume.toDouble(),
              courseModel: courseModel,
              isFromPro: true,
              isPast: isPast),
        ),
      );
    }
  }

  void removeCurrentLesson() {
    state = state.copyWith(currentLesson: null, currentCourse: null);
  }

  Future<void> uploadConfusion(String path, BuildContext context) async {
    try {
      state = state.copyWith(isUploadingConfusion: true);

      final res = await customPostWithForm(
        confusionsApi,
        {
          "onLesson": "${state.currentLesson!.order}",
          "courseNum": "${state.currentCourse!.order}",
          "curriculumId": state.currentCourse!.curriculumId,
        },
        File(path),
        authorized: true,
      );

      if (res.statusCode == 200) {
        state = state.copyWith(isUploadingConfusion: false);
        //st
        // print("uploaded successfully.");

        toast("ጥያቄዎ ደርሶናል በ24 ሰአት ውስጥ እንመልሳለን። ኢንሻአላህ!", ToastType.success,
            context);
        if (state.currentLesson == null) return;
        // await PlaylistHelper.audioPlayer.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizPage(state.currentLesson!),
          ),
        );
      } else {
        print(res.statusCode);
        state = state.copyWith(isUploadingConfusion: false);
        toast("አፕሎድ ማረግ አልተቻለም!", ToastType.error, context);
      }
    } catch (err) {
      handleError(err.toString(), context, ref, () {
        state = state.copyWith(isUploadingConfusion: false);
        print(err.toString());

        toast(getErrorMsg(err.toString(), "አፕሎድ ማረግ አልተቻለም!"), ToastType.error,
            context);
      });
    }
  }

  Future<Object?> showConfusionDialog<T>(BuildContext context) async {
    if (!context.mounted) return null;

    final FlutterSoundRecorder recorder = FlutterSoundRecorder();
    final FlutterSoundPlayer player = FlutterSoundPlayer();

    bool isRecorderReady = false;
    bool isRecording = false;
    bool confusionUi = false;
    bool isPlaying = false;
    String? recordedFilePath;

    // Initialize recorder
    Future<void> initRecorder() async {
      await player.openPlayer();
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('እባክዎ ማይክሮፎን ፈቃድ ይስጡ።')),
        );
        return;
      }
      await recorder.openRecorder();
      isRecorderReady = true;
    }

    Future<void> startRecording() async {
      await initRecorder();
      if (!isRecorderReady) return;
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/confusion_${DateTime.now().millisecondsSinceEpoch}.aac';
      await recorder.startRecorder(toFile: path);
      recordedFilePath = path;
    }

    Future<void> stopRecording() async {
      if (!isRecorderReady) return;
      await recorder.stopRecorder();
    }

    Future<void> playRecording(VoidCallback setState) async {
      if (recordedFilePath == null) return;
      await player.startPlayer(
        fromURI: recordedFilePath,
        whenFinished: () {
          isPlaying = false;
          setState();
        },
      );
    }

    Future<void> stopPlayback() async {
      await player.stopPlayer();
    }

    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (confusionUi) ...[
                          confusionContent(
                            () {
                              setState(() {});
                            },
                            isRecording,
                            recordedFilePath,
                            isPlaying,
                            startRecording,
                            (v) => setState(() {
                              isRecording = v;
                            }),
                            stopRecording,
                            playRecording,
                            stopPlayback,
                            (v) => setState(() {
                              isPlaying = v;
                            }),
                            (v) => setState(() {
                              recordedFilePath = v;
                            }),
                            context,
                          ),
                        ] else ...[
                          initialContent(
                            () {
                              setState(
                                () {
                                  confusionUi = true;
                                },
                              );
                            },
                            context,
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() async {
      await recorder.closeRecorder();
      await player.closePlayer();
    });
  }

  Widget confusionContent(
      setState,
      isRecording,
      recordedFilePath,
      isPlaying,
      startRecording,
      setRecording,
      stopRecording,
      playRecording,
      stopPlayback,
      setPlaying,
      setRecordedFilePath,
      BuildContext context) {
    return Column(
      children: [
        Text(
          "ጥያቄ መጠየቂያ",
          style: TextStyle(fontSize: 18),
        ),
        // Recording state
        if (!isRecording && recordedFilePath == null) ...[
          SizedBox(
            height: 25,
          ),
          BouncyElevatedButton(
            child: GestureDetector(
              onTap: () async {
                print(state.currentLesson?.id);
                await startRecording();
                setRecording(true);
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 36),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          const Text(
            'እባኮትን ድምፅዎን ይመዝግቡ...',
            style: TextStyle(
              // fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
        if (isRecording)
          Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/recording.json',
                        height: 140,
                        repeat: true,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'እባኮትን ድምፅዎን ይመዝግቡ...',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  await stopRecording();
                  setRecording(false);
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Icon(Icons.stop, color: Colors.white, size: 36),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'አቁም',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),

        // Recorded state
        if (recordedFilePath != null && !isRecording)
          Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  // border: Border.all(),
                  // color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                        color: primaryColor,
                        size: 42,
                      ),
                      onPressed: () async {
                        if (isPlaying) {
                          await stopPlayback();
                          // setState(() => isPlaying = false);
                          setPlaying(false);
                        } else {
                          await playRecording(() {
                            setPlaying(false);
                          });
                          // setState(() => isPlaying = true);
                          setPlaying(true);
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        if (!isPlaying)
                          Text(
                            'ድምፅዎን ይሰሙ 🎧',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        if (isPlaying)
                          Center(
                            child: Lottie.asset(
                              'assets/animations/playing.json',
                              height: 100,
                              repeat: true,
                            ),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: whiteColor,
                          ),
                          onPressed: () async {
                            await stopPlayback();
                            // setState(() => isPlaying = false);
                            setPlaying(false);
                            setRecordedFilePath(null);
                          },
                          child: Text("ድጋሚ ቅዳ"),
                        ),
                      ],
                    ),

                    // TextButton(
                    //   onPressed: () async {
                    //     await stopPlayback();
                    //     // setState(() => isPlaying = false);
                    //     setPlaying(false);
                    //     setRecordedFilePath(null);
                    //   },
                    //   child: Text("ድጋሚ ቅዳ"),
                    // )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Consumer(builder: (context, ref, _) {
                final state = ref.watch(lessonNotifierProvider);
                return ElevatedButton(
                  onPressed: () => uploadConfusion(recordedFilePath, context),
                  // icon: const Icon(Icons.send_rounded),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: state.isUploadingConfusion
                      ? CircularProgressIndicator(
                          color: whiteColor,
                        )
                      : const Text(
                          "አስገባ እና ላክ 📤",
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                );
              }),
            ],
          ),
      ],
    );
  }

  Widget initialContent(VoidCallback onConfusion, BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/success.json',
          height: 160,
          repeat: false,
        ),
        const Text(
          'እንኳን ደስ አለዎት 🎧',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '"${state.currentLesson?.title}"ን ተምረው ጨርሰዋል! ማሻአላህ!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 18),
        const Text(
          'የዛሬው ደርስ ላይ ጥያቄ አልዎት?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizPage(state.currentLesson!),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'አይ፣ ጥያቄ የለኝም 👍',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  onConfusion();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'አዎ፣ ጥያቄ አለኝ 💭',
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
