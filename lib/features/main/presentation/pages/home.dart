// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_call_super

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/contents.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_links/uni_links.dart';

import 'package:islamic_online_learning/features/main/presentation/pages/ustazs.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/beginner_courses_list.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/main_category.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/started_course_list.dart';

import '../../../../core/constants.dart';
import '../../../courseDetail/presentation/pages/course_detail.dart';
import '../state/category_list_notifier.dart';
import '../state/main_list_notifier.dart';
import '../state/provider.dart';
import '../widgets/course_item.dart';
import '../widgets/course_shimmer.dart';
import '../widgets/the_end.dart';

class Home extends ConsumerStatefulWidget {
  final GlobalKey courseTitle;
  final GlobalKey courseUstaz;
  final GlobalKey courseCategory;

  const Home({
    super.key,
    required this.courseTitle,
    required this.courseUstaz,
    required this.courseCategory,
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

  bool showFloatingBtn = false;

  @override
  initState() {
    super.initState();
    categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    mainNotifier = ref.read(mainNotifierProvider.notifier);
    // startedListNotifier = ref.read(startedNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainNotifier
          .getCourses(
        isNew: true,
        context: context,
      )
          .then((value) {
        categoryNotifier.getCategories();
      });
      ref.read(beginnerListProvider.notifier).getCourses();
      ref.watch(startedNotifierProvider.notifier).getCouses();

      FirebaseDynamicLinks.instance.getInitialLink().then((value) {
        print("link:- ${value?.link}");
        print("Segments: ${value?.link.pathSegments}");
        if (value?.link.pathSegments.contains("courses") ?? false) {
          String id = Uri.decodeFull(value?.link.toString() ?? "")
              .split("/")
              .last
              .replaceAll("courses?id=", "")
              .replaceAll("+", " ");
          print("id: $id");
          // String? id = widget.initialLink!.link.queryParameters["id"];

          getCourseAndRedirect(id);
        }
      });
    });

    linkStream.listen((event) {
      if (event != null) {
        Uri link = Uri.parse(event);
        print("link:- ${link.toString()}");
        print("Segments: ${link.pathSegments}");
        if (link.pathSegments.contains("courses")) {
          String id = Uri.decodeFull(link.toString())
              .split("/")
              .last
              .replaceAll("courses?id=", "")
              .replaceAll("+", " ");
          print("id: $id");

          getCourseAndRedirect(id);
        }
      }
    }).onError((e) {
      toast(
        e.toString(),
        ToastType.error,
        context,
        isLong: true,
      );
    });
  }

  getCourseAndRedirect(String? id) async {
    print("course id:$id");
    if (id == null) {
      return;
    }
    if (id.isEmpty) {
      return;
    }
    final res = await ref
        .read(mainNotifierProvider.notifier)
        .getSingleCourse(id, context, fromCloud: true);
    print("wait ... ");
    if (res != null) {
      print("redirecting ... ");
      if (mounted) {
        print("go");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetail(cm: res),
          ),
        );
      }
    } else {
      if (mounted) {
        toast("ስህተት ተፈጥሯል።", ToastType.error, context);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isSearching) {
        await mainNotifier.getCourses(
          context: context,
          isNew: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isSearching = ref.watch(queryProvider) == "";
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ref.watch(mainNotifierProvider).map(
                initial: (_) => const SizedBox(),
                loading: (_) => ListView.builder(
                  itemCount: isSearching ? 10 + 1 : 10,
                  itemBuilder: (context, index) {
                    if (index == 0 && isSearching) {
                      return Wrap(
                        // height: 50,
                        children: List.generate(
                          // itemCount: 5,
                          // scrollDirection: Axis.horizontal,
                          4,
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
                                      labelPadding: const EdgeInsets.all(0),
                                      side: BorderSide.none,
                                      label: const Text(
                                        "ኡስታዞች",
                                        style: TextStyle(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : index == 1
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const Contents(),
                                            ),
                                          );
                                        },
                                        child: const Chip(
                                          avatar: Icon(
                                            Icons.content_paste_outlined,
                                            color: whiteColor,
                                          ),
                                          backgroundColor: primaryColor,
                                          labelPadding: EdgeInsets.all(0),
                                          side: BorderSide.none,
                                          label: Text(
                                            "ማውጫ",
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
                                            labelPadding: EdgeInsets.all(0),
                                            side: BorderSide.none,
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
                        await mainNotifier.getCourses(isNew: true,context: context,);
                        await categoryNotifier.getCategories();
                        await ref
                            .read(beginnerListProvider.notifier)
                            .getCourses();
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
                            _.courses[index < 5 ? index - 2 : index - 3],
                            index: index < 5 ? index - 2 : index - 3,
                            courseCategory: widget.courseCategory,
                            courseTitle: widget.courseTitle,
                            courseUstaz: widget.courseUstaz,
                          );
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
                          await mainNotifier.getCourses(isNew: true, context: context,);
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
                    duration: const Duration(milliseconds: 500),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
