// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/list_title.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/pdf_page.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_item.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/download_all_files.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/main_btn.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/schedule_veiw.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../stateNotifier/providers.dart';
import '../widgets/audio_bottom_view.dart';
import '../widgets/pdf_item.dart';

class CourseDetail extends ConsumerStatefulWidget {
  final CourseModel cm;

  const CourseDetail({
    super.key,
    required this.cm,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  List<String> audios = [];

  String? pdfPath;

  List<AudioSource> playList = [];

  bool showTopAudio = false;

  late CourseModel courseModel;

  bool isLoadingAudio = false;

  double percentage = 0;

  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    courseModel = widget.cm;
    audios = courseModel.courseIds.split(",");

    refresh();

    if (mounted) {
      createPlayList();
    }

    getPath('PDF', "${courseModel.title}.pdf").then((value) {
      pdfPath = value;
      setState(() {});
    });
  }

  Future<void> createPlayList() async {
    isLoadingAudio = true;
    if (mounted) {
      setState(() {});
    }
    playList = [];
    Directory dir = await getApplicationSupportDirectory();

    int i = 0;
    List<AudioSource> lst = [];
    ref.read(loadAudiosProvider.notifier).update((state) => 0);
    for (String id in audios) {
      i++;
      if (await checkFile(i)) {
        String fileName = "${courseModel.ustaz},${courseModel.title} $i.mp3";

        if (mounted) {
          ref.read(loadAudiosProvider.notifier).update((state) => state + 1);
        }

        lst.add(
          AudioSource.file(
            "${dir.path}/Audio/$fileName",
            tag: MediaItem(
              id: id,
              title: "${courseModel.title} $i",
              artist: courseModel.ustaz,
              album: courseModel.category,
              artUri: Uri.file("${dir.path}/Images/${courseModel.title}.jpg"),
              extras: courseModel.toMap(),
            ),
          ),
        );
      } else {
        final url = await ref
            .read(cdNotifierProvider.notifier)
            .loadFileOnline(id, true, showError: false);
        if (url != null) {
          if (mounted) {
            ref.read(loadAudiosProvider.notifier).update((state) => state + 1);
          }

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
                artUri: Uri.file("${dir.path}/Images/${courseModel.title}.jpg"),
                extras: courseModel.toMap(),
              ),
            ),
          );
        }
      }
    }
    playList.addAll(lst);
    isLoadingAudio = false;
    if (mounted) {
      setState(() {});
    }
    print("playlist itams: ${playList.length}");
  }

  Future<bool> checkFile(int index) async {
    if (mounted) {
      final isDownloaded = await ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded(
              "${courseModel.ustaz},${courseModel.title} $index.mp3", "Audio");
      return isDownloaded;
    }
    return false;
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    final res = await ref
        .read(mainNotifierProvider.notifier)
        .getSingleCourse(widget.cm.courseId);

    if (res != null) {
      courseModel = CourseModel.fromMap(
        widget.cm.toOriginalMap(),
        widget.cm.courseId,
        copyFrom: res,
      );
      await ref.read(mainNotifierProvider.notifier).saveCourse(
            courseModel.copyWith(
              lastViewed: DateTime.now().toString(),
            ),
            null,
            showMsg: false,
          );
      print("it worked");
      print(courseModel.pdfPage);
      setState(() {});
    } else {
      print("it is null");
    }
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);

    percentage = (courseModel.pausedAtAudioNum + 1) / courseModel.noOfRecord;

    return StreamBuilder(
      stream: myAudioStream(audioPlayer),
      builder: (context, snap) {
        final state = snap.data?.sequenceState;
        final processState = snap.data?.processingState;

        if (state?.sequence.isEmpty ?? true) {
          showTopAudio = false;
        }
        MediaItem? metaData = state?.currentSource?.tag;

        if (metaData != null &&
            "${metaData.extras?["courseId"]}" != courseModel.courseId) {
          showTopAudio = true;
        }

        if (processState == ProcessingState.idle) {
          showTopAudio = false;
        }
        return Scaffold(
          bottomNavigationBar: AudioBottomView(
            courseModel.courseId,
            () {
              if (courseModel.isFinished == 0) {
                courseModel = courseModel.copyWith(
                  isStarted: 1,
                  pausedAtAudioNum: audioPlayer.currentIndex,
                  pausedAtAudioSec: audioPlayer.position.inSeconds,
                );

                setState(() {});
              }
            },
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                await refresh();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.40,
                    collapsedHeight: 60,
                    title: TextScroll(
                      courseModel.title,
                      pauseBetween: const Duration(seconds: 1),
                      velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                    ),
                    floating: false,
                    pinned: true,
                    snap: false,
                    actions: [
                      IconButton(
                        onPressed: () {
                          ref.read(mainNotifierProvider.notifier).saveCourse(
                                courseModel,
                                courseModel.isFav == 1 ? 0 : 1,
                              );
                          courseModel = courseModel.copyWith(
                            isFav: courseModel.isFav == 1 ? 0 : 1,
                          );
                          setState(() {});
                        },
                        icon: courseModel.isFav == 1
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
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => DownloadAllFiles(
                              courseModel: courseModel,
                              onSingleDownloadDone: (filePath) async {
                                print("Dwonload done $filePath");
                                int index = int.parse(filePath
                                    .replaceAll(".mp3", "")
                                    .split(" ")
                                    .last);
                                Directory dir =
                                    await getApplicationSupportDirectory();

                                if (playList.isEmpty ||
                                    index >= audios.length) {
                                  createPlayList();
                                  return;
                                }

                                playList[index - 1] = AudioSource.file(
                                  filePath,
                                  tag: MediaItem(
                                    id: audios[index - 1],
                                    title: "${courseModel.title} $index",
                                    artist: courseModel.ustaz,
                                    album: courseModel.category,
                                    artUri: Uri.file(
                                        "${dir.path}/Images/${courseModel.title}.jpg"),
                                    extras: courseModel.toMap(),
                                  ),
                                );

                                if (isPlayingCourseThisCourse(
                                  courseModel.courseId,
                                  ref,
                                  alsoIsNotIdle: true,
                                )) {
                                  ref.read(audioProvider).setAudioSource(
                                        ConcatenatingAudioSource(
                                          children: playList,
                                        ),
                                        initialIndex: ref
                                            .read(audioProvider)
                                            .currentIndex,
                                        initialPosition:
                                            ref.read(audioProvider).position,
                                        preload: false,
                                      );

                                  ref.read(audioProvider).play();
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size(
                        MediaQuery.of(context).size.width,
                        showTopAudio ? 40 : 0,
                      ),
                      child: showTopAudio
                          ? CurrentAudioView(metaData as MediaItem)
                          : const SizedBox(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      background: Stack(
                        children: [
                          FutureBuilder(
                            future: displayImage(
                              courseModel.image,
                              courseModel.category == "ተፍሲር"
                                  ? "ተፍሲር"
                                  : courseModel.title,
                              ref,
                            ),
                            builder: (context, snap) {
                              return snap.data == null
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      ),
                                    )
                                  : snap.data!.path.isEmpty
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.40,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Center(
                                            child: Icon(Icons.error_rounded),
                                          ),
                                        )
                                      : SizedBox(
                                          child: Image.file(
                                            snap.data!,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.40,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                            },
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.40,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context)
                                .chipTheme
                                .backgroundColor!
                                .withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MainBtn(
                                  title: "አስታዋሽ መዝግብ",
                                  icon: Icons.alarm_add_rounded,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) =>
                                          ScheduleView(courseModel),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (courseModel.isStarted == 1 &&
                                    courseModel.isFinished == 0)
                                  MainBtn(
                                    title: "ካቆምኩበት ቀጥል",
                                    icon: Icons.play_arrow_rounded,
                                    onTap: () async {
                                      await createPlayList();
                                      if (playList.isNotEmpty) {
                                        await audioPlayer.setAudioSource(
                                          ConcatenatingAudioSource(
                                            children: playList,
                                          ),
                                          initialIndex:
                                              courseModel.pausedAtAudioNum < 0
                                                  ? 0
                                                  : courseModel
                                                      .pausedAtAudioNum,
                                          initialPosition: Duration(
                                            seconds:
                                                courseModel.pausedAtAudioSec,
                                          ),
                                        );
                                        audioPlayer.play();
                                        bool isPDFDownloded = await ref
                                            .read(cdNotifierProvider.notifier)
                                            .isDownloaded(
                                                "${courseModel.title}.pdf",
                                                "PDF");
                                        if (courseModel.pdfId
                                                .trim()
                                                .isNotEmpty &&
                                            isPDFDownloded) {
                                          String path = await getPath('PDF',
                                              "${courseModel.title}.pdf");
                                          if (mounted) {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PdfPage(
                                                  path: path,
                                                  courseModel: courseModel,
                                                ),
                                              ),
                                            );
                                            refresh();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                if (courseModel.isFinished == 1)
                                  MainBtn(
                                    title: "ደጋሚ ጀምር",
                                    icon: Icons.refresh,
                                    onTap: () {
                                      ref
                                          .read(mainNotifierProvider.notifier)
                                          .saveCourse(
                                            courseModel.copyWith(
                                              isFinished: 0,
                                              pdfPage: 0,
                                              pausedAtAudioNum: -1,
                                              pausedAtAudioSec: 0,
                                              lastViewed:
                                                  DateTime.now().toString(),
                                            ),
                                            null,
                                          );
                                      courseModel = courseModel.copyWith(
                                        isFinished: 0,
                                        pdfPage: 0,
                                        pausedAtAudioNum: -1,
                                        pausedAtAudioSec: 0,
                                      );
                                      setState(() {});
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              if (courseModel.isStarted == 1)
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: ListTitle(
                                    title: "እርስዎ የተማሩት መጠን",
                                  ),
                                ),
                              if (courseModel.isStarted == 1)
                                ListTile(
                                  leading: const Icon(Icons.percent),
                                  title: Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: percentage,
                                        color: primaryColor,
                                        backgroundColor: Theme.of(context)
                                            .chipTheme
                                            .backgroundColor,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            "${(percentage * 100).toStringAsFixed(2)}% ጨርሰዋል"),
                                      ),
                                    ],
                                  ),
                                ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: ListTitle(
                                  title: "ኪታብን ያቀራው ኡስታዝ",
                                ),
                              ),
                              ListTile(
                                title: Text(courseModel.ustaz),
                                leading: const Icon(Icons.mic_rounded),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: ListTitle(
                                  title: "ምድብ",
                                ),
                              ),
                              ListTile(
                                title: Text(courseModel.category),
                                leading: const Icon(Icons.category_rounded),
                              ),
                              if (courseModel.author.trim().isNotEmpty)
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: ListTitle(
                                    title: "የኪታቡ ጸሃፊ",
                                  ),
                                ),
                              if (courseModel.author.trim().isNotEmpty)
                                ListTile(
                                  title: Text(courseModel.author),
                                  leading: const Icon(Icons.edit_document),
                                ),
                              if (courseModel.pdfId.trim() != "")
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: ListTitle(
                                    title: "ኪታብ በሶፍት ኮፒ",
                                  ),
                                ),
                              if (courseModel.pdfId.trim() != "" &&
                                  pdfPath != null)
                                PdfItem(
                                  fileId: courseModel.pdfId,
                                  path: pdfPath!,
                                  courseModel: courseModel,
                                  whenPop: () {
                                    print("Absolutely it is running it");
                                    refresh();
                                  },
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const ListTitle(
                                      title: "ድምጾች",
                                    ),
                                    const Spacer(),
                                    Consumer(builder: (context, wref, _) {
                                      final loadAudios =
                                          wref.watch(loadAudiosProvider);
                                      return Text(
                                          "$loadAudios / ${audios.length} ድምጾች ዝግጁ ሆኗል");
                                    }),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (isLoadingAudio)
                                      const SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      ),
                                    if (!isLoadingAudio)
                                      GestureDetector(
                                        onTap: () {
                                          createPlayList();
                                        },
                                        child:
                                            const Icon(Icons.refresh_rounded),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        } else if (index > 0 && index - 1 < audios.length) {
                          return StreamBuilder(
                            stream: audioPlayer.sequenceStateStream,
                            builder: (context, snap) {
                              final state = snap.data;
                              if (state?.sequence.isNotEmpty ?? false) {
                                final mediaItem =
                                    state!.currentSource!.tag as MediaItem;

                                return AudioItem(
                                  isPlaying: mediaItem.id == audios[index - 1],
                                  canAudioPlay: playList.isNotEmpty,
                                  canNeverPlay:
                                      !isLoadingAudio && playList.isEmpty,
                                  audioId: audios[index - 1],
                                  title: courseModel.title,
                                  index: index,
                                  courseModel: courseModel,
                                  isFromPDF: false,
                                  onDownloadDone: (String filePath) async {
                                    Directory dir =
                                        await getApplicationSupportDirectory();

                                    if (playList.isEmpty ||
                                        index >= audios.length) {
                                      createPlayList();
                                      return;
                                    }

                                    playList[index - 1] = AudioSource.file(
                                      filePath,
                                      tag: MediaItem(
                                        id: audios[index - 1],
                                        title: "${courseModel.title} $index",
                                        artist: courseModel.ustaz,
                                        album: courseModel.category,
                                        artUri: Uri.file(
                                            "${dir.path}/Images/${courseModel.title}.jpg"),
                                        extras: courseModel.toMap(),
                                      ),
                                    );

                                    if (isPlayingCourseThisCourse(
                                      courseModel.courseId,
                                      ref,
                                      alsoIsNotIdle: true,
                                    )) {
                                      ref.read(audioProvider).setAudioSource(
                                            ConcatenatingAudioSource(
                                              children: playList,
                                            ),
                                            initialIndex: ref
                                                .read(audioProvider)
                                                .currentIndex,
                                            initialPosition: ref
                                                .read(audioProvider)
                                                .position,
                                            preload: false,
                                          );

                                      ref.read(audioProvider).play();
                                    }
                                  },
                                  onPlayTabed: () {
                                    // updating the model if the currently playing course is this course
                                    if (isPlayingCourseThisCourse(
                                        courseModel.courseId, ref)) {
                                      courseModel = courseModel.copyWith(
                                        isStarted: 1,
                                        pausedAtAudioNum:
                                            audioPlayer.currentIndex,
                                        pausedAtAudioSec:
                                            audioPlayer.position.inSeconds,
                                      );
                                      setState(() {});
                                    }
                                    ref.read(audioProvider).setAudioSource(
                                          ConcatenatingAudioSource(
                                            children: playList,
                                          ),
                                          initialIndex: index - 1,
                                          preload: false,
                                        );
                                    ref.read(audioProvider).play();
                                  },
                                );
                              }
                              return AudioItem(
                                isPlaying: false,
                                canAudioPlay: playList.isNotEmpty,
                                canNeverPlay:
                                    !isLoadingAudio && playList.isEmpty,
                                audioId: audios[index - 1],
                                title: courseModel.title,
                                index: index,
                                courseModel: courseModel,
                                isFromPDF: false,
                                onDownloadDone: (String filePath) async {
                                  Directory dir =
                                      await getApplicationSupportDirectory();

                                  if (playList.isEmpty ||
                                      index >= audios.length) {
                                    createPlayList();
                                    return;
                                  }

                                  playList[index - 1] = AudioSource.file(
                                    filePath,
                                    tag: MediaItem(
                                      id: audios[index - 1],
                                      title: "${courseModel.title} $index",
                                      artist: courseModel.ustaz,
                                      album: courseModel.category,
                                      artUri: Uri.file(
                                          "${dir.path}/Images/${courseModel.title}.jpg"),
                                      extras: courseModel.toMap(),
                                    ),
                                  );

                                  if (isPlayingCourseThisCourse(
                                    courseModel.courseId,
                                    ref,
                                    alsoIsNotIdle: true,
                                  )) {
                                    ref.read(audioProvider).setAudioSource(
                                          ConcatenatingAudioSource(
                                            children: playList,
                                          ),
                                          initialIndex: ref
                                              .read(audioProvider)
                                              .currentIndex,
                                          initialPosition:
                                              ref.read(audioProvider).position,
                                          preload: false,
                                        );

                                    ref.read(audioProvider).play();
                                  }
                                },
                                onPlayTabed: () {
                                  if (isPlayingCourseThisCourse(
                                      courseModel.courseId, ref)) {
                                    courseModel = courseModel.copyWith(
                                      isStarted: 1,
                                      pausedAtAudioNum:
                                          audioPlayer.currentIndex,
                                      pausedAtAudioSec:
                                          audioPlayer.position.inSeconds,
                                    );
                                    setState(() {});
                                  }
                                  ref.read(audioProvider).setAudioSource(
                                        ConcatenatingAudioSource(
                                          children: playList,
                                        ),
                                        initialIndex: index - 1,
                                        preload: false,
                                      );
                                  ref.read(audioProvider).play();
                                },
                              );
                            },
                          );
                        } else if (index == audios.length + 1) {
                          return const SizedBox(
                            height: 400,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                      childCount: audios.length + 2,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
