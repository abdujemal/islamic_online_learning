// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
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
              .loadFileOnline(id, true, context, showError: false);
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
      final isDownloaded = await ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded(
              "${widget.courseModel.ustaz},${widget.courseModel.title} $index.mp3",
              "Audio",
              context);
      return isDownloaded;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    percentage = getPersentage(widget.courseModel);

    return FutureBuilder(
      future: displayImage(
        widget.courseModel.image,
        widget.courseModel.category == "ተፍሲር"
            ? "ተፍሲር"
            : widget.courseModel.title,
        ref,
      ),
      builder: (context, snap) {
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
                      image: snap.data != null && snap.data!.path != ""
                          ? DecorationImage(
                              image: FileImage(snap.data!),
                              fit: BoxFit.fill,
                            )
                          : null,
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
                                      if (playList.isNotEmpty) {
                                        await ref
                                            .read(audioProvider)
                                            .setAudioSource(
                                              ConcatenatingAudioSource(
                                                children: playList,
                                              ),
                                              initialIndex: widget.courseModel
                                                          .pausedAtAudioNum <
                                                      0
                                                  ? 0
                                                  : widget.courseModel
                                                      .pausedAtAudioNum,
                                              initialPosition: Duration(
                                                seconds: widget.courseModel
                                                    .pausedAtAudioSec,
                                              ),
                                            );
                                        ref.read(audioProvider).play();
                                        if (mounted) {
                                          bool isPDFDownloded = await ref
                                              .read(cdNotifierProvider.notifier)
                                              .isDownloaded(
                                                widget.courseModel.pdfId
                                                        .contains(",")
                                                    ? "${widget.courseModel.title} ${widget.courseModel.pdfNum.toInt()}.pdf"
                                                    : "${widget.courseModel.title}.pdf",
                                                "PDF",
                                                context,
                                              );
                                          if (widget.courseModel.pdfId
                                                  .trim()
                                                  .isNotEmpty &&
                                              isPDFDownloded) {
                                            String path = await getPath(
                                              'PDF',
                                              widget.courseModel.pdfId
                                                      .contains(",")
                                                  ? "${widget.courseModel.title} ${widget.courseModel.pdfNum.toInt()}.pdf"
                                                  : "${widget.courseModel.title}.pdf",
                                            );
                                            if (mounted) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => PdfPage(
                                                    volume: widget
                                                        .courseModel.pdfNum,
                                                    path: path,
                                                    courseModel:
                                                        widget.courseModel,
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            if (mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => CourseDetail(
                                                    cm: widget.courseModel,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                        // if (mounted) {
                                        //   bool isPDFDownloded = await ref
                                        //       .read(cdNotifierProvider.notifier)
                                        //       .isDownloaded(
                                        //           "${widget.courseModel.title}.pdf",
                                        //           "PDF",
                                        //           context);
                                        //   if (widget.courseModel.pdfId
                                        //           .trim()
                                        //           .isEmpty ||
                                        //       !isPDFDownloded) {
                                        //     if (mounted) {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (_) => CourseDetail(
                                        //         cm: widget.courseModel,
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                        //   } else {
                                        //     String path = await getPath('PDF',
                                        //         "${widget.courseModel.title}.pdf");
                                        //     if (mounted) {
                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //           builder: (_) => PdfPage(
                                        //             volume: widget
                                        //                 .courseModel.pdfNum,
                                        //             path: path,
                                        //             courseModel:
                                        //                 widget.courseModel,
                                        //           ),
                                        //         ),
                                        //       );
                                        //     }
                                        //   }
                                        // }
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
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                        child: widget.courseModel.isStarted == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
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
                                    "${widget.courseModel.noOfRecord}",
                                    style: const TextStyle(
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
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
                        widget.courseModel.ustaz,
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
      },
    );
  }
}
