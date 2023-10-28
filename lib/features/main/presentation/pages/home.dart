// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/filtered_courses.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_notifier.dart';
import 'package:shimmer/shimmer.dart';

import '../state/category_list_notifier.dart';
import '../state/main_list_notifier.dart';
import '../state/provider.dart';
import '../widgets/course_item.dart';
import '../widgets/course_shimmer.dart';
import '../widgets/the_end.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with AutomaticKeepAliveClientMixin<Home> {
  late CategoryListNotifier categoryNotifier;
  late UstazListNotifier ustazListNotifier;
  late MainListNotifier mainNotifier;

  ScrollController scrollController = ScrollController();

  int countIteration = 0;

  @override
  initState() {
    super.initState();
    categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    ustazListNotifier = ref.read(ustazNotifierProvider.notifier);
    mainNotifier = ref.read(mainNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      mainNotifier.getCourses(isNew: true);
      categoryNotifier.getCategories();
      ustazListNotifier.getUstaz();
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
    final isSearching = ref.watch(queryProvider) == "";
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const ListTitle(title: "ምድብ"),
          isSearching
              ? ref.watch(categoryNotifierProvider).map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (index, context) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
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
                    loaded: (_) => SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: _.categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilteredCourses(
                                    "category",
                                    _.categories[index],
                                  ),
                                ),
                              );
                            },
                            child: Chip(
                              label: Text(
                                _.categories[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    empty: (_) => const Center(
                      child: Text("No Category"),
                    ),
                    error: (_) => Center(
                      child: Text(_.error.messege),
                    ),
                  )
              : const SizedBox(),
          // const ListTitle(title: "ኡስታዞች"),
          isSearching
              ? ref.watch(ustazNotifierProvider).map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (index, context) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
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
                    loaded: (_) => SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: _.ustazs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilteredCourses(
                                    "ustaz",
                                    _.ustazs[index],
                                  ),
                                ),
                              );
                            },
                            child: Chip(
                              label: Text(
                                _.ustazs[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    empty: (_) => const Center(
                      child: Text("No Ustaz"),
                    ),
                    error: (_) => Center(
                      child: Text(_.error.messege),
                    ),
                  )
              : const SizedBox(),
          // const ListTitle(title: "ኪታብ ደርሶች"),
          ref.watch(mainNotifierProvider).map(
                initial: (_) => const SizedBox(),
                loading: (_) => Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (index, context) => const CourseShimmer(),
                  ),
                ),
                loaded: (_) => Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await mainNotifier.getCourses(isNew: true);
                      await categoryNotifier.getCategories();
                      await ustazListNotifier.getUstaz();
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
                ),
                empty: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ምንም የለም"),
                    IconButton(
                      onPressed: () async {
                        await mainNotifier.getCourses(isNew: true);
                      },
                      icon: const Icon(Icons.refresh),
                    )
                  ],
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
