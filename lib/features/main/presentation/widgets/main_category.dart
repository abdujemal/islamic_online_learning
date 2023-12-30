import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return ref.watch(categoryNotifierProvider).map(
          initial: (_) => const SizedBox(),
          loading: (_) => Wrap(
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
                          labelPadding: const EdgeInsets.all(0),
                          clipBehavior: Clip.antiAlias,
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
                            Theme.of(context).chipTheme.backgroundColor!,
                        child: GestureDetector(
                          onTap: () {
                            if (index == 0) {}
                          },
                          child: const Chip(
                            labelPadding: EdgeInsets.all(0),
                            clipBehavior: Clip.antiAlias,
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
            List<String> categories = ["ኡስታዞች", ..._.categories];
            return Wrap(
              // height: 50,
              children: List.generate(
                // itemCount: categories.length,
                // scrollDirection: Axis.horizontal,
                categories.length,
                (index) => Padding(
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
                      labelPadding: const EdgeInsets.all(0),
                      clipBehavior: Clip.antiAlias,
                      side: BorderSide.none,
                      avatar:
                          index == 0 ? Image.asset('assets/teacher.png') : null,
                      backgroundColor: index == 0 ? primaryColor : null,
                      label: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == 0 ? whiteColor : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          empty: (_) => const Center(
            child: Text("እባክዎ ኢንተርኔት አብርተው ድጋሚ ይሞክሩ።"),
          ),
          error: (_) => Center(
            child: Text(_.error.messege),
          ),
        );
  }
}
