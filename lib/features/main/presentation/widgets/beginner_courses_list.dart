import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/started_course_card.dart';
import 'package:shimmer/shimmer.dart';

import '../state/provider.dart';

class BeginnerCoursesList extends ConsumerStatefulWidget {
  const BeginnerCoursesList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BeginnerCoursesListState();
}

class _BeginnerCoursesListState extends ConsumerState<BeginnerCoursesList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ref.read(beginnerListProvider.notifier).getCourses();
      check();
    });
  }

  check() {
    ref.watch(sharedPrefProvider).then((pref) {
      bool show = pref.getBool("showBeginner") ?? true;
      ref.read(showBeginnerProvider.notifier).update((state) => show);
    });
  }

  @override
  Widget build(BuildContext context) {
    final show = ref.watch(showBeginnerProvider);
    return !show
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(230),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(10),
              height: 195,
              width: 200,
              child: ref.watch(beginnerListProvider).map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Shimmer.fromColors(
                        baseColor: Theme.of(context)
                            .chipTheme
                            .backgroundColor!
                            .withAlpha(150),
                        highlightColor:
                            Theme.of(context).chipTheme.backgroundColor!,
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
                    loaded: (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "የጀማሪ ደርሶች",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final pref = await ref.read(sharedPrefProvider);
                                pref.setBool("showBeginner", false);
                                ref
                                    .read(showBeginnerProvider.notifier)
                                    .update((state) => false);
                                // check();
                              },
                              child: const Icon(
                                Icons.close,
                                color: whiteColor,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _.courses.length,
                            itemBuilder: (context, index) {
                              return StartedCourseCard(
                                  courseModel: _.courses[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                    empty: (_) => const SizedBox(),
                    error: (_) => Center(
                      child: Text(_.error.messege),
                    ),
                  ),
            ),
          );
  }
}
