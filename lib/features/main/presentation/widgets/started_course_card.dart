// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/playlist_helper.dart';
import '../../../../core/constants.dart';
import '../../../courseDetail/presentation/pages/course_detail.dart';
import '../../../courseDetail/presentation/pages/pdf_page.dart';
import '../../../courseDetail/presentation/stateNotifier/providers.dart';

class StartedCourseCard extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const StartedCourseCard({
    super.key,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StartedCourseCardState();
}

class _StartedCourseCardState extends ConsumerState<StartedCourseCard> {
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
      if (await checkFile(
          i, int.parse(courseModel.audioSizes.split(",")[i - 1]))) {
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

  Future<bool> checkFile(int index, int size) async {
    if (mounted) {
      final isDownloaded =
          await ref.read(cdNotifierProvider.notifier).isDownloaded(
                "${widget.courseModel.ustaz},${widget.courseModel.title} $index.mp3",
                "Audio",
                // widget.courseModel.courseIds[index-1],
                context,
                size,
              );
      print(
          "${widget.courseModel.ustaz},${widget.courseModel.title} $index.mp3 => $isDownloaded");
      return isDownloaded;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    percentage = getPercentage(widget.courseModel).isNaN
        ? 1
        : getPercentage(widget.courseModel);

    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: SizedBox(
        height: 140,
        width: 100,
        child:
            // Column(
            //   children: [
            InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseDetail(
                  cm: widget.courseModel,
                  keey: null,
                  val: null,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.courseModel.image,
                    ),
                    fit: BoxFit.fill,
                  ),
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
                                  final playList = PlaylistHelper().playList;
                                  final audioPlayer =
                                      PlaylistHelper.audioPlayer;
                                  PlaylistHelper.mainPlayListIndexes =
                                      playListIndexes;

                                  if (!playListIndexes.contains(
                                      courseModel.pausedAtAudioNum + 1)) {
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
                                      courseModel.courseId, ref)) {
                                    PlaylistHelper().playList.clear();
                                    PlaylistHelper().playList.addAll(lst);
                                  }
                                  if (playList.length > 0) {
                                    int playableIndex = playListIndexes.indexOf(
                                        courseModel.pausedAtAudioNum + 1);
                                    print("playListIndexes: $playListIndexes");
                                    print("pausedAtAudioNum: $playableIndex");
                                    await PlaylistHelper.audioPlayer
                                        .setAudioSources(
                                      playList,
                                      initialIndex:
                                          courseModel.pausedAtAudioNum < 0
                                              ? 0
                                              : playableIndex,
                                      initialPosition: Duration(
                                        seconds: courseModel.pausedAtAudioSec,
                                      ),
                                    );
                                    audioPlayer.play();

                                    if (mounted) {
                                      bool isPDFDownloded = await ref
                                          .read(cdNotifierProvider.notifier)
                                          .isDownloaded(
                                            courseModel.pdfId.contains(",")
                                                ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
                                                : "${courseModel.title}.pdf",
                                            "PDF",
                                            context,
                                          );
                                      print("isPDFDownloded:- $isPDFDownloded");
                                      print(courseModel.pdfId.contains(",")
                                          ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
                                          : "${courseModel.title}.pdf");
                                      if (courseModel.pdfId.trim().isNotEmpty &&
                                          isPDFDownloded) {
                                        String path = await getPath(
                                          'PDF',
                                          courseModel.pdfId.contains(",")
                                              ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
                                              : "${courseModel.title}.pdf",
                                        );
                                        if (mounted) {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PdfPage(
                                                volume: courseModel.pdfNum,
                                                path: path,
                                                courseModel: courseModel,
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        if (mounted) {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CourseDetail(
                                                cm: courseModel,
                                                keey: null,
                                                val: null,
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Align(
                              child: Icon(
                                Icons.check_circle_outline,
                                color: cardColor,
                                size: 51,
                              ),
                            ),
                          )
                        : null,
              ),
              Positioned(
                  top: 29,
                  left: 2,
                  child: widget.courseModel.isStarted == 1 &&
                          widget.courseModel.isScheduleOn == 1
                      ? Icon(
                          Icons.notifications_active,
                          color: whiteColor,
                          size: 20,
                        )
                      : const SizedBox()),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.courseModel.ustaz
                                  .replaceAll("ኡስታዝ", "ኡ")
                                  .replaceAll("ሸይኽ", "ሸ"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: whiteColor,
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     const Icon(
                            //       Icons.music_note_rounded,
                            //       color: whiteColor,
                            //       size: 19,
                            //     ),
                            //     Text(
                            //       "${widget.courseModel.noOfRecord}",
                            //       style: const TextStyle(
                            //         color: whiteColor,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned.fill(
              // child:
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  width: 100,
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    widget.courseModel.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              // )
            ],
          ),
        ),
        // const SizedBox(
        //   height: 2,
        // ),
        // Text(
        //   widget.courseModel.title,
        //   overflow: TextOverflow.ellipsis,
        // ),
        //   ]
        // )
      ),
    );
  }
}
