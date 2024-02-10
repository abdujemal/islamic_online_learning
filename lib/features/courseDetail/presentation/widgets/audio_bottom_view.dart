import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/position_data_model.dart';
import '../../../main/data/model/course_model.dart';
import '../stateNotifier/providers.dart';
import 'package:rxdart/rxdart.dart';

import 'finish_confirmation.dart';

class AudioBottomView extends ConsumerStatefulWidget {
  final String courseId;
  final VoidCallback onClose;
  const AudioBottomView(this.courseId, this.onClose, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AudioBottomViewState();
}

class _AudioBottomViewState extends ConsumerState<AudioBottomView> {
  bool isLoading = false;

  Future<bool> isDownloaded(String title, String ustaz) {
    return ref
        .read(cdNotifierProvider.notifier)
        .isDownloaded("$ustaz,$title.mp3", "Audio", context);
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);

    return StreamBuilder(
        stream: myAudioStream(audioPlayer),
        builder: (context, snp) {
          final state = snp.data?.sequenceState;
          if (kDebugMode) {
            print("wooooooooooooo");
          }
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }

          final metaData = state!.currentSource!.tag as MediaItem;

          if ("${metaData.extras?["courseId"]}" != widget.courseId) {
            return const SizedBox();
          }
          final process = snp.data?.processingState;
          if (process == ProcessingState.idle) {
            return const SizedBox();
          }

          // if (process == ProcessingState.completed) {
          //   if (!audioPlayer.hasNext) {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (ctx) => FinishConfirmation(
          //         title: metaData.title
          //             .split(" ")
          //             .sublist(
          //               0,
          //               metaData.title.split(" ").length - 2,
          //             )
          //             .join(" "),
          //         onConfirm: () {
          //           ref.read(mainNotifierProvider.notifier).saveCourse(
          //                 CourseModel.fromMap(
          //                   metaData.extras as Map,
          //                   metaData.extras?["courseId"],
          //                 ).copyWith(
          //                   isStarted: 1,
          //                   isFinished: 1,
          //                   pausedAtAudioNum: audioPlayer.currentIndex,
          //                   pausedAtAudioSec: audioPlayer.position.inSeconds,
          //                   lastViewed: DateTime.now().toString(),
          //                 ),
          //                 null,
          //                 context,
          //                 showMsg: false,
          //               );
          //           Navigator.pop(context);
          //         },
          //         onDenied: () {
          //           ref.read(mainNotifierProvider.notifier).saveCourse(
          //                 CourseModel.fromMap(
          //                   metaData.extras as Map,
          //                   metaData.extras?["courseId"],
          //                 ).copyWith(
          //                   isStarted: 1,
          //                   pausedAtAudioNum: audioPlayer.currentIndex,
          //                   pausedAtAudioSec: audioPlayer.position.inSeconds,
          //                   lastViewed: DateTime.now().toString(),
          //                 ),
          //                 null,
          //                 context,
          //                 showMsg: false,
          //               );
          //           Navigator.pop(context);
          //         },
          //       ),
          //     );
          //     ref.read(audioProvider).stop();
          //   }
          // }
          return Container(
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  offset: const Offset(0, -3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextScroll(
                          pauseBetween: const Duration(seconds: 1),
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(30, 0)),
                          metaData.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (process == ProcessingState.buffering ||
                          process == ProcessingState.loading)
                        SizedBox(
                          width: 90,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor:
                                  Theme.of(context).chipTheme.backgroundColor!,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () async {
                          widget.onClose();

                          if (metaData.extras?["isFinished"] == 0) {
                            if (!audioPlayer.hasNext &&
                                process == ProcessingState.completed) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => FinishConfirmation(
                                  title: metaData.title
                                      .split(" ")
                                      .sublist(
                                        0,
                                        metaData.title.split(" ").length - 2,
                                      )
                                      .join(" "),
                                  onConfirm: () {
                                    ref
                                        .read(mainNotifierProvider.notifier)
                                        .saveCourse(
                                          CourseModel.fromMap(
                                            metaData.extras as Map,
                                            metaData.extras?["courseId"],
                                          ).copyWith(
                                            isStarted: 1,
                                            isFinished: 1,
                                            pausedAtAudioNum:
                                                audioPlayer.currentIndex,
                                            pausedAtAudioSec:
                                                audioPlayer.position.inSeconds,
                                            lastViewed:
                                                DateTime.now().toString(),
                                          ),
                                          null,
                                          context,
                                          showMsg: false,
                                        );
                                    Navigator.pop(context);
                                  },
                                  onDenied: () {
                                    ref
                                        .read(mainNotifierProvider.notifier)
                                        .saveCourse(
                                          CourseModel.fromMap(
                                            metaData.extras as Map,
                                            metaData.extras?["courseId"],
                                          ).copyWith(
                                            isStarted: 1,
                                            pausedAtAudioNum:
                                                audioPlayer.currentIndex,
                                            pausedAtAudioSec:
                                                audioPlayer.position.inSeconds,
                                            lastViewed:
                                                DateTime.now().toString(),
                                          ),
                                          null,
                                          context,
                                          showMsg: false,
                                        );
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                              ref.read(audioProvider).stop();
                            } else {
                              ref
                                  .read(mainNotifierProvider.notifier)
                                  .saveCourse(
                                    CourseModel.fromMap(
                                      metaData.extras as Map,
                                      metaData.extras?["courseId"],
                                    ).copyWith(
                                      isStarted: 1,
                                      pausedAtAudioNum:
                                          audioPlayer.currentIndex,
                                      pausedAtAudioSec:
                                          audioPlayer.position.inSeconds,
                                      lastViewed: DateTime.now().toString(),
                                    ),
                                    null,
                                    context,
                                    showMsg: false,
                                  )
                                  .then((value) {
                                ref
                                    .read(mainNotifierProvider.notifier)
                                    .getSingleCourse(
                                        metaData.extras?["courseId"], context)
                                    .then((value) {
                                  ref.read(audioProvider).stop();
                                });
                              }).catchError((e) {
                                if (kDebugMode) {
                                  print("$e");
                                }
                              });
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: Rx.combineLatest3<Duration, Duration, Duration?,
                        PositionData>(
                      audioPlayer.positionStream,
                      audioPlayer.bufferedPositionStream,
                      audioPlayer.durationStream,
                      (position, bufferedDuration, duration) => PositionData(
                        position: position,
                        bufferedDuration: bufferedDuration,
                        duration: duration ?? Duration.zero,
                      ),
                    ),
                    builder: (context, snap) {
                      final positionData = snap.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ProgressBar(
                          barHeight: 8,
                          baseBarColor:
                              Theme.of(context).chipTheme.backgroundColor,
                          thumbRadius: 8,
                          timeLabelPadding: 5,
                          progressBarColor: primaryColor,
                          thumbColor: primaryColor,
                          progress: positionData?.position ?? Duration.zero,
                          total: positionData?.duration ?? Duration.zero,
                          buffered:
                              positionData?.bufferedDuration ?? Duration.zero,
                          onSeek: audioPlayer.seek,
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (audioPlayer.position.inSeconds <= 10) {
                            audioPlayer.seek(Duration.zero);
                            return;
                          }
                          audioPlayer.seek(
                            Duration(
                              seconds: audioPlayer.position.inSeconds - 10,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.replay_10_rounded,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          ref.read(audioProvider).seekToPrevious();
                        },
                        icon: const Icon(Icons.skip_previous_rounded, size: 40),
                      ),
                      StreamBuilder(
                          stream: audioPlayer.playingStream,
                          builder: (context, snap) {
                            return IconButton(
                              icon: snap.data == true
                                  ? const Icon(Icons.pause_rounded, size: 40)
                                  : const Icon(Icons.play_arrow_rounded,
                                      size: 40),
                              onPressed: () async {
                                if (audioPlayer.playing) {
                                  widget.onClose();
                                  if (metaData.extras?["isFinished"] == 0) {
                                    await ref
                                        .read(mainNotifierProvider.notifier)
                                        .saveCourse(
                                          CourseModel.fromMap(
                                            metaData.extras as Map,
                                            metaData.extras?["courseId"],
                                          ).copyWith(
                                            isStarted: 1,
                                            pausedAtAudioNum:
                                                audioPlayer.currentIndex,
                                            pausedAtAudioSec:
                                                audioPlayer.position.inSeconds,
                                            lastViewed:
                                                DateTime.now().toString(),
                                          ),
                                          null,
                                          context,
                                          showMsg: false,
                                        );
                                  }
                                  ref.read(audioProvider).pause();
                                  setState(() {});
                                  return;
                                } else {
                                  ref.read(audioProvider).play();
                                  setState(() {});
                                  return;
                                }
                              },
                            );
                          }),
                      IconButton(
                        onPressed: () async {
                          ref.read(audioProvider).seekToNext();
                        },
                        icon: const Icon(Icons.skip_next_rounded, size: 40),
                      ),
                      IconButton(
                        onPressed: () {
                          if (audioPlayer.duration == null) {
                            return;
                          }
                          if (audioPlayer.position.inSeconds >=
                              audioPlayer.duration!.inSeconds - 10) {
                            audioPlayer.seek(
                              Duration(
                                seconds: audioPlayer.duration!.inSeconds,
                              ),
                            );
                            return;
                          }
                          audioPlayer.seek(
                            Duration(
                              seconds: audioPlayer.position.inSeconds + 10,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.forward_10_rounded,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
