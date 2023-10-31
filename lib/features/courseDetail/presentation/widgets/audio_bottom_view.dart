import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/audio_model.dart';
import '../../../../core/Audio Feature/audio_providers.dart';
import '../stateNotifier/providers.dart';

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

    Duration position = ref.watch(audioPlayerPositionProvider);
    Duration duration = ref.watch(audioPlayerDurationProvider);

    return currentAudio != null && currentCourse != null
        ? Container(
            height: 125,
            color: Colors.black12,
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
                      Text(
                        currentAudio.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (isLoading)
                        const SizedBox(
                          width: 130,
                          child: LinearProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                    ],
                  ),
                ),
                duration != Duration.zero
                    ? Slider(
                        activeColor: primaryColor,
                        value: position.inMilliseconds /
                                    duration.inMilliseconds <=
                                1
                            ? position.inMilliseconds / duration.inMilliseconds
                            : 1,
                        onChanged: (v) {
                          final position = v * duration.inMilliseconds;
                          ref
                              .read(audioProvider)
                              .seek(Duration(milliseconds: position.round()));
                        },
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(position.toString().split('.').first),
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
                            print("url is null");
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.fast_rewind),
                      ),
                      IconButton(
                        icon: currentAudio.audioState.isPlaying()
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
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
                            ref.read(audioProvider).resume();
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
                            print("url is null");
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
                            print("url is null");
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.fast_forward),
                      ),
                      Text(duration.toString().split('.').first),
                    ],
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}
