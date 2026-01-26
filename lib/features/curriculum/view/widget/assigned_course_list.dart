import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:islamic_online_learning/features/auth/model/monthly_score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/assigned_course_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_shimmer.dart';

class AssignedCourseList extends ConsumerStatefulWidget {
  const AssignedCourseList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignedCourseListState();
}

class _AssignedCourseListState extends ConsumerState<AssignedCourseList> {
  final ScrollController _lessonScrollController = ScrollController();
  // int? currentCourseIndex;
  // int? lessonIndex;

  final GlobalKey _courseCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final authState = ref.watch(authNotifierProvider);
      // currentCourseIndex = authState.user?.group.courseNum ?? 0;
      // lessonIndex = authState.user?.group.lessonNum ?? 0;

      setState(() {});
      // Scroll to current course
      // ref.listen<AssignedCoursesState>(
      //   assignedCoursesNotifierProvider,
      //   (previous, next) {
      //     if (previous?.isLoading == true &&
      //         next.isLoading == false &&
      //         next.curriculum != null) {
      //       _scrollToCurrentLesson(lessonIndex!, currentCourseIndex!);
      //     }
      //   },
      // );
    });
  }

  void _scrollToCurrentLesson(int currentLessonIndex, int currentCourseIndex) {
    if (_lessonScrollController.hasClients) {
      final numOfDiscussions = ref
          .read(assignedCoursesNotifierProvider.notifier)
          .getNumOfDiscussionUpToIndex(currentLessonIndex, ref);
      final numOfExams = ref
          .read(assignedCoursesNotifierProvider.notifier)
          .numOfExamsUpToIndex(currentLessonIndex, ref);
      List<Rest> rests = ref.read(assignedCoursesNotifierProvider).rests;
      rests = rests
          .where((rest) =>
              rest.afterLesson != null &&
              rest.afterLesson! < currentLessonIndex)
          .toList();
      List<MonthlyScore> monthlyScores =
          ref.read(assignedCoursesNotifierProvider).monthlyScores;
      monthlyScores = monthlyScores
          .where((score) => score.endLesson < currentLessonIndex)
          .toList();
      List<Confusion> confusions =
          ref.read(assignedCoursesNotifierProvider).confusions;
      confusions =
          confusions.where((con) => con.onLesson < currentLessonIndex).toList();
      print("discussions: $numOfDiscussions");
      print("exams: $numOfExams");
      final offset = (currentCourseIndex * 104.0) +
          (currentLessonIndex * 123) +
          (numOfDiscussions * 76.0) +
          (numOfExams * 76.0) +
          (rests.length * 123) +
          (monthlyScores.length * 123) +
          (confusions.length * 123);
      _lessonScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      scrollingDone = true;
      print("Scrolled to ...");
    }
  }

  bool scrollingDone = false;
  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendarConfig.now();
    final arabicDate = "${hijri.fullDate()} هـ";
    // final theme = ref.watch(themeProvider);
    final state = ref.watch(assignedCoursesNotifierProvider);
    // print("${state.curriculum != null} && ${scrollingDone}");
    final authState = ref.watch(authNotifierProvider);

    int currentCourseIndex = authState.courseRelatedData?.courseNum ?? 0;
    int lessonIndex = authState.courseRelatedData?.lessonNum ?? 0;

    if (state.curriculum != null && !scrollingDone) {
      Future.delayed(
        Duration(seconds: 1),
        () => _scrollToCurrentLesson(lessonIndex, currentCourseIndex),
      );
    }

    // if (state.i) {
    //   return Center(
    //     child: Text("ምንም የለም"),
    //   );
    // }

    return Expanded(
      child: ref.watch(assignedCoursesNotifierProvider).map(
            loading: (_) => ListView(
              children: [
                Column(
                  children: List.generate(
                    10,
                    (index) => LessonShimmer(),
                  ),
                ),
              ],
            ),
            loaded: (_) => RefreshIndicator(
              onRefresh: () async {
                scrollingDone = false;
                await ref
                    .read(assignedCoursesNotifierProvider.notifier)
                    .getCurriculum(context);
                // currentCourseIndex = ref
                //         .read(authNotifierProvider)
                //         .courseRelatedData
                //         ?.courseNum ??
                //     currentCourseIndex;
                // lessonIndex = ref
                //         .read(authNotifierProvider)
                //         .courseRelatedData
                //         ?.courseNum ??
                //     lessonIndex;
                // print('''
                //   {
                //     currentCourseIndex: $currentCourseIndex,
                //     lessonIndex: $lessonIndex
                //   }
                // ''');
              },
              child: ListView.builder(
                  controller: _lessonScrollController,
                  itemCount: (_.curriculum?.assignedCourses?.length ?? 0) + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Text(
                            "السلام عليكم ورحمة الله وبركاته",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            arabicDate,
                            textAlign: TextAlign.center,
                            // style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: ref
                                .read(assignedCoursesNotifierProvider.notifier)
                                .getProgress(ref),
                            minHeight: 16,
                            color: primaryColor,
                            backgroundColor: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else {
                      final bool isCurrentCourse =
                          (index - 1) == currentCourseIndex;
                      // final bool isPastCourse = (index - 1)< currentCourseIndex;
                      final bool isFutureCourse =
                          (index - 1) > currentCourseIndex;

                      return AssignedCourseCard(
                        key: index == 0 ? _courseCardKey : null,
                        isCurrentCourse: isCurrentCourse,
                        isFutureCourse: isFutureCourse,
                        assignedCourse:
                            _.curriculum!.assignedCourses![index - 1],
                      );
                    }
                  }),
            ),
            empty: (_) => Center(
              child: Text("ምንም የለም"),
            ),
            error: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _.error ?? "",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      scrollingDone = false;
                      await ref
                          .read(assignedCoursesNotifierProvider.notifier)
                          .getCurriculum(context);
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),
          ),
    );
  }
}
