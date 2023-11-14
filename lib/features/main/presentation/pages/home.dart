// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:islamic_online_learning/features/main/presentation/pages/filtered_courses.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/ustazs.dart';

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

  ScrollController scrollController = ScrollController();

  int countIteration = 0;

  bool isSearching = false;

  @override
  initState() {
    super.initState();
    categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    mainNotifier = ref.read(mainNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      mainNotifier.getCourses(isNew: true);
      categoryNotifier.getCategories();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isSearching
              ? ref.watch(categoryNotifierProvider).map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
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
                                    key: widget.ustazKey,
                                    avatar: Image.asset('assets/teacher.png'),
                                    backgroundColor: primaryColor,
                                    label: const Text("ኡስታዞች"),
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
                    ),
                    loaded: (_) {
                      List<String> categories = ["ኡስታዞች", ..._.categories];
                      return SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => const Ustazs(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FilteredCourses(
                                        "category",
                                        categories[index],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Chip(
                                key: index == 0 ? widget.ustazKey : null,
                                avatar: index == 0
                                    ? Image.asset('assets/teacher.png')
                                    : null,
                                backgroundColor:
                                    index == 0 ? primaryColor : null,
                                label: Text(
                                  categories[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    empty: (_) => const Center(
                      child: Text("ምድብ የለም"),
                    ),
                    error: (_) => Center(
                      child: Text(_.error.messege),
                    ),
                  )
              : const SizedBox(),
          ref.watch(mainNotifierProvider).map(
                initial: (_) => const SizedBox(),
                loading: (_) => Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (index, context) => const CourseShimmer(),
                  ),
                ),
                loaded: (_) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (isSearching) {
                          await mainNotifier.getCourses(isNew: true);
                          await categoryNotifier.getCategories();
                        }
                      },
                      color: primaryColor,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
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
                  );
                },
                empty: (_) => Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ምንም የለም"),
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
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
