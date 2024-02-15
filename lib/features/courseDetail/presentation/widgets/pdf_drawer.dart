// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/download_all_files.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
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
  late CourseModel courseModel;

  bool isLoadingAudio = false;

  List<AudioSource> lst = [];

  late StreamSubscription<ConnectivityResult> connectionListner;

  bool isConnected = true;

  List<int> playListIndexes = [];

  @override
  initState() {
    super.initState();

    if (mounted) {
      createPlayList();
    }

    courseModel = widget.courseModel;
  }

  Future<void> createPlayList() async {
    isLoadingAudio = true;
    if (mounted) {
      setState(() {});
    }

    Directory dir = await getApplicationSupportDirectory();

    int i = 0;
    lst = [];
    playListIndexes = [];
    ref.read(loadAudiosProvider.notifier).update((state) => 0);
    for (String id in widget.audios) {
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
      // int prevLen = PlaylistHelper().playList?.length ?? 0;
      // PlaylistHelper().playList?.addAll(lst);
      // PlaylistHelper().playList?.removeRange(0, prevLen - 1);
      // ref.read(playlistProvider).addAll(lst);
    } else {
      print("playlist adding");

      // myPlaylist = ConcatenatingAudioSource(children: lst);
    }
    isLoadingAudio = false;
    if (mounted) {
      setState(() {});
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
    final playList =
        PlaylistHelper().playList ?? ConcatenatingAudioSource(children: []);
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
                  onPressed: () {
                    ref.read(mainNotifierProvider.notifier).saveCourse(
                          courseModel.copyWith(
                            isStarted: 1,
                          ),
                          null,
                          context,
                          showMsg: false,
                        );
                    courseModel = courseModel.copyWith(
                      isStarted: 1,
                    );
                    setState(() {});

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => DownloadAllFiles(
                        courseModel: courseModel,
                        onSingleDownloadDone: (filePath) async {
                          if (kDebugMode) {
                            print("Dwonload done $filePath");
                          }
                          int index = int.parse(
                              filePath.replaceAll(".mp3", "").split(" ").last);

                          playListIndexes.add(index);
                          playListIndexes.sort((a, b) => a.compareTo(b));
                          print("indexes: ${playListIndexes}");
                          if (mounted) {
                            ref
                                .read(loadAudiosProvider.notifier)
                                .update((state) => playListIndexes.length);
                          }
                          print("index : $index");
                          int insertableIndex = playListIndexes.indexOf(index);

                          print("inserting at $insertableIndex");
                          print('playlistNum: ${playList.children.length}');

                          if (insertableIndex >= playList.children.length) {
                            print("adding at $insertableIndex");
                            playList.add(
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
                          } else {
                            print("inserting at $insertableIndex");

                            playList.insert(
                              insertableIndex,
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
                          }
                          print("num of index: ${playList.length}");
                        },
                      ),
                    );
                  },
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

                  // if (state == null) {
                  //   return const SizedBox();
                  // }

                  dynamic mediaItem = state?.currentSource?.tag;

                  if (mediaItem != null) {
                    mediaItem = state?.currentSource?.tag as MediaItem;
                  }

                  return ListView.builder(
                      itemCount: widget.audios.length,
                      itemBuilder: (context, index) {
                        if (state?.sequence.isNotEmpty ?? false) {
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
                              playListIndexes.add(index + 1);
                              playListIndexes.sort((a, b) => a.compareTo(b));
                              if (mounted) {
                                ref
                                    .read(loadAudiosProvider.notifier)
                                    .update((state) => playListIndexes.length);
                              }
                              print("indexes: ${playListIndexes}");
                              print("index : $index");
                              int insertableIndex =
                                  playListIndexes.indexOf(index + 1);

                              print("inserting at $insertableIndex");
                              print('playlistNum: ${playList.children.length}');

                              if (insertableIndex >= playList.children.length) {
                                print("adding at $insertableIndex");
                                playList.add(
                                  AudioSource.file(
                                    filePath,
                                    tag: MediaItem(
                                      id: widget.audios[index],
                                      title:
                                          "${courseModel.title} ${index + 1}",
                                      artist: courseModel.ustaz,
                                      album: courseModel.category,
                                      artUri: Uri.parse(courseModel.image),
                                      extras: courseModel.toMap(),
                                    ),
                                  ),
                                );
                              } else {
                                print("inserting at $insertableIndex");

                                playList.insert(
                                  insertableIndex,
                                  AudioSource.file(
                                    filePath,
                                    tag: MediaItem(
                                      id: widget.audios[index],
                                      title:
                                          "${courseModel.title} ${index + 1}",
                                      artist: courseModel.ustaz,
                                      album: courseModel.category,
                                      artUri: Uri.parse(courseModel.image),
                                      extras: courseModel.toMap(),
                                    ),
                                  ),
                                );
                              }
                              print("num of index: ${playList.length}");
                            },
                            onDeleteBtn: () async {
                              int deleteableIndex =
                                  playListIndexes.indexOf(index + 1);
                              print("deleted index: $deleteableIndex");
                              playListIndexes.removeAt(deleteableIndex);

                              playList.removeAt(deleteableIndex);
                              if (mounted) {
                                ref
                                    .read(loadAudiosProvider.notifier)
                                    .update((state) => playListIndexes.length);
                              }
                            },
                            onPlayTabed: () async {
                              // updating the model if the currently playing course is this course
                              if (isPlayingCourseThisCourse(
                                      courseModel.courseId, ref) &&
                                  processState != ProcessingState.idle) {
                                courseModel = courseModel.copyWith(
                                  isStarted: 1,
                                  pausedAtAudioNum: audioPlayer.currentIndex,
                                  pausedAtAudioSec:
                                      audioPlayer.position.inSeconds,
                                  lastViewed: DateTime.now().toString(),
                                );
                                setState(() {});
                                int destinationIndex =
                                    playListIndexes.indexOf(index + 1);
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
                                print('playListIndexes: $playListIndexes');
                                if (!isPlayingCourseThisCourse(
                                    courseModel.courseId, ref)) {
                                  PlaylistHelper().playList?.clear();
                                  PlaylistHelper().playList?.addAll(lst);
                                }
                                ref.read(audioProvider).setAudioSource(
                                      playList,
                                      initialIndex:
                                          playListIndexes.indexOf(index + 1),
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
                          index: index + 1,
                          courseModel: courseModel,
                          isFromPDF: false,
                          onDownloadDone: (String filePath) async {
                            playListIndexes.add(index + 1);
                            playListIndexes.sort((a, b) => a.compareTo(b));
                            if (mounted) {
                              ref
                                  .read(loadAudiosProvider.notifier)
                                  .update((state) => playListIndexes.length);
                            }
                            print("indexes: ${playListIndexes}");
                            print("index : $index");
                            int insertableIndex =
                                playListIndexes.indexOf(index + 1);

                            print("inserting at $insertableIndex");
                            print('playlistNum: ${playList.children.length}');

                            if (insertableIndex >= playList.children.length) {
                              print("adding at $insertableIndex");
                              playList.add(
                                AudioSource.file(
                                  filePath,
                                  tag: MediaItem(
                                    id: widget.audios[index],
                                    title: "${courseModel.title} ${index + 1}",
                                    artist: courseModel.ustaz,
                                    album: courseModel.category,
                                    artUri: Uri.parse(courseModel.image),
                                    extras: courseModel.toMap(),
                                  ),
                                ),
                              );
                            } else {
                              print("inserting at $insertableIndex");

                              playList.insert(
                                insertableIndex,
                                AudioSource.file(
                                  filePath,
                                  tag: MediaItem(
                                    id: widget.audios[index],
                                    title: "${courseModel.title} ${index + 1}",
                                    artist: courseModel.ustaz,
                                    album: courseModel.category,
                                    artUri: Uri.parse(courseModel.image),
                                    extras: courseModel.toMap(),
                                  ),
                                ),
                              );
                            }
                            print("num of index: ${playList.length}");
                          },
                          onDeleteBtn: () async {
                            int deleteableIndex =
                                playListIndexes.indexOf(index + 1);
                            print("deleted index: $deleteableIndex");
                            playListIndexes.removeAt(deleteableIndex);
                            playList.removeAt(deleteableIndex);
                            if (mounted) {
                              ref
                                  .read(loadAudiosProvider.notifier)
                                  .update((state) => playListIndexes.length);
                            }
                          },
                          onPlayTabed: () {
                            if (isPlayingCourseThisCourse(
                                courseModel.courseId, ref)) {
                              courseModel = courseModel.copyWith(
                                isStarted: 1,
                                pausedAtAudioNum: playListIndexes.indexOf(
                                    audioPlayer.currentIndex != null
                                        ? audioPlayer.currentIndex!
                                        : 0),
                                pausedAtAudioSec:
                                    audioPlayer.position.inSeconds,
                                lastViewed: DateTime.now().toString(),
                              );
                              setState(() {});
                            }
                            if (!isPlayingCourseThisCourse(
                                courseModel.courseId, ref)) {
                              PlaylistHelper().playList?.clear();
                              PlaylistHelper().playList?.addAll(lst);
                            }

                            print('playListIndexes: $playListIndexes');

                            ref.read(audioProvider).setAudioSource(
                                  playList,
                                  initialIndex:
                                      playListIndexes.indexOf(index + 1),
                                  // preload: false,
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
