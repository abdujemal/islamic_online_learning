import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/course_shimmer.dart';

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

  @override
  void initState() {
    super.initState();

    mainNotifier = ref.read(mainNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    Future.delayed(const Duration(microseconds: 1)).then((value) {
      mainNotifier.getCourses(isNew: true, key: widget.keey, val: widget.value);
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      await mainNotifier.getCourses(isNew: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.value),
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
                  mainNotifier.getCourses(
                      isNew: true, key: widget.keey, val: widget.value);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 0),
                  controller: scrollController,
                  itemCount: _.courses.length + 1,
                  itemBuilder: (context, index) {
                    if (index <= _.courses.length - 1) {
                      return CourseItem(_.courses[index]);
                    } else if (_.isLoadingMore) {
                      return const CourseShimmer();
                    } else if (_.noMoreToLoad) {
                      return const TheEnd();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              empty: (_) => const Center(
                child: Text("No Courses"),
              ),
              error: (_) => Center(
                child: Text(_.error.messege),
              ),
            ),
      ),
    );
  }
}
