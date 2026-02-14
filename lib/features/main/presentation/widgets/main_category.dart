import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/contents.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../pages/filtered_courses.dart';
import '../pages/ustazs.dart';

class MainCategories extends ConsumerStatefulWidget {
  const MainCategories({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainCategoriesState();
}

class _MainCategoriesState extends ConsumerState<MainCategories> {
  bool seeMore = false;
  double height = 0.0;

  int? noOfCourses;

  @override
  void initState() {
    super.initState();
    getNoOfCourses();
  }

  getNoOfCourses({String? ustaz, String? category}) async {
    try {
      // final aq = await FirebaseFirestore.instance
      //     .collection("Courses")
      //     .where('isDeleted', isEqualTo: true)
      //     .count()
      //     .get();

      // final aq1 =
      //     await FirebaseFirestore.instance.collection("Courses").count().get();
      final num = await DatabaseHelper().getRowCount("Courses");

      noOfCourses = num;
      setState(() {});
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(categoryNotifierProvider).map(
          // initial: (_) => const SizedBox(),
          loading: (_) => Wrap(
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
                          labelPadding: const EdgeInsets.all(0),
                          side: BorderSide.none,
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
                        highlightColor:
                            Theme.of(context).chipTheme.backgroundColor ??
                                Colors.white30,
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
          ),
          loaded: (_) {
            List<String> categories = ["ኡስታዞች", "ማውጫ", ..._.categories];
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40,
                  ),
                  child: SizedBox(
                    height: seeMore ? null : 50,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Wrap(
                        // height: 50,
                        children: List.generate(
                          // itemCount: categories.length,
                          // scrollDirection: Axis.horizontal,
                          categories.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => const Ustazs(),
                                    ),
                                  );
                                } else if (index == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => const Contents(),
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
                                labelPadding: const EdgeInsets.all(0),
                                clipBehavior: Clip.antiAlias,
                                side: BorderSide.none,
                                avatar: index == 0
                                    ? Image.asset('assets/teacher.png')
                                    : index == 1
                                        ? const Icon(
                                            Icons.content_paste_outlined,
                                            color: whiteColor,
                                          )
                                        : null,
                                backgroundColor: index == 0 || index == 1
                                    ? primaryColor
                                    : null,
                                label: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: index == 0 || index == 1
                                        ? whiteColor
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 7,
                  child: Text(
                    "${noOfCourses ?? "..."} ደርሶች",
                    style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final wrapHeight = renderBox.size.height;
                        height = wrapHeight;
                        print('Wrap Height: $wrapHeight');
                      });
                      setState(() {
                        seeMore = !seeMore;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          !seeMore
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Colors.blue,
                        ),
                        Text(
                          seeMore ? "መልሰው" : "ሁሉንም አሳይ",
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          empty: (_) => const Center(
            child: Text("እባክዎ ኢንተርኔት አብርተው ድጋሚ ይሞክሩ።"),
          ),
          error: (_) => Center(
            child: Text(_.error ?? ""),
          ),
        );
  }
}
