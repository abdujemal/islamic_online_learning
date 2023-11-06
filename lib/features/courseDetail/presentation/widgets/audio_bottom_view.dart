import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/audio_model.dart';
import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/position_data_model.dart';
import '../stateNotifier/providers.dart';
import 'package:rxdart/rxdart.dart';

class AudioBottomView extends ConsumerStatefulWidget {
  final String courseId;
  const AudioBottomView(this.courseId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AudioBottomViewState();
}

class _AudioBottomViewState extends ConsumerState<AudioBottomView> {
  bool isLoading = false;

  Future<bool> isDownloaded(String title, String ustaz) {
    return ref
        .read(cdNotifierProvider.notifier)
        .isDownloaded("$ustaz,$title.mp3", "Audio");
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    final currentCourse = ref.watch(checkCourseProvider.call(widget.courseId));
    final audioPlayer = ref.watch(audioProvider);

    return currentAudio != null && currentCourse != null
        ? Container(
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
                        child: Text(
                          currentAudio.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (isLoading)
                        const SizedBox(
                          width: 130,
                          child: LinearProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          ref.read(audioProvider).stop();
                          ref
                              .read(currentAudioProvider.notifier)
                              .update((state) => null);
                          // ref.read(endListnersProvider);
                        },
                        child: const Icon(Icons.close_rounded),
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
                      const Text(""),
                      IconButton(
                        onPressed: () async {
                          final beforIndex =
                              int.parse(currentAudio.title.split(" ").last) - 1;

                          final audioIds = currentCourse.courseIds.split(",");

                          final onlyTitle = currentAudio.title
                              .split(" ")
                              .sublist(
                                  0, currentAudio.title.split(" ").length - 1)
                              .join(" ");

                          if (beforIndex < 1) {
                            return;
                          }

                          if (await isDownloaded(
                              "$onlyTitle $beforIndex", currentCourse.ustaz)) {
                            final audioPath = await getPath('Audio',
                                "${currentCourse.ustaz},$onlyTitle $beforIndex.mp3");

                            ref.read(cdNotifierProvider.notifier).playOffline(
                                  audioPath,
                                  "$onlyTitle $beforIndex",
                                  currentCourse,
                                  audioIds[beforIndex - 1],
                                );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });
                          String? url = await ref
                              .read(cdNotifierProvider.notifier)
                              .loadFileOnline(audioIds[beforIndex - 1]);
                          if (url != null) {
                            ref.read(cdNotifierProvider.notifier).playOnline(
                                  url,
                                  "$onlyTitle $beforIndex",
                                  currentCourse,
                                  audioIds[beforIndex - 1],
                                );
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.skip_previous_rounded),
                      ),
                      IconButton(
                        icon: currentAudio.audioState.isPlaying()
                            ? const Icon(Icons.pause_rounded)
                            : const Icon(Icons.play_arrow_rounded),
                        onPressed: () async {
                          ref.read(currentAudioProvider.notifier).update(
                                (state) => state!.copyWith(
                                  audioState:
                                      currentAudio.audioState.isPlaused()
                                          ? AudioState.playing
                                          : AudioState.paused,
                                ),
                              );
                          if (currentAudio.audioState.isPlaused()) {
                            ref.read(audioProvider).play();
                            return;
                          } else if (currentAudio.audioState.isPlaying()) {
                            ref.read(audioProvider).pause();
                            return;
                          }

                          if (await isDownloaded(
                              currentAudio.title, currentCourse.ustaz)) {
                            final audioPath = await getPath('Audio',
                                "${currentCourse.ustaz},${currentAudio.title}.mp3");

                            ref.read(cdNotifierProvider.notifier).playOffline(
                                  audioPath,
                                  currentAudio.title,
                                  currentCourse,
                                  currentAudio.audioId,
                                );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });
                          String? url = await ref
                              .read(cdNotifierProvider.notifier)
                              .loadFileOnline(currentAudio.audioId);
                          if (url != null) {
                            ref.read(cdNotifierProvider.notifier).playOnline(
                                  url,
                                  currentAudio.title,
                                  currentCourse,
                                  currentAudio.audioId,
                                );
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      IconButton(
                        onPressed: () async {
                          final afterIndex =
                              int.parse(currentAudio.title.split(" ").last) + 1;

                          final audioIds = currentCourse.courseIds.split(",");

                          final onlyTitle = currentAudio.title
                              .split(" ")
                              .sublist(
                                  0, currentAudio.title.split(" ").length - 1)
                              .join(" ");

                          if (afterIndex > audioIds.length) {
                            return;
                          }

                          if (await isDownloaded(
                              "$onlyTitle $afterIndex", currentCourse.ustaz)) {
                            final audioPath = await getPath('Audio',
                                "${currentCourse.ustaz},$onlyTitle $afterIndex.mp3");

                            ref.read(cdNotifierProvider.notifier).playOffline(
                                  audioPath,
                                  "$onlyTitle $afterIndex",
                                  currentCourse,
                                  audioIds[afterIndex - 1],
                                );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });
                          String? url = await ref
                              .read(cdNotifierProvider.notifier)
                              .loadFileOnline(audioIds[afterIndex - 1]);
                          if (url != null) {
                            await ref
                                .read(cdNotifierProvider.notifier)
                                .playOnline(
                                  url,
                                  "$onlyTitle $afterIndex",
                                  currentCourse,
                                  audioIds[afterIndex - 1],
                                );
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.skip_next_rounded),
                      ),
                      Text(''.toString().split('.').first),
                    ],
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}
