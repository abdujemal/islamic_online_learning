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
import '../../../../core/Audio Feature/playlist_helper.dart';
import '../../../../core/constants.dart';
import '../widgets/course_item.dart';
import '../widgets/the_end.dart';

class FilteredCourses extends ConsumerStatefulWidget {
  final String keey;
  final String value;
  final String? fromKey;
  final String? fromVal;
  const FilteredCourses(
    this.keey,
    this.value, {
    this.fromKey,
    this.fromVal,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainNotifier.getCourses(
        context: context,
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
        context: context,
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
    final audioPlayer = PlaylistHelper.audioPlayer;
    return WillPopScope(
      onWillPop: () async {
        // if (widget.fromKey != null && widget.fromVal != null) {
        mainNotifier.getCourses(
          context: context,
          isNew: true,
          // key: widget.fromKey,
          // val: widget.fromVal,
        );
        // }
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
                      ? CurrentAudioView(
                          metaData as MediaItem,
                          keey: widget.keey,
                          val: widget.value,
                        )
                      : const SizedBox(),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Builder(
                    builder: (context) {
                      final state = ref.watch(mainNotifierProvider);
                      if (state.isLoading) {
                        return ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) =>
                              const CourseShimmer(),
                        );
                      } else if (!state.isLoading && state.courses.isNotEmpty) {
                        final courses = state.courses;
                        final noMoreToLoad = state.noMoreToLoad;
                        return RefreshIndicator(
                          onRefresh: () async {
                            await mainNotifier.getCourses(
                              context: context,
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
                                itemCount: courses.length + 1,
                                itemBuilder: (context, index) {
                                  if (index <= courses.length - 1) {
                                    return CourseItem(courses[index],
                                        keey: widget.keey, val: widget.value);
                                  } else if (noMoreToLoad) {
                                    return const TheEnd();
                                  } else {
                                    return maxExt < courses.length
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
                        );
                      } else if (!state.isLoading && state.courses.isEmpty) {
                        return const Center(
                          child: Text("ምንም የለም"),
                        );
                      } else if (!state.isLoading && state.error != null) {
                        return Center(
                          child: Text(state.error!),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
