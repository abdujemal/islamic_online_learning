// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../../core/Audio Feature/playlist_helper.dart';
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

  List<String> pdfPaths = [];

  List<int> playListIndexes = [];

  List<AudioSource> lst = [];

  final GlobalKey _shareKey = GlobalKey();
  final GlobalKey _downloadKey = GlobalKey();
  final GlobalKey _alarmKey = GlobalKey();

  bool showTopAudio = false;

  late CourseModel courseModel;

  bool isLoadingAudio = false;

  Timer? downloadTimer;

  double percentage = 0;

  bool isConnected = true;

  bool show = false;

  bool showOnes = true;

  showTutorial() {
    List<TargetFocus> targets = [
      getTutorial(
        key: _shareKey,
        identify: "ShareButton",
        align: ContentAlign.bottom,
        title: "የአጋራ ቁልፍ",
        subtitle: "ይህንን ቁልፍ ነክተው ደርሱን ለጓደኛ ወይም ለዘመድ ማጋራት ይችላሉ።",
      ),
      getTutorial(
        key: _downloadKey,
        identify: "DownloadButton",
        align: ContentAlign.bottom,
        title: "የዳውንሎድ ቁልፍ",
        subtitle: "ይህንን ቁልፍ ነክተው ድምፆችንና ፒዲኤፍ ዳውሎድ ማድረግ ይችላሉ።",
      ),
      getTutorial(
        key: _alarmKey,
        identify: "AlarmButton",
        align: ContentAlign.bottom,
        title: "የአስታዋሽ መመዝጋቢያ ቁልፍ",
        subtitle:
            "ይህንን ቁልፍ ነክተው የሚመቾትን ቀን ና ሰዓትን ሞልተው መተግበሪያው እንዲያስታውሶ ማድረግ ይችላሉ።",
      ),
    ];

    if (show) {
      TutorialCoachMark(
          targets: targets,
          colorShadow: primaryColor,
          onFinish: () {
            ref.read(sharedPrefProvider).then((pref) {
              final show1 = bool.parse(
                  pref.getString("showGuide")?.split(",").first ?? "true");

              pref.setString("showGuide", '$show1,false');

              show = false;
              setState(() {});
            });
          },
          onSkip: () {
            ref.read(sharedPrefProvider).then((pref) {
              final show1 = bool.parse(
                  pref.getString("showGuide")?.split(",").first ?? "true");

              pref.setString("showGuide", '$show1,false');

              show = false;
              setState(() {});
            });
            return true;
          }).show(context: context);
    }
  }

  @override
  void initState() {
    super.initState();
    courseModel = widget.cm;
    audios = courseModel.courseIds.split(",");

    refresh();

    if (mounted) {
      createPlayList();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(sharedPrefProvider).then((pref) {
          ref.read(showGuideProvider.notifier).update(
            (state) {
              show = bool.parse(
                  pref.getString("showGuide")?.split(",").last ?? "true");

              print("${pref.getString("showGuide")}");

              if (show) {
                if (showOnes) {
                  print("goooo");
                  showTutorial();
                  showOnes = false;
                }
              }

              return [
                bool.parse(
                    pref.getString("showGuide")?.split(",").first ?? "true"),
                show,
              ];
            },
          );
        });
      });
    }

    for (int i = 1; i <= courseModel.pdfId.split(",").length; i++) {
      getPath(
              'PDF',
              courseModel.pdfId.contains(",")
                  ? "${courseModel.title} $i.pdf"
                  : "${courseModel.title}.pdf")
          .then((value) {
        pdfPaths.add(value);
        setState(() {});
      });
    }
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
      final isDownloaded = await ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded("${courseModel.ustaz},${courseModel.title} $index.mp3",
              "Audio", context);
      return isDownloaded;
    }
    return false;
  }

  Future<void> refresh() async {
    if (kDebugMode) {
      print("refreshing...");
    }
    final res = await ref
        .read(mainNotifierProvider.notifier)
        .getSingleCourse(widget.cm.courseId, context);
    if (res != null) {
      courseModel = CourseModel.fromMap(
        widget.cm.toOriginalMap(),
        widget.cm.courseId,
        copyFrom: res,
      );
      if (mounted) {
        await ref.read(mainNotifierProvider.notifier).saveCourse(
              courseModel.copyWith(
                lastViewed: DateTime.now().toString(),
              ),
              null,
              context,
              showMsg: false,
            );
        if (kDebugMode) {
          print(Duration(seconds: courseModel.pausedAtAudioSec).inMinutes);
        }
        setState(() {});
      }
    } else {
      if (kDebugMode) {
        print("it is null");
      }
    }
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);
    final playList =
        PlaylistHelper().playList ?? ConcatenatingAudioSource(children: []);

    percentage =
        getPersentage(courseModel).isNaN ? 1 : getPersentage(courseModel);

    return PopScope(
      canPop: !show,
      child: StreamBuilder(
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
                print("playListIndexes: $playListIndexes");
                print("playlist: ${playList.children}");
                print("index: ${audioPlayer.currentIndex}");
                print(
                    'saveable index ${playListIndexes[audioPlayer.currentIndex != null ? audioPlayer.currentIndex! : 0] - 1}');
                if (courseModel.isFinished == 0) {
                  courseModel = courseModel.copyWith(
                    isStarted: 1,
                    pausedAtAudioNum: playListIndexes[
                            audioPlayer.currentIndex != null
                                ? audioPlayer.currentIndex!
                                : 0] -
                        1,
                    pausedAtAudioSec: audioPlayer.position.inSeconds,
                    lastViewed: DateTime.now().toString(),
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
                        pauseBetween: const Duration(seconds: 1),
                        velocity:
                            const Velocity(pixelsPerSecond: Offset(30, 0)),
                        courseModel.title,
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
                                context);
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
                          key: _downloadKey,
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
                                  int index = int.parse(filePath
                                      .replaceAll(".mp3", "")
                                      .split(" ")
                                      .last);

                                  playListIndexes.add(index);
                                  playListIndexes
                                      .sort((a, b) => a.compareTo(b));
                                  if (mounted) {
                                    ref
                                        .read(loadAudiosProvider.notifier)
                                        .update(
                                            (state) => playListIndexes.length);
                                  }
                                  print("indexes: ${playListIndexes}");
                                  print("index : $index");
                                  int insertableIndex =
                                      playListIndexes.indexOf(index);

                                  print("inserting at $insertableIndex");
                                  print(
                                      'playlistNum: ${playList.children.length}');

                                  if (insertableIndex >=
                                      playList.children.length) {
                                    print("adding at $insertableIndex");
                                    playList.add(
                                      AudioSource.file(
                                        filePath,
                                        tag: MediaItem(
                                          id: audios[index - 1],
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
                                          id: audios[index - 1],
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
                        IconButton(
                          key: _shareKey,
                          onPressed: () async {
                            final url = await ref
                                .read(cdNotifierProvider.notifier)
                                .createDynamicLink(courseModel, context);

                            if (url.isNotEmpty) {
                              await Share.share(url, subject: "ይህንን ደርስ ይመልከቱ");
                            }
                          },
                          icon: const Icon(Icons.share),
                        )
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
                            SizedBox(
                              child: CachedNetworkImage(
                                imageUrl: courseModel.image,
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.40,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context)
                                  .chipTheme
                                  .backgroundColor!
                                  .withOpacity(0.3),
                            ),
                            Positioned(
                              bottom: 8,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MainBtn(
                                      key: _alarmKey,
                                      title:
                                          courseModel.scheduleDates.isNotEmpty
                                              ? "ማስታወሻውን አስተካክል"
                                              : "አስታዋሽ መዝግብ",
                                      icon: courseModel.scheduleDates.isNotEmpty
                                          ? Icons.access_alarms
                                          : Icons.alarm_add_rounded,
                                      onTap: () async {
                                        setState(() {});
                                        if (mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => ScheduleView(
                                              courseModel: courseModel,
                                              onSave: (scheduleDates,
                                                  scheduleTime,
                                                  isScheduleOn) async {
                                                await ref
                                                    .read(mainNotifierProvider
                                                        .notifier)
                                                    .saveCourse(
                                                      courseModel.copyWith(
                                                        isStarted: 1,
                                                        scheduleDates:
                                                            scheduleDates,
                                                        scheduleTime:
                                                            scheduleTime,
                                                        isScheduleOn:
                                                            isScheduleOn,
                                                      ),
                                                      null,
                                                      context,
                                                      showMsg: false,
                                                    );
                                                courseModel =
                                                    courseModel.copyWith(
                                                  isStarted: 1,
                                                  scheduleDates: scheduleDates,
                                                  scheduleTime: scheduleTime,
                                                  isScheduleOn: isScheduleOn,
                                                );

                                                if (mounted) {
                                                  final res = await ref
                                                      .read(mainNotifierProvider
                                                          .notifier)
                                                      .getSingleCourse(
                                                          widget.cm.courseId,
                                                          context);
                                                  return res?.id;
                                                }
                                                return null;
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (courseModel.isStarted == 1 &&
                                        courseModel.isFinished == 0)
                                      MainBtn(
                                        title: "ካቆምኩበት ቀጥል",
                                        icon: Icons.play_arrow_rounded,
                                        onTap: () async {
                                          await createPlayList();
                                          if (!playListIndexes.contains(
                                              courseModel.pausedAtAudioNum +
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
                                              courseModel.courseId, ref)) {
                                            PlaylistHelper().playList?.clear();
                                            PlaylistHelper()
                                                .playList
                                                ?.addAll(lst);
                                          }
                                          if (playList.length > 0) {
                                            int playableIndex = playListIndexes
                                                .indexOf(courseModel
                                                        .pausedAtAudioNum +
                                                    1);
                                            print(
                                                "playListIndexes: $playListIndexes");
                                            print(
                                                "pausedAtAudioNum: $playableIndex");
                                            await audioPlayer.setAudioSource(
                                              playList,
                                              initialIndex:
                                                  courseModel.pausedAtAudioNum <
                                                          0
                                                      ? 0
                                                      : playableIndex,
                                              initialPosition: Duration(
                                                seconds: courseModel
                                                    .pausedAtAudioSec,
                                              ),
                                            );
                                            audioPlayer.play();

                                            if (mounted) {
                                              bool isPDFDownloded = await ref
                                                  .read(cdNotifierProvider
                                                      .notifier)
                                                  .isDownloaded(
                                                    courseModel.pdfId
                                                            .contains(",")
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
                                                String path = await getPath(
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
                                                      builder: (_) => PdfPage(
                                                        volume:
                                                            courseModel.pdfNum,
                                                        path: path,
                                                        courseModel:
                                                            courseModel,
                                                      ),
                                                    ),
                                                  );
                                                  refresh();
                                                }
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
                                              .read(
                                                  mainNotifierProvider.notifier)
                                              .saveCourse(
                                                courseModel.copyWith(
                                                  isFinished: 0,
                                                  pdfPage: 0,
                                                  pausedAtAudioNum: 0,
                                                  pausedAtAudioSec: 0,
                                                  lastViewed:
                                                      DateTime.now().toString(),
                                                ),
                                                null,
                                                context,
                                                showMsg: false,
                                              );
                                          courseModel = courseModel.copyWith(
                                            isFinished: 0,
                                            pdfPage: 0,
                                            pausedAtAudioNum: 0,
                                            pausedAtAudioSec: 0,
                                          );
                                          setState(() {});
                                          createPlayList();
                                        },
                                      ),
                                  ],
                                ),
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
                                    title: "ኪታቡን ያቀራው ኡስታዝ",
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
                                      title: "የኪታቡ ፀሀፊ",
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
                                      title: "ኪታቡ በሶፍት ኮፒ",
                                    ),
                                  ),
                                if (courseModel.pdfId.trim() != "" &&
                                    pdfPaths.isNotEmpty)
                                  for (int i = 1;
                                      i <= courseModel.pdfId.split(",").length;
                                      i++)
                                    PdfItem(
                                      fileId:
                                          courseModel.pdfId.split(",")[i - 1],
                                      path: pdfPaths[i - 1],
                                      volume: i.toDouble(),
                                      courseModel: courseModel,
                                      title: courseModel.pdfId.contains(",")
                                          ? "${courseModel.title} $i"
                                          : courseModel.title,
                                      whenPop: () {
                                        refresh();
                                      },
                                    ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const ListTitle(
                                        title: "ድምፆች",
                                      ),
                                      const Spacer(),
                                      Consumer(builder: (context, wref, _) {
                                        final loadAudios =
                                            wref.watch(loadAudiosProvider);
                                        return Text(
                                            "$loadAudios / ${audios.length} ድምፆች ዝግጁ ሆነዋል");
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
                            if (state?.sequence.isNotEmpty ?? false) {
                              final mediaItem =
                                  state!.currentSource!.tag as MediaItem;

                              return AudioItem(
                                isPlaying: mediaItem.id == audios[index - 1] &&
                                    audioPlayer.processingState !=
                                        ProcessingState.idle,
                                canAudioPlay: true,
                                canNeverPlay: false,
                                audioId: audios[index - 1],
                                title: courseModel.title,
                                index: index,
                                courseModel: courseModel,
                                isFromPDF: false,
                                onDownloadDone: (String filePath) async {
                                  playListIndexes.add(index);
                                  playListIndexes
                                      .sort((a, b) => a.compareTo(b));
                                  if (mounted) {
                                    ref
                                        .read(loadAudiosProvider.notifier)
                                        .update(
                                            (state) => playListIndexes.length);
                                  }
                                  print("indexes: ${playListIndexes}");
                                  print("index : $index");
                                  int insertableIndex =
                                      playListIndexes.indexOf(index);

                                  print("inserting at $insertableIndex");
                                  print(
                                      'playlistNum: ${playList.children.length}');

                                  if (insertableIndex >=
                                      playList.children.length) {
                                    print("adding at $insertableIndex");
                                    playList.add(
                                      AudioSource.file(
                                        filePath,
                                        tag: MediaItem(
                                          id: audios[index - 1],
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
                                          id: audios[index - 1],
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
                                onDeleteBtn: () async {
                                  int deleteableIndex =
                                      playListIndexes.indexOf(index);
                                  print("deleted index: $deleteableIndex");
                                  playListIndexes.removeAt(deleteableIndex);

                                  playList.removeAt(deleteableIndex);
                                  if (mounted) {
                                    ref
                                        .read(loadAudiosProvider.notifier)
                                        .update(
                                            (state) => playListIndexes.length);
                                  }
                                },
                                onPlayTabed: () async {
                                  // updating the model if the currently playing course is this course
                                  if (isPlayingCourseThisCourse(
                                          courseModel.courseId, ref) &&
                                      processState != ProcessingState.idle) {
                                    courseModel = courseModel.copyWith(
                                      isStarted: 1,
                                      pausedAtAudioNum:
                                          audioPlayer.currentIndex,
                                      pausedAtAudioSec:
                                          audioPlayer.position.inSeconds,
                                      lastViewed: DateTime.now().toString(),
                                    );
                                    setState(() {});
                                    int destinationIndex =
                                        playListIndexes.indexOf(index);
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
                                        ref
                                            .read(audioProvider)
                                            .seekToPrevious();
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
                                              playListIndexes.indexOf(index),
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
                              audioId: audios[index - 1],
                              title: courseModel.title,
                              index: index,
                              courseModel: courseModel,
                              isFromPDF: false,
                              onDownloadDone: (String filePath) async {
                                playListIndexes.add(index);
                                playListIndexes.sort((a, b) => a.compareTo(b));
                                if (mounted) {
                                  ref.read(loadAudiosProvider.notifier).update(
                                      (state) => playListIndexes.length);
                                }
                                print("index : $index");
                                int insertableIndex =
                                    playListIndexes.indexOf(index);

                                print("inserting at $insertableIndex");

                                if (insertableIndex ==
                                    playList.children.length) {
                                  print("adding at $insertableIndex");

                                  playList.add(
                                    AudioSource.file(
                                      filePath,
                                      tag: MediaItem(
                                        id: audios[index - 1],
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
                                        id: audios[index - 1],
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
                              onDeleteBtn: () async {
                                int deleteableIndex =
                                    playListIndexes.indexOf(index);
                                print("deleted index: $deleteableIndex");
                                playListIndexes.removeAt(deleteableIndex);
                                playList.removeAt(deleteableIndex);
                                if (mounted) {
                                  ref.read(loadAudiosProvider.notifier).update(
                                      (state) => playListIndexes.length);
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
                                          playListIndexes.indexOf(index),
                                      // preload: false,
                                    );
                                ref.read(audioProvider).play();
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
      ),
    );
  }
}
