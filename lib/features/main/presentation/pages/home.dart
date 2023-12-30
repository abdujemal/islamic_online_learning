// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/ustazs.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/beginner_courses_list.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/main_category.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/started_course_list.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants.dart';
import '../state/category_list_notifier.dart';
import '../state/main_list_notifier.dart';
import '../state/provider.dart';
import '../widgets/course_item.dart';
import '../widgets/course_shimmer.dart';
import '../widgets/the_end.dart';

class Home extends ConsumerStatefulWidget {
  final GlobalKey ustazKey;
  const Home({
    super.key,
    required this.ustazKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with AutomaticKeepAliveClientMixin<Home> {
  late CategoryListNotifier categoryNotifier;
  late MainListNotifier mainNotifier;
  // late StartedListNotifier startedListNotifier;

  ScrollController scrollController = ScrollController();

  int countIteration = 0;

  bool isSearching = false;

  @override
  initState() {
    super.initState();
    categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    mainNotifier = ref.read(mainNotifierProvider.notifier);
    // startedListNotifier = ref.read(startedNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainNotifier.getCourses(isNew: true);
      categoryNotifier.getCategories();
      ref.read(beginnerListProvider.notifier).getCourses();
      ref.watch(startedNotifierProvider.notifier).getCouses();
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isSearching) {
        await mainNotifier.getCourses(isNew: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isSearching = ref.watch(queryProvider) == "";
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: ref.watch(mainNotifierProvider).map(
            initial: (_) => const SizedBox(),
            loading: (_) => ListView.builder(
              itemCount: isSearching ? 10 + 1 : 10,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Wrap(
                    // height: 50,
                    children: List.generate(
                      // itemCount: 5,
                      // scrollDirection: Axis.horizontal,
                      12,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: index == 0
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => const Ustazs(),
                                    ),
                                  );
                                },
                                child: Chip(
                                  avatar: Image.asset('assets/teacher.png'),
                                  backgroundColor: primaryColor,
                                  label: const Text(
                                    "ኡስታዞች",
                                    style: TextStyle(
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              )
                            : Shimmer.fromColors(
                                baseColor: Theme.of(context)
                                    .chipTheme
                                    .backgroundColor!
                                    .withAlpha(150),
                                highlightColor: Theme.of(context)
                                    .chipTheme
                                    .backgroundColor!,
                                child: GestureDetector(
                                  onTap: () {
                                    if (index == 0) {}
                                  },
                                  child: const Chip(
                                    label: Text(
                                      "_______",
                                      style: TextStyle(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                }
                return const CourseShimmer();
              },
            ),
            loaded: (_) {
              return RefreshIndicator(
                onRefresh: () async {
                  if (isSearching) {
                    await mainNotifier.getCourses(isNew: true);
                    await categoryNotifier.getCategories();
                    await ref.read(beginnerListProvider.notifier).getCourses();
                    await ref
                        .watch(startedNotifierProvider.notifier)
                        .getCouses();
                  }
                },
                color: primaryColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  controller: scrollController,
                  itemCount:
                      // isSearching
                      /*?*/ _.courses.length + 4,
                  // : _.courses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return !isSearching
                          ? const SizedBox()
                          : const MainCategories();
                    } else if (index == 1) {
                      return !isSearching
                          ? const SizedBox()
                          : const StartedCourseList();
                    } else if (index == 5) {
                      return !isSearching
                          ? const SizedBox()
                          : const BeginnerCoursesList();
                    } else if (index <= _.courses.length + 2) {
                      return CourseItem(
                          _.courses[index < 5 ? index - 2 : index - 3]);
                    } else if (_.noMoreToLoad) {
                      return const TheEnd();
                    } else {
                      return const CourseShimmer();
                    }
                  },
                ),
              );
            },
            empty: (_) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("እባክዎ ኢንተርኔት አብርተው ድጋሚ ይሞክሩ።"),
                  IconButton(
                    onPressed: () async {
                      await mainNotifier.getCourses(isNew: true);
                      await categoryNotifier.getCategories();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  )
                ],
              ),
            ),
            error: (_) => Center(
              child: Text(_.error.messege),
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
