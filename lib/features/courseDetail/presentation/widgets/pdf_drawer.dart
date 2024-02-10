// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/constants.dart';
import '../../../main/data/model/course_model.dart';
import 'audio_item.dart';

class PdfDrawer extends ConsumerStatefulWidget {
  final List<String> audios;
  final String title;
  final CourseModel courseModel;
  const PdfDrawer({
    super.key,
    required this.audios,
    required this.title,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfDrawerState();
}

class _PdfDrawerState extends ConsumerState<PdfDrawer> {
  late ConcatenatingAudioSource playList;

  late CourseModel courseModel;

  bool isLoadingAudio = false;

  late StreamSubscription<ConnectivityResult> connectionListner;

  bool isConnected = true;

  @override
  initState() {
    super.initState();

    if (mounted) {
      createPlayList();
    }

    courseModel = widget.courseModel;

    createPlayList();
  }

  Future<void> createPlayList() async {
    isLoadingAudio = true;
    if (mounted) {
      setState(() {});
    }

    Directory dir = await getApplicationSupportDirectory();

    int i = 0;
    List<AudioSource> lst = [];
    ref.read(loadAudiosProvider.notifier).update((state) => 0);
    for (String id in widget.audios) {
      i++;
      if (await checkFile(i)) {
        String fileName = "${courseModel.ustaz},${courseModel.title} $i.mp3";

        ref.read(loadAudiosProvider.notifier).update((state) => state + 1);

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
      } else {
        if (mounted) {
          final url = await ref
              .read(cdNotifierProvider.notifier)
              .loadFileOnline(id, true, context, showError: false);
          if (url != null) {
            ref.read(loadAudiosProvider.notifier).update((state) => state + 1);

            lst.add(
              AudioSource.uri(
                Uri.parse(
                  url,
                ),
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
      }
    }
    playList = ConcatenatingAudioSource(children: lst);
    isLoadingAudio = false;
    if (mounted) {
      setState(() {});
    }
    if (kDebugMode) {
      print("playlist itams: ${playList.length}");
    }
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
    final audioPlayer = ref.watch(audioProvider);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 10,
              right: 5,
              left: 5,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              children: [
                Spacer(),
                Text(
                  "የ${widget.title} ድምጾች",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: myAudioStream(audioPlayer),
                builder: (context, snap) {
                  final state = snap.data?.sequenceState;
                  final processState = snap.data?.processingState;

                  final mediaItem = state!.currentSource!.tag as MediaItem;

                  return ListView.builder(
                      itemCount: widget.audios.length,
                      itemBuilder: (context, index) {
                        if (state.sequence.isNotEmpty) {
                          return AudioItem(
                            isPlaying: mediaItem.id == widget.audios[index],
                            canAudioPlay: true,
                            canNeverPlay: false,
                            audioId: widget.audios[index],
                            title: courseModel.title,
                            index: index + 1,
                            courseModel: courseModel,
                            isFromPDF: false,
                            onDownloadDone: (String filePath) async {
                              // Directory dir =
                              //     await getApplicationSupportDirectory();

                              if (playList.children.isEmpty ||
                                  index >= widget.audios.length) {
                                createPlayList();
                                return;
                              }

                              // if (isPlayingCourseThisCourse(
                              //   courseModel.courseId,
                              //   ref,
                              //   alsoIsNotIdle: true,
                              // )) {
                              playList.removeAt(index - 1);
                              playList.insert(
                                index - 1,
                                AudioSource.file(
                                  filePath,
                                  tag: MediaItem(
                                    id: widget.audios[index - 1],
                                    title: "${courseModel.title} $index",
                                    artist: courseModel.ustaz,
                                    album: courseModel.category,
                                    artUri: Uri.parse(courseModel.image),
                                    extras: courseModel.toMap(),
                                  ),
                                ),
                              );

                              // if (isPlayingCourseThisCourse(
                              //   courseModel.courseId,
                              //   ref,
                              //   alsoIsNotIdle: true,
                              // )) {
                              //   ref.read(audioProvider).setAudioSource(

                              //           playList,

                              //         initialIndex:
                              //             ref.read(audioProvider).currentIndex,
                              //         initialPosition:
                              //             ref.read(audioProvider).position,
                              //         preload: false,
                              //       );

                              //   ref.read(audioProvider).play();
                              // }
                              // }
                            },
                            onPlayTabed: () async {
                              // updating the model if the currently playing course is this course
                              if (isPlayingCourseThisCourse(
                                      courseModel.courseId, ref) &&
                                  processState != ProcessingState.idle) {
                                print("clicked");
                                courseModel = courseModel.copyWith(
                                  isStarted: 1,
                                  pausedAtAudioNum: audioPlayer.currentIndex,
                                  pausedAtAudioSec:
                                      audioPlayer.position.inSeconds,
                                  lastViewed: DateTime.now().toString(),
                                );
                                setState(() {});
                                int destinationIndex = index - 1;
                                int currentIndex =
                                    audioPlayer.currentIndex ?? 0;

                                int dnc =
                                    (destinationIndex - currentIndex).abs();

                                for (int i = 0; i < dnc; i++) {
                                  print("it works");
                                  await Future.delayed(
                                      const Duration(milliseconds: 50));
                                  if (destinationIndex > currentIndex) {
                                    print(">");
                                    ref.read(audioProvider).seekToNext();
                                  } else {
                                    print("<");
                                    ref.read(audioProvider).seekToPrevious();
                                  }
                                }
                              } else {
                                ref.read(audioProvider).setAudioSource(
                                      playList,
                                      initialIndex: index - 1,
                                      // preload: false,
                                    );
                                try {
                                  await ref.read(audioProvider).play();
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e.toString());
                                  }
                                  await ref.read(audioProvider).stop();
                                }
                              }
                            },
                          );
                        }
                        return AudioItem(
                          isPlaying: false,
                          canAudioPlay: true,
                          canNeverPlay: false,
                          audioId: widget.audios[index],
                          title: courseModel.title,
                          index: index,
                          courseModel: courseModel,
                          isFromPDF: false,
                          onDownloadDone: (String filePath) async {
                            // Directory dir =
                            //     await getApplicationSupportDirectory();

                            if (playList.children.isEmpty ||
                                index >= widget.audios.length) {
                              createPlayList();
                              return;
                            }

                            // if (isPlayingCourseThisCourse(
                            //   courseModel.courseId,
                            //   ref,
                            //   alsoIsNotIdle: true,
                            // )) {
                            playList.removeAt(index - 1);
                            playList.insert(
                              index - 1,
                              AudioSource.file(
                                filePath,
                                tag: MediaItem(
                                  id: widget.audios[index - 1],
                                  title: "${courseModel.title} $index",
                                  artist: courseModel.ustaz,
                                  album: courseModel.category,
                                  artUri: Uri.parse(courseModel.image),
                                  extras: courseModel.toMap(),
                                ),
                              ),
                            );
                            // }
                          },
                          onPlayTabed: () {
                            if (isPlayingCourseThisCourse(
                                courseModel.courseId, ref)) {
                              courseModel = courseModel.copyWith(
                                isStarted: 1,
                                pausedAtAudioNum: audioPlayer.currentIndex,
                                pausedAtAudioSec:
                                    audioPlayer.position.inSeconds,
                                lastViewed: DateTime.now().toString(),
                              );
                              setState(() {});
                            }
                            ref.read(audioProvider).setAudioSource(
                                  playList,
                                  initialIndex: index,
                                );
                            ref.read(audioProvider).play();
                          },
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
