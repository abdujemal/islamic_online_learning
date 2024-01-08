// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/course_detail.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/pdf_page.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../courseDetail/presentation/stateNotifier/providers.dart';
import '../pages/filtered_courses.dart';

class CourseItem extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const CourseItem(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends ConsumerState<CourseItem> {
  double percentage = 0.0;
  List<AudioSource> playList = [];

  Future<void> createPlayList() async {
    playList = [];
    Directory dir = await getApplicationSupportDirectory();
    List<String> audioIds = widget.courseModel.courseIds.split(",");

    int i = 0;
    List<AudioSource> lst = [];

    for (String id in audioIds) {
      i++;
      if (await checkFile(i)) {
        String fileName =
            "${widget.courseModel.ustaz},${widget.courseModel.title} $i.mp3";

        lst.add(
          AudioSource.file(
            "${dir.path}/Audio/$fileName",
            tag: MediaItem(
              id: id,
              title: "${widget.courseModel.title} $i",
              artist: widget.courseModel.ustaz,
              album: widget.courseModel.category,
              artUri: Uri.file(
                  "${dir.path}/Images/${widget.courseModel.title}.jpg"),
              extras: widget.courseModel.toMap(),
            ),
          ),
        );
      } else {
        if (mounted) {
          final url = await ref
              .read(cdNotifierProvider.notifier)
              .loadFileOnline(id, true, showError: false, context);
          if (url != null) {
            lst.add(
              AudioSource.uri(
                Uri.parse(
                  url,
                ),
                tag: MediaItem(
                  id: id,
                  title: "${widget.courseModel.title} $i",
                  artist: widget.courseModel.ustaz,
                  album: widget.courseModel.category,
                  artUri: Uri.file(
                      "${dir.path}/Images/${widget.courseModel.title}.jpg"),
                  extras: widget.courseModel.toMap(),
                ),
              ),
            );
          }
        }
      }
    }
    playList.addAll(lst);
    if (mounted) {
      setState(() {});
    }
    if (kDebugMode) {
      print("playlist itams: ${playList.length}");
    }
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  Future<bool> checkFile(int index) async {
    if (mounted) {
      final isDownloaded =
          await ref.read(cdNotifierProvider.notifier).isDownloaded(
                "${widget.courseModel.ustaz},${widget.courseModel.title} $index.mp3",
                "Audio",
                context,
              );
      return isDownloaded;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    percentage = getPersentage(widget.courseModel);

    // if (widget.courseModel.isFinished == 0 && percentage == 1) {
    //   ref.read(mainNotifierProvider.notifier).saveCourse(
    //         widget.courseModel.copyWith(isFinished: 1),
    //         null,
    //         showMsg: false,
    //       );
    // }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetail(
              cm: widget.courseModel,
            ),
          ),
        );
      },
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        FutureBuilder(
                          future: displayImage(
                            widget.courseModel.image,
                            widget.courseModel.category == "ተፍሲር"
                                ? "ተፍሲር"
                                : widget.courseModel.title,
                            ref,
                          ),
                          builder: (context, snap) {
                            return Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: snap.data == null
                                    ? null
                                    : snap.data!.path.isNotEmpty
                                        ? DecorationImage(
                                            image: FileImage(snap.data!),
                                            fit: BoxFit.fill,
                                          )
                                        : null,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: snap.data == null
                                  ? Shimmer.fromColors(
                                      baseColor: Theme.of(context)
                                          .chipTheme
                                          .backgroundColor!
                                          .withAlpha(150),
                                      highlightColor: Theme.of(context)
                                          .chipTheme
                                          .backgroundColor!,
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    )
                                  : snap.data!.path.isEmpty
                                      ? Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .chipTheme
                                                .backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.error_rounded),
                                          ),
                                        )
                                      : widget.courseModel.isStarted == 1 &&
                                              widget.courseModel.isFinished == 0
                                          ? Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: cardColor,
                                                        value: percentage,
                                                        backgroundColor:
                                                            Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        await createPlayList();
                                                        if (playList
                                                            .isNotEmpty) {
                                                          await ref
                                                              .read(
                                                                  audioProvider)
                                                              .setAudioSource(
                                                                ConcatenatingAudioSource(
                                                                  children:
                                                                      playList,
                                                                ),
                                                                initialIndex: widget
                                                                            .courseModel
                                                                            .pausedAtAudioNum <
                                                                        0
                                                                    ? 0
                                                                    : widget
                                                                        .courseModel
                                                                        .pausedAtAudioNum,
                                                                initialPosition:
                                                                    Duration(
                                                                  seconds: widget
                                                                      .courseModel
                                                                      .pausedAtAudioSec,
                                                                ),
                                                              );
                                                          ref
                                                              .read(
                                                                  audioProvider)
                                                              .play();

                                                          if (mounted) {
                                                            bool
                                                                isPDFDownloded =
                                                                await ref
                                                                    .read(cdNotifierProvider
                                                                        .notifier)
                                                                    .isDownloaded(
                                                                      widget.courseModel
                                                                              .pdfId
                                                                              .contains(",")
                                                                          ? "${widget.courseModel.title} ${widget.courseModel.pdfNum.toInt()}.pdf"
                                                                          : "${widget.courseModel.title}.pdf",
                                                                      "PDF",
                                                                      context,
                                                                    );
                                                            if (widget
                                                                    .courseModel
                                                                    .pdfId
                                                                    .trim()
                                                                    .isNotEmpty &&
                                                                isPDFDownloded) {
                                                              String path =
                                                                  await getPath(
                                                                'PDF',
                                                                widget.courseModel
                                                                        .pdfId
                                                                        .contains(
                                                                            ",")
                                                                    ? "${widget.courseModel.title} ${widget.courseModel.pdfNum.toInt()}.pdf"
                                                                    : "${widget.courseModel.title}.pdf",
                                                              );
                                                              if (mounted) {
                                                                await Navigator
                                                                    .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        PdfPage(
                                                                      volume: widget
                                                                          .courseModel
                                                                          .pdfNum,
                                                                      path:
                                                                          path,
                                                                      courseModel:
                                                                          widget
                                                                              .courseModel,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            } else {
                                                              if (mounted) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        CourseDetail(
                                                                      cm: widget
                                                                          .courseModel,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .play_arrow_rounded,
                                                        color: cardColor,
                                                        size: 33,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : widget.courseModel.isFinished == 1
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(23),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: const Align(
                                                    child: Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: cardColor,
                                                      size: 39,
                                                    ),
                                                  ),
                                                )
                                              : null,
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 80,
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15),
                              ),
                            ),
                            child: widget.courseModel.isStarted == 1
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      "${(percentage * 100).toStringAsFixed(1)}%",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: whiteColor,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.music_note_rounded,
                                        color: whiteColor,
                                        size: 19,
                                      ),
                                      Text(
                                        "${widget.courseModel.courseIds.split(",").length}",
                                        style: const TextStyle(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 23,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetail(
                                      cm: widget.courseModel,
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilteredCourses(
                                      "title",
                                      widget.courseModel.title,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                widget.courseModel.title,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (widget.courseModel.isFav == 1) {
                          if (widget.courseModel.isStarted == 1) {
                            await ref
                                .read(mainNotifierProvider.notifier)
                                .saveCourse(widget.courseModel, 0, context);
                          } else {
                            ref
                                .read(favNotifierProvider.notifier)
                                .deleteCourse(widget.courseModel.id, context);
                          }
                        } else {
                          await ref
                              .read(mainNotifierProvider.notifier)
                              .saveCourse(widget.courseModel, 1, context);
                        }
                      },
                      child: widget.courseModel.isFav == 1
                          ? const Icon(
                              Icons.bookmark_rounded,
                              size: 30,
                              color: primaryColor,
                            )
                          : const Icon(
                              Icons.bookmark_border_outlined,
                              size: 30,
                            ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetail(
                          cm: widget.courseModel,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredCourses(
                          "ustaz",
                          widget.courseModel.ustaz,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 2,
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(15),
                        ),
                        color: primaryColor),
                    child: Text(
                      widget.courseModel.ustaz,
                      style: const TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ),
              if (widget.courseModel.category != "")
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetail(
                            cm: widget.courseModel,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilteredCourses(
                            "category",
                            widget.courseModel.category,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 5,
                      ),
                      // height: 20,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomRight: Radius.circular(15),
                        ),
                        color: primaryColor,
                      ),
                      child: Text(
                        widget.courseModel.category,
                        style: const TextStyle(color: whiteColor),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
