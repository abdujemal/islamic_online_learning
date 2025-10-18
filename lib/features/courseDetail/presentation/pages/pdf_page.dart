// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/note_helper.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/add_note.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_bottom_view.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/finish_confirmation.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/pdf_drawer.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../main/data/model/course_model.dart';

class PdfPage extends ConsumerStatefulWidget {
  final String path;
  final int pageNum;
  final bool isFromPro;
  final CourseModel courseModel;
  final double volume;
  const PdfPage({
    super.key,
    required this.path,
    this.pageNum = 0,
    this.isFromPro = false,
    required this.volume,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfPageState();
}

class _PdfPageState extends ConsumerState<PdfPage> {
  late PDFViewController pdfViewController;

  late CourseModel courseModel;

  int? pages;

  int? currentPage;

  bool? isReady;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PDFViewController _controller;

  bool showTopAudio = false;
  bool showNotes = false;

  final TextEditingController _pageTc = TextEditingController();
  final FocusNode _pageFocus = FocusNode();
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  void dispose() {
    if (widget.isFromPro) {
      _playerStateSub?.cancel();
      ref.read(lessonNotifierProvider.notifier).removeCurrentLesson();
    }
    super.dispose();
    _pageTc.dispose();
    _pageFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    courseModel = widget.courseModel;

    if (widget.isFromPro) {
      _playerStateSub = PlaylistHelper.audioPlayer.playerStateStream
          .listen(playerStreamListener);
    }
  }

  void playerStreamListener(PlayerState _) async {
    if (_.processingState == ProcessingState.completed) {
      final lessonN = ref.read(lessonNotifierProvider.notifier);
      // final lessonState = ref.read(lessonNotifierProvider);
      await lessonN.showConfusionDialog(context);

      // if (response == 'yes') {
      //   // ✅ Open a form or navigate to confusion submission screen
      //   // Navigator.pushNamed(context, '/confusion', arguments: lesson);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Confusion ui is loading...')),
      //   );
      //   print("Mounted ${context.mounted}");
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>
      //           AddConfusionPage(lesson: lessonState.currentLesson!),
      //     ),
      //   );
      // } else {
      //   // 👌 Maybe show a “Thank you” snackbar or move to the next lesson
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Glad everything is clear!')),
      //   );

      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = PlaylistHelper.audioPlayer;

    ThemeMode theme = ref.read(themeProvider);

    return WillPopScope(
      onWillPop: () async {
        if (kDebugMode) {
          print("currentPage:$currentPage");
          print("totalPage:$pages");
        }
        if (widget.isFromPro) {
          await PlaylistHelper.audioPlayer.stop();
          return true;
        }
        if (currentPage != null && pages != null) {
          if ((currentPage! + 1) / pages! == 1) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => FinishConfirmation(
                title: courseModel.title,
                onConfirm: () {
                  if (mounted) {
                    ref.read(mainNotifierProvider.notifier).saveCourse(
                          courseModel.copyWith(
                            isStarted: 1,
                            isFinished: 1,
                            pdfPage: currentPage! + 1,
                            pdfNum: widget.volume,
                            lastViewed: DateTime.now().toString(),
                            pausedAtAudioNum:
                                courseModel.courseIds.split(",").length - 1,
                          ),
                          null,
                          context,
                          showMsg: false,
                        );
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          } else {
            if (kDebugMode) {
              print("the page is${currentPage! + 1}");
            }
            ref
                .read(mainNotifierProvider.notifier)
                .saveCourse(
                  courseModel.copyWith(
                    isStarted: 1,
                    pdfPage: currentPage! + 1,
                    pdfNum: widget.volume,
                    lastViewed: DateTime.now().toString(),
                  ),
                  null,
                  context,
                  showMsg: false,
                )
                .then(
              (value) {
                // ref.read(mainNotifierProvider.notifier).updateCourse(
                //       courseModel.copyWith(
                //         isStarted: 1,
                //         pdfPage: currentPage! + 1,
                //         pdfNum: widget.volume,
                //         lastViewed: DateTime.now().toString(),
                //       ),
                //     );

                Navigator.pop(context);
              },
            );
          }
        }
        return false;
      },
      child: StreamBuilder(
          stream: myAudioStream(audioPlayer),
          builder: (context, snap) {
            final state = snap.data?.sequenceState;
            final processState = snap.data?.processingState;

            if (state?.sequence.isEmpty ?? true) {
              showTopAudio = false;
            }
            MediaItem? metaData = state?.currentSource?.tag;

            if (metaData != null &&
                "${metaData.extras?["courseId"]}" != courseModel.courseId) {
              showTopAudio = true;
            }

            if (processState == ProcessingState.idle) {
              showTopAudio = false;
            }
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: TextScroll(
                  pauseBetween: const Duration(seconds: 1),
                  velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                  courseModel.title,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 130,
                      // height: 100,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            // height: 60,
                            child: TextField(
                              controller: _pageTc,
                              focusNode: _pageFocus,
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                if (_pageTc.text.isNotEmpty) {
                                  int pg = int.parse(_pageTc.text) - 1;
                                  _controller.setPage(pg);
                                  _pageFocus.unfocus();
                                  _pageTc.text = "";
                                }
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                ),
                                hintText: "ገጽ",
                                enabledBorder: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            child: const Text(
                              "ግለጽ",
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                            onTap: () {
                              if (_pageTc.text.isNotEmpty) {
                                int pg = int.parse(_pageTc.text) - 1;
                                _controller.setPage(pg);
                                _pageFocus.unfocus();
                                _pageTc.text = "";
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
                // leading:
                // IconButton(
                //   onPressed: () async {
                //     print("currentPage:$currentPage");
                //     print("totalPage:$pages");
                //     if (currentPage != null && pages != null) {
                //       if ((currentPage! + 1) / pages! == 1) {
                //         showDialog(
                //           context: context,
                //           barrierDismissible: false,
                //           builder: (ctx) => FinishConfirmation(
                //             title: courseModel.title,
                //             action: () {
                //               ref
                //                   .read(mainNotifierProvider.notifier)
                //                   .saveCourse(
                //                     courseModel.copyWith(
                //                       isStarted: 1,
                //                       isFinished: 1,
                //                       pdfPage: currentPage! + 1,
                //                       pausedAtAudioNum:                 //                           .courseModel.courseIds
                //                           .split(",")
                //                           .length,
                //                     ),
                //                     null,
                //                     showMsg: false,
                //                   );
                //               Navigator.pop(context);
                //               Navigator.pop(context);
                //             },
                //           ),
                //         );
                //       } else {
                //         ref.read(mainNotifierProvider.notifier).saveCourse(
                //               courseModel.copyWith(
                //                 isStarted: 1,
                //                 pdfPage: currentPage! + 1,
                //               ),
                //               null,
                //               showMsg: false,
                //             );
                //         Navigator.pop(context);
                //       }
                //     }
                //   },
                //   icon: const Icon(Icons.arrow_back),
                // ),
                bottom: PreferredSize(
                  preferredSize: Size(
                    MediaQuery.of(context).size.width,
                    showTopAudio ? 40 : 0,
                  ),
                  child: showTopAudio
                      ? CurrentAudioView(metaData as MediaItem)
                      : const SizedBox(),
                ),
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.53,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final int page = ref.watch(pdfPageProvider);

                        // final notes =  NoteHiveHelper().getAllNoteOfAPage(
                        //   page,
                        //   widget.courseModel.id!,
                        // );

                        return FutureBuilder(
                          builder: (context, snap) {
                            if (snap.hasError) {
                              return const SizedBox();
                            }
                            if (snap.data == null) {
                              return const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircularProgressIndicator());
                            }
                            if (!showNotes && snap.data!.isNotEmpty) {
                              return Align(
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  child: const Text(
                                    "ማስታወሻዎቼ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: whiteColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    showNotes = true;
                                    setState(() {});
                                  },
                                ),
                              );
                            }
                            if (!showNotes) {
                              return const SizedBox();
                            }
                            if (snap.data!.isEmpty) {
                              return const SizedBox();
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(110, 0, 0, 0),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        const Text(
                                          "ማስታወሻዎች",
                                          style: TextStyle(
                                            color: whiteColor,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showNotes = false;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: snap.data!.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${index + 1}. ${snap.data![index]['note']}",
                                                style: const TextStyle(
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                            if (snap.data![index]['id'] != null)
                                              GestureDetector(
                                                onTap: () {
                                                  NoteHiveHelper().deleteNote(
                                                      snap.data![index]['id']);
                                                  ref
                                                      .read(pdfPageProvider
                                                          .notifier)
                                                      .update((i) => 0);
                                                  ref
                                                      .read(pdfPageProvider
                                                          .notifier)
                                                      .update((i) => page);
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          future: NoteHiveHelper().getAllNoteOfAPage(
                            page,
                            widget.courseModel.id!,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FloatingActionButton(
                    child: const Text(
                      "ድምጾች",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AddNote(
                          page: currentPage ?? 0,
                          courseId: courseModel.id!,
                          ref: ref,
                        ),
                      );
                    },
                    child: const Card(
                      color: primaryColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Icon(
                                Icons.note_add,
                                color: whiteColor,
                              ),
                              Expanded(
                                child: Text(
                                  "ማስታወሻ ያዝ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              drawer: PdfDrawer(
                audios: courseModel.courseIds.split(","),
                title: courseModel.title,
                courseModel: courseModel,
              ),
              bottomNavigationBar: AudioBottomView(
                courseModel.courseId,
                () {
                  if (widget.isFromPro) {
                    return;
                  }
                  // audioPlayer.sequenceState.

                  if (courseModel.isFinished == 0) {
                    courseModel = courseModel.copyWith(
                      isStarted: 1,
                      pausedAtAudioNum: PlaylistHelper.mainPlayListIndexes[
                              audioPlayer.currentIndex ?? 0] -
                          1,
                      pausedAtAudioSec: audioPlayer.position.inSeconds,
                      lastViewed: DateTime.now().toString(),
                    );

                    setState(() {});
                  }
                },
              ),
              body: SafeArea(
                child: PDFView(
                  filePath: widget.path,
                  defaultPage: courseModel.pdfPage.toInt() - 1,
                  pageSnap: false,
                  autoSpacing: false,
                  nightMode: theme == ThemeMode.dark,
                  pageFling: false,
                  onRender: (pgs) {
                    setState(() {
                      pages = pgs;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    toast(error, ToastType.error, context);
                  },
                  onPageError: (page, error) {
                    toast(
                        '$page: ${error.toString()}', ToastType.error, context);
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller = pdfViewController;
                  },
                  onPageChanged: (int? page, int? total) {
                    if (page != null && total != null) {
                      ref.read(pdfPageProvider.notifier).update((i) => page);
                      currentPage = page;
                      toast("${page + 1} / $total", ToastType.normal, context);
                    }
                  },
                ),
              ),
            );
          }),
    );
  }
}
