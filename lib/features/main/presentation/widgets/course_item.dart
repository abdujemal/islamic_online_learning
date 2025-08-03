// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Schedule%20Feature/schedule.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/course_detail.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/pdf_page.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/Audio Feature/playlist_helper.dart';
import '../../../courseDetail/presentation/stateNotifier/providers.dart';
import '../pages/filtered_courses.dart';

class CourseItem extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  final GlobalKey? courseTitle;
  final GlobalKey? courseUstaz;
  final GlobalKey? courseCategory;
  final String? keey;
  final String? val;
  final int index;
  final bool fromHome;
  const CourseItem(
    this.courseModel, {
    this.index = 2,
    this.fromHome = true,
    this.courseCategory,
    this.courseUstaz,
    this.courseTitle,
    required this.keey,
    required this.val,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends ConsumerState<CourseItem> {
  double percentage = 0.0;

  List<String> audios = [];
  List<int> playListIndexes = [];

  List<AudioSource> lst = [];
  late CourseModel courseModel;

  @override
  initState() {
    super.initState();
    courseModel = widget.courseModel;
    audios = widget.courseModel.courseIds.split(",");
  }

  Future<void> createPlayList() async {
    if (mounted) {
      setState(() {});
    }

    Directory dir = await getApplicationSupportDirectory();

    int i = 0;
    lst = [];
    playListIndexes = [];
    ref.read(loadAudiosProvider.notifier).update((state) => 0);
    for (String id in audios) {
      i++;
      if (await checkFile(i)) {
        String fileName = "${courseModel.ustaz},${courseModel.title} $i.mp3";

        if (mounted) {
          ref.read(loadAudiosProvider.notifier).update((state) => state + 1);
        }
        playListIndexes.add(i);
        lst.add(
          AudioSource.file(
            "${dir.path}/Audio/$fileName",
            tag: MediaItem(
              id: id,
              title: "${courseModel.title} $i",
              artist: courseModel.ustaz,
              album: courseModel.category,
              artUri: Uri.parse(courseModel.image),
              extras: courseModel.toMap(),
            ),
          ),
        );
      }
    }
    if (isPlayingCourseThisCourse(courseModel.courseId, ref)) {
      print("playlist updateing");
      PlaylistHelper.mainPlayListIndexes = playListIndexes;
      // int prevLen = PlaylistHelper().playList?.length ?? 0;
      // PlaylistHelper().playList?.addAll(lst);
      // PlaylistHelper().playList?.removeRange(0, prevLen - 1);
      // ref.read(playlistProvider).addAll(lst);
    } else {
      print("playlist adding");

      // myPlaylist = ConcatenatingAudioSource(children: lst);
    }
    if (mounted) {
      setState(() {});
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
    percentage = getPersentage(widget.courseModel).isNaN
        ? 1
        : getPersentage(widget.courseModel);

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
              keey: widget.keey,
              val: widget.val,
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
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                height: 80,
                                width: 80,
                                imageUrl: widget.courseModel.image,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Shimmer.fromColors(
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
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: widget.courseModel.isStarted == 1 &&
                                      widget.courseModel.isFinished == 0
                                  ? Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: CircularProgressIndicator(
                                                color: cardColor,
                                                value: percentage,
                                                backgroundColor: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            child: IconButton(
                                              onPressed: () async {
                                                await createPlayList();
                                                final playList =
                                                    PlaylistHelper().playList;
                                                final audioPlayer =
                                                    PlaylistHelper.audioPlayer;

                                                if (!playListIndexes.contains(
                                                    courseModel
                                                            .pausedAtAudioNum +
                                                        1)) {
                                                  if (mounted) {
                                                    toast(
                                                      "${courseModel.title} ${courseModel.pausedAtAudioNum + 1} ዳውንሎድ አልተደረገም.",
                                                      ToastType.normal,
                                                      context,
                                                    );
                                                  }
                                                  return;
                                                }
                                                if (!isPlayingCourseThisCourse(
                                                    courseModel.courseId,
                                                    ref)) {
                                                  PlaylistHelper()
                                                      .playList
                                                      .clear();
                                                  PlaylistHelper()
                                                      .playList
                                                      .addAll(lst);
                                                }
                                                if (playList.length > 0) {
                                                  int playableIndex =
                                                      playListIndexes.indexOf(
                                                          courseModel
                                                                  .pausedAtAudioNum +
                                                              1);
                                                  print(
                                                      "playListIndexes: $playListIndexes");
                                                  print(
                                                      "pausedAtAudioNum: $playableIndex");
                                                  await PlaylistHelper
                                                      .audioPlayer
                                                      .setAudioSources(
                                                    playList,
                                                    initialIndex: courseModel
                                                                .pausedAtAudioNum <
                                                            0
                                                        ? 0
                                                        : playableIndex,
                                                    initialPosition: Duration(
                                                      seconds: courseModel
                                                          .pausedAtAudioSec,
                                                    ),
                                              preload: false,

                                                  );
                                                  audioPlayer.play();

                                                  if (mounted) {
                                                    bool isPDFDownloded =
                                                        await ref
                                                            .read(
                                                                cdNotifierProvider
                                                                    .notifier)
                                                            .isDownloaded(
                                                              courseModel.pdfId
                                                                      .contains(
                                                                          ",")
                                                                  ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
                                                                  : "${courseModel.title}.pdf",
                                                              "PDF",
                                                              context,
                                                            );
                                                    print(
                                                        "isPDFDownloded:- $isPDFDownloded");
                                                    print(courseModel.pdfId
                                                            .contains(",")
                                                        ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
                                                        : "${courseModel.title}.pdf");
                                                    if (courseModel.pdfId
                                                            .trim()
                                                            .isNotEmpty &&
                                                        isPDFDownloded) {
                                                      String path =
                                                          await getPath(
                                                        'PDF',
                                                        courseModel.pdfId
                                                                .contains(",")
                                                            ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
                                                            : "${courseModel.title}.pdf",
                                                      );
                                                      if (mounted) {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                PdfPage(
                                                              volume:
                                                                  courseModel
                                                                      .pdfNum,
                                                              path: path,
                                                              courseModel:
                                                                  courseModel,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      if (mounted) {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                CourseDetail(
                                                              cm: courseModel,
                                                              keey: widget.keey,
                                                              val: widget.val,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.play_arrow_rounded,
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
                                          padding: const EdgeInsets.all(23),
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Align(
                                            child: Icon(
                                              Icons.check_circle_outline,
                                              color: cardColor,
                                              size: 39,
                                            ),
                                          ),
                                        )
                                      : null,
                            ),
                            widget.courseModel.isStarted == 1 &&
                                    widget.courseModel.isScheduleOn == 1
                                ? const Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Icon(
                                      Icons.notifications_active,
                                      color: whiteColor,
                                      size: 20,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        if (widget.courseModel.isCompleted != 1)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 70,
                              ),
                              width: 80,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                                color: Colors.black45,
                              ),
                              child: const Center(
                                child: Text(
                                  "አላለቀም",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
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
                              key:
                                  widget.index == 0 ? widget.courseTitle : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetail(
                                      cm: widget.courseModel,
                                      keey: widget.keey,
                                      val: widget.val,
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
                    !widget.fromHome && widget.courseModel.isStarted == 1
                        ? GestureDetector(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              if (widget.courseModel.isFav == 1) {
                                await ref
                                    .read(mainNotifierProvider.notifier)
                                    .saveCourse(
                                      widget.courseModel.copyWith(isStarted: 0),
                                      widget.courseModel.isFav,
                                      context,
                                    );

                                List<int> days = widget
                                    .courseModel.scheduleDates
                                    .split(",")
                                    .map((e) => int.parse(e))
                                    .toList();

                                await Schedule().deleteNotification(
                                  widget.courseModel.id!,
                                  days,
                                );
                              } else {
                                await ref
                                    .read(mainNotifierProvider.notifier)
                                    .saveCourse(
                                      widget.courseModel.copyWith(isStarted: 0),
                                      widget.courseModel.isFav,
                                      context,
                                    );

                                List<int> days = widget
                                    .courseModel.scheduleDates
                                    .split(",")
                                    .map((e) => int.parse(e))
                                    .toList();

                                await Schedule().deleteNotification(
                                  widget.courseModel.id!,
                                  days,
                                );
                              }
                            },
                          )
                        : IconButton(
                            onPressed: () async {
                              if (widget.courseModel.isFav == 1) {
                                if (widget.courseModel.isStarted == 1) {
                                  await ref
                                      .read(mainNotifierProvider.notifier)
                                      .saveCourse(
                                          widget.courseModel, 0, context);
                                } else {
                                  await ref
                                      .read(mainNotifierProvider.notifier)
                                      .saveCourse(
                                          widget.courseModel, 0, context);
                                }
                              } else {
                                await ref
                                    .read(mainNotifierProvider.notifier)
                                    .saveCourse(widget.courseModel, 1, context);
                              }
                            },
                            icon: widget.courseModel.isFav == 1
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
                  key: widget.index == 0 ? widget.courseUstaz : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetail(
                          cm: widget.courseModel,
                          keey: widget.keey,
                          val: widget.val,
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
                    key: widget.index == 0 ? widget.courseCategory : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetail(
                            cm: widget.courseModel,
                            keey: widget.keey,
                            val: widget.val,
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
