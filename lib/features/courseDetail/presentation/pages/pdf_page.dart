// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_bottom_view.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/finish_confirmation.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/pdf_drawer.dart';
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
  final CourseModel courseModel;
  const PdfPage({
    super.key,
    required this.path,
    this.pageNum = 0,
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

  final TextEditingController _pageTc = TextEditingController();
  final FocusNode _pageFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _pageTc.dispose();
    _pageFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    courseModel = widget.courseModel;
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);

    ThemeMode theme = ref.read(themeProvider);

    return WillPopScope(
      onWillPop: () async {
        if (kDebugMode) {
          print("currentPage:$currentPage");
          print("totalPage:$pages");
        }
        if (currentPage != null && pages != null) {
          if ((currentPage! + 1) / pages! == 1) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => FinishConfirmation(
                title: courseModel.title,
                onConfirm: () {
                  ref.read(mainNotifierProvider.notifier).saveCourse(
                        courseModel.copyWith(
                          isStarted: 1,
                          isFinished: 1,
                          pdfPage: currentPage! + 1,
                          lastViewed: DateTime.now().toString(),
                          pausedAtAudioNum:
                              courseModel.courseIds.split(",").length - 1,
                        ),
                        null,
                        showMsg: false,
                      );
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
                    lastViewed: DateTime.now().toString(),
                  ),
                  null,
                  showMsg: false,
                )
                .then(
              (value) {
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
              floatingActionButton: FloatingActionButton(
                child: const Text(
                  "ድምጾች",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              drawer: PdfDrawer(
                audios: courseModel.courseIds.split(","),
                title: courseModel.title,
                courseModel: courseModel,
              ),
              bottomNavigationBar: AudioBottomView(
                courseModel.courseId,
                () {
                  if (courseModel.isFinished == 0) {
                    courseModel = courseModel.copyWith(
                      isStarted: 1,
                      pausedAtAudioNum: audioPlayer.currentIndex,
                      pausedAtAudioSec: audioPlayer.position.inSeconds,
                    );

                    setState(() {});
                  }
                },
              ),
              body: PDFView(
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
                  toast(error, ToastType.error);
                },
                onPageError: (page, error) {
                  toast('$page: ${error.toString()}', ToastType.error);
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  _controller = pdfViewController;
                },
                onPageChanged: (int? page, int? total) {
                  if (page != null && total != null) {
                    currentPage = page;
                    toast("${page + 1} / $total", ToastType.normal);
                  }
                },
              ),
            );
          }),
    );
  }
}
