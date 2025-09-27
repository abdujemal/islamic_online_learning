// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/download_icon.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

import '../../../../core/Audio Feature/playlist_helper.dart';
import '../../../main/presentation/state/provider.dart';
import '../../data/course_detail_data_src.dart';
import 'delete_confirmation.dart';

class AudioItem extends ConsumerStatefulWidget {
  final String audioId;
  final String title;
  final int index;
  final CourseModel courseModel;
  final bool isFromPDF;
  final void Function(String filePath) onDownloadDone;
  final VoidCallback onPlayTabed;
  final VoidCallback onDeleteBtn;
  final bool isPlaying;
  final bool canAudioPlay;
  final bool canNeverPlay;
  const AudioItem({
    super.key,
    required this.audioId,
    required this.title,
    required this.index,
    required this.courseModel,
    required this.isFromPDF,
    required this.onDownloadDone,
    required this.onPlayTabed,
    required this.isPlaying,
    required this.canAudioPlay,
    required this.canNeverPlay,
    required this.onDeleteBtn,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioItemState();
}

class _AudioItemState extends ConsumerState<AudioItem> {
  bool isLoading = false;
  // bool isDownloaded = false;
  bool isDownloading = false;

  String? audioPath;

  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    // print("${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3");

    getPath('Audio',
            "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3")
        .then((value) {
      audioPath = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<bool> checkFile() async {
    if (mounted) {
      final isDownloaded = await ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded(
              "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3",
              "Audio",
              context);
      return isDownloaded;
    }
    return false;
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    // AudioState myState = ref.watch(checkAudioModelProvider
    //     .call("${widget.courseModel.ustaz},${widget.title} ${widget.index}"));

    final downLoadProg =
        ref.watch(downloadProgressCheckernProvider.call(audioPath));

    final audioPlayer = PlaylistHelper.audioPlayer;
    // checkFile();

    return FutureBuilder(
        future: checkFile(),
        builder: (context, snap) {
          bool isDownloaded = snap.data ?? false;
          return StreamBuilder(
              stream: audioPlayer.playingStream,
              builder: (context, snap) {
                return Container(
                  decoration: BoxDecoration(
                    color: widget.isPlaying
                        ? Theme.of(context).chipTheme.backgroundColor!
                        : null,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).chipTheme.backgroundColor!,
                      ),
                    ),
                  ),
                  child: ListTile(
                    trailing: isDownloaded &&
                            downLoadProg?.filePath != audioPath
                        ? IconButton(
                            onPressed: () async {
                              if (widget.isPlaying) {
                                return;
                              }
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => DeleteConfirmation(
                                  title: '${widget.title} ${widget.index}.mp3',
                                  action: () async {
                                    await ref
                                        .read(cdNotifierProvider.notifier)
                                        .deleteFile(
                                            '${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3',
                                            "Audio",
                                            context);

                                    isDownloaded = await checkFile();
                                    widget.onDeleteBtn();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                            ),
                          )
                        : downLoadProg != null
                            ? Text(
                                "${downLoadProg.progress.toStringAsFixed(1)}%",
                              )
                            : Text(
                                formatFileSize(
                                  int.parse(
                                    widget.courseModel.audioSizes
                                        .split(",")[widget.index - 1],
                                  ),
                                ),
                              ),
                    leading: GestureDetector(
                      onTap: () async {
                        if (isDownloading ||
                            downLoadProg?.filePath == audioPath &&
                                downLoadProg != null &&
                                downLoadProg.progress < 100)
                        // if (downLoadProg?.filePath ==
                        //     "Audio/${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3")
                        {
                          return;
                        }
                        if (isLoading) {
                          return;
                        }
                        if (widget.canNeverPlay) {
                          toast(
                              "እባክዎ ኢንተርኔትዎን ያብሩ!", ToastType.normal, context);
                          return;
                        }
                        if (!widget.canAudioPlay) {
                          toast("እባክዎ ትንሽ ይጠብቁ...", ToastType.normal, context);
                          return;
                        }

                        if (snap.data == true && widget.isPlaying) {
                          PlaylistHelper.audioPlayer.pause();

                          return;
                        }
                        if (snap.data != true && widget.isPlaying) {
                          PlaylistHelper.audioPlayer.play();

                          return;
                        }
                        final metaData =
                            audioPlayer.sequenceState.currentSource?.tag;
                        if (metaData != null) {
                          if ((metaData as MediaItem).extras?["isFinished"] ==
                              0) {
                            if (!audioPlayer.hasNext &&
                                audioPlayer.processingState ==
                                    ProcessingState.completed) {
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (ctx) => FinishConfirmation(
                              //     title: widget.courseModel.title,
                              //     onConfirm: () {
                              //       ref
                              //           .read(mainNotifierProvider.notifier)
                              //           .saveCourse(
                              //             widget.courseModel.copyWith(
                              //               isStarted: 1,
                              //               isFinished: 1,
                              //               lastViewed:
                              //                   DateTime.now().toString(),
                              //               pausedAtAudioNum: widget
                              //                       .courseModel.courseIds
                              //                       .split(",")
                              //                       .length -
                              //                   1,
                              //             ),
                              //             null,
                              //             context,
                              //             showMsg: false,
                              //           );
                              //       Navigator.pop(context);
                              //     },
                              //     onDenied: () {
                              //       ref
                              //           .read(mainNotifierProvider.notifier)
                              //           .saveCourse(
                              //             widget.courseModel.copyWith(
                              //               isStarted: 1,
                              //               lastViewed:
                              //                   DateTime.now().toString(),
                              //               pausedAtAudioNum: widget
                              //                       .courseModel.courseIds
                              //                       .split(",")
                              //                       .length -
                              //                   1,
                              //             ),
                              //             null,
                              //             context,
                              //             showMsg: false,
                              //           );
                              //       Navigator.pop(context);
                              //     },
                              //   ),
                              // );
                            } else {
                              int id = int.parse(metaData.title
                                      .split(" ")
                                      .last
                                      .replaceAll(".mp3", "")) -
                                  1;
                              await ref
                                  .read(mainNotifierProvider.notifier)
                                  .saveCourse(
                                    CourseModel.fromMap(
                                      metaData.extras as Map,
                                      metaData.extras?["courseId"],
                                    ).copyWith(
                                      isStarted: 1,
                                      pausedAtAudioNum: id,
                                      pausedAtAudioSec:
                                          audioPlayer.position.inSeconds,
                                      lastViewed: DateTime.now().toString(),
                                    ),
                                    null,
                                    context,
                                    showMsg: false,
                                  );
                            }
                          }
                          if (kDebugMode) {
                            print(metaData.extras?["courseId"]);
                          }
                        }
                        isDownloaded = await checkFile();
                        if (!isDownloaded) {
                          if (mounted) {
                            isDownloading = true;
                            final file = await ref
                                .read(cdNotifierProvider.notifier)
                                .downloadFile(
                                  widget.audioId,
                                  "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3",
                                  'Audio',
                                  cancelToken,
                                  context,
                                );
                            isDownloading = false;
                            if (file != null) {
                              isDownloaded = await checkFile();
                              widget.onDownloadDone(file.path);
                              if (mounted) {
                                setState(() {});
                              }
                            } else {
                              print("file is null idk why");
                              return;
                            }
                          }
                        }
                        widget.onPlayTabed();
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            width: 45,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                    ),
                                  )
                                : audioPlayer.playing && widget.isPlaying
                                    ? const Icon(
                                        Icons.pause_rounded,
                                        size: 35,
                                        color: whiteColor,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 35,
                                        color: whiteColor,
                                      ),
                          ),
                          !isDownloaded || downLoadProg?.filePath == audioPath
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: DownloadIcon(
                                    onTap: () async {
                                      if (downLoadProg?.filePath == audioPath) {
                                        downLoadProg!.cancelToken.cancel();
                                        cancelToken = CancelToken();
                                        return;
                                      }
                                      isDownloading = true;
                                      File? file = await ref
                                          .read(cdNotifierProvider.notifier)
                                          .downloadFile(
                                            widget.audioId,
                                            "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3",
                                            'Audio',
                                            cancelToken,
                                            context,
                                          );
                                      isDownloading = false;
                                      if (file != null) {
                                        isDownloaded = await checkFile();
                                        widget.onDownloadDone(file.path);
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      }
                                    },
                                    isLoading: isDownloading ||
                                        downLoadProg?.filePath == audioPath &&
                                            downLoadProg != null &&
                                            downLoadProg.progress < 100,
                                    progress: downLoadProg != null
                                        ? downLoadProg.progress
                                        : 0,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    title: Row(
                      children: [
                        if (!widget.isFromPDF)
                          Expanded(
                            child: Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Expanded(child: Text("${widget.index}"))
                      ],
                    ),
                    subtitle: Text(
                      widget.courseModel.ustaz,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              });
        });
  }
}
