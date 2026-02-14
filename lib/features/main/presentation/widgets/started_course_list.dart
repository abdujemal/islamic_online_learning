import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/started.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/started_course_card.dart';
import 'package:shimmer/shimmer.dart';

import '../state/provider.dart';

class StartedCourseList extends ConsumerStatefulWidget {
  const StartedCourseList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StartedCourseListState();
}

class _StartedCourseListState extends ConsumerState<StartedCourseList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ref.watch(startedNotifierProvider).map(
            // initial: (_) => SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: 177,
            // ),
            loading: (_) => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 177,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Theme.of(context)
                      .chipTheme
                      .backgroundColor!
                      .withAlpha(150),
                  highlightColor: Theme.of(context).chipTheme.backgroundColor ??
                      Colors.white30,
                  child: Container(
                    height: 140,
                    width: 100,
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            loaded: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "የተጀመሩ ደርሶች",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _.courses.length < 5 ? _.courses.length : 5,
                      itemBuilder: (context, index) {
                        if (index < 4) {
                          return StartedCourseCard(
                            courseModel: _.courses[index],
                          );
                        } else {
                          return Center(
                            child: TextButton(
                              onPressed: () {
                                // ref
                                //     .read(menuIndexProvider.notifier)
                                //     .update((state) => 2);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Started()));
                              },
                              child: const Text(
                                "ሁሉንም አሳይ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            empty: (_) => const SizedBox(),
            error: (_) => Center(
              child: Text(_.error ?? ""),
            ),
          ),
    );
  }
}
