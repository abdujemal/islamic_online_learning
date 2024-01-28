import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/course_shimmer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../../core/constants.dart';
import '../widgets/course_item.dart';
import '../widgets/the_end.dart';

class FilteredCourses extends ConsumerStatefulWidget {
  final String keey;
  final String value;
  const FilteredCourses(
    this.keey,
    this.value, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilteredCoursesState();
}

class _FilteredCoursesState extends ConsumerState<FilteredCourses> {
  late MainListNotifier mainNotifier;

  ScrollController scrollController = ScrollController();

  bool showTopAudio = false;

  bool showFloatingBtn = false;

  double maxExt = 6;

  @override
  void initState() {
    super.initState();

    mainNotifier = ref.read(mainNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    Future.delayed(const Duration(microseconds: 1)).then((value) {
      mainNotifier.getCourses(
        isNew: true,
        key: widget.keey,
        val: widget.value,
        method: widget.value == "ተፍሲር"
            ? SortingMethod.nameDSC
            : SortingMethod.dateDSC,
      );
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.offset > 400) {
      bool rebuild = false;
      if (showFloatingBtn == false) {
        rebuild = true;
      }
      showFloatingBtn = true;

      if (rebuild) {
        setState(() {});
      }
    } else {
      bool rebuild = false;
      if (showFloatingBtn == true) {
        rebuild = true;
      }
      showFloatingBtn = false;

      if (rebuild) {
        setState(() {});
      }
    }
    maxExt = scrollController.position.maxScrollExtent / 100;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      await mainNotifier.getCourses(
        isNew: false,
        key: widget.keey,
        val: widget.value,
        method: widget.value == "ተፍሲር"
            ? SortingMethod.nameDSC
            : SortingMethod.dateDSC,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);
    return WillPopScope(
      onWillPop: () async {
        mainNotifier.getCourses(isNew: true);
        return true;
      },
      child: StreamBuilder(
          stream: myAudioStream(audioPlayer),
          builder: (context, snap) {
            final state = snap.data?.sequenceState;
            final process = snap.data?.processingState;

            if (state?.sequence.isEmpty ?? true) {
              showTopAudio = false;
            }
            MediaItem? metaData = state?.currentSource?.tag;

            if (metaData != null) {
              showTopAudio = true;
            }
            if (process == ProcessingState.idle) {
              showTopAudio = false;
            }
            return Scaffold(
              appBar: AppBar(
                title: TextScroll(
                  widget.value,
                  velocity: const Velocity(
                    pixelsPerSecond: Offset(30, 0),
                  ),
                  pauseBetween: const Duration(seconds: 1),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(
                    MediaQuery.of(context).size.width,
                    showTopAudio ? 40 : 0,
                  ),
                  child: showTopAudio
                      ? CurrentAudioView(metaData as MediaItem)
                      : const SizedBox(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ref.watch(mainNotifierProvider).map(
                      initial: (_) => const SizedBox(),
                      loading: (_) => ListView.builder(
                        itemCount: 10,
                        itemBuilder: (index, context) => const CourseShimmer(),
                      ),
                      loaded: (_) => RefreshIndicator(
                        onRefresh: () async {
                          await mainNotifier.getCourses(
                            isNew: true,
                            key: widget.keey,
                            val: widget.value,
                            method: widget.value == "ተፍሲር"
                                ? SortingMethod.nameDSC
                                : SortingMethod.dateDSC,
                          );
                        },
                        color: primaryColor,
                        child: Stack(
                          children: [
                            ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 20),
                              controller: scrollController,
                              itemCount: _.courses.length + 1,
                              itemBuilder: (context, index) {
                                if (index <= _.courses.length - 1) {
                                  return CourseItem(_.courses[index]);
                                } else if (_.noMoreToLoad) {
                                  return const TheEnd();
                                } else {
                                  return maxExt < _.courses.length
                                      ? const CourseShimmer()
                                      : const SizedBox();
                                }
                              },
                            ),
                            AnimatedPositioned(
                              right: 5,
                              bottom: showFloatingBtn ? 5 : -57,
                              duration: const Duration(milliseconds: 500),
                              child: Opacity(
                                opacity: /*showFloatingBtn ?*/ 1.0 /*: 0.0*/,
                                child: FloatingActionButton(
                                  onPressed: () => scrollController
                                      .animateTo(
                                        0.0, // Scroll to the top
                                        curve: Curves.easeOut,
                                        duration:
                                            const Duration(milliseconds: 500),
                                      )
                                      .then((value) => setState(() {})),
                                  child: const Icon(
                                    Icons.arrow_upward,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      empty: (_) => const Center(
                        child: Text("ምንም የለም"),
                      ),
                      error: (_) => Center(
                        child: Text(_.error.messege),
                      ),
                    ),
              ),
            );
          }),
    );
  }
}
