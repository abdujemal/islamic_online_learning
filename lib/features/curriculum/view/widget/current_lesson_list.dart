import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/discussion_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_card.dart';

class CurrentLessonList extends ConsumerStatefulWidget {
  const CurrentLessonList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentLessonListState();
}

class _CurrentLessonListState extends ConsumerState<CurrentLessonList> {
  @override
  Widget build(BuildContext context) {
    int realIndex = -1;
    int discussionIndex = -1;
    List<DiscussionData> discussionInUpToExam = [];
    final state = ref.watch(assignedCoursesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentLessonIndex = authState.courseRelatedData?.lessonNum ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: List.generate(
          state.curriculum?.lessons != null
              ? state.curriculum!.lessons!.length +
                  // 161 +
                  ref
                      .read(assignedCoursesNotifierProvider.notifier)
                      .getDiscussionNumOfCurrentCourse(ref)
              : 0,
          (index) {
            // print("realIndex: $realIndex");
            if (ref
                .read(assignedCoursesNotifierProvider.notifier)
                .isIndexDiscussion(index, ref)) {
              discussionIndex++;
              final discussionData = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .getDiscussionData(index, realIndex, discussionIndex, ref);
              // return Text("discussion ${realIndex}");
              Lesson lesson = state.curriculum!.lessons![realIndex];
              bool isLocked = (lesson.order > currentLessonIndex);
              bool isExamLocked = (lesson.order > currentLessonIndex);
              final bool isTodayDiscussion = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .isTodayDiscussionDay(ref);

              final bool isTodayExamDay = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .isTodayExamDay();
              final bool hasExam = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .isThisDiscussionHasExam(discussionIndex + 1, ref);
              final bool isCurrentLesson = lesson.order == currentLessonIndex;

              ExamData? examData;

              if (!hasExam) {
                discussionInUpToExam.add(discussionData);
              } else {
                discussionInUpToExam.add(discussionData);
                examData = ref
                    .read(assignedCoursesNotifierProvider.notifier)
                    .getExamData(discussionInUpToExam, ref);
                discussionInUpToExam = [];
              }

              // if (isCurrentLesson && !isTodayDiscussion) {
              //   isLocked = true;
              // }

              if (isCurrentLesson && !isTodayExamDay) {
                isExamLocked = true;
              }

              // return Column(
              //   children: [
              //     Text("discussion: r-$realIndex i-$index $isLocked"),
              //     if (hasExam) Text("Exam"),
              //     Text(
              //         "LessonFrom: ${discussionData.lessonFrom} to ${discussionData.lessonTo}")
              //   ],
              // );
              return DiscussionCard(
                isLastDiscussion: index + 1 ==
                    (state.curriculum?.lessons != null
                        ? state.curriculum!.lessons!.length +
                            ref
                                .read(assignedCoursesNotifierProvider.notifier)
                                .getDiscussionNumOfCurrentCourse(ref)
                        : 0),
                hasExam: hasExam,
                examData: examData,
                discussionData: discussionData,
                isExamLocked: isExamLocked,
                isExamCurrent: isCurrentLesson && isTodayExamDay,
                isLocked: isLocked, //&& !hasExam,
                isCurrent: isCurrentLesson && isTodayDiscussion,
              );
            } else {
              realIndex++;

              Lesson lesson = state.curriculum!.lessons![realIndex];
              final bool isTodayDiscussion = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .isTodayDiscussionDay(ref);
              final bool isTodayLesson = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .isTodayLessonDay();
              bool isCurrentLesson = lesson.order == currentLessonIndex;
              bool isPastLesson = lesson.order < currentLessonIndex;
              final bool isLocked = (lesson.order > currentLessonIndex);

              if (isCurrentLesson && isTodayDiscussion) {
                isCurrentLesson = false;
                isPastLesson = true;
              }
              if (!isTodayLesson && isCurrentLesson) {
                isCurrentLesson = false;
                isPastLesson = true;
              }

              // return Text("Lesson: r-$realIndex i-$index");
              return LessonCard(
                lesson: lesson,
                isCurrentLesson: isCurrentLesson,
                isPastLesson: isPastLesson,
                isLocked: isLocked,
              );
            }
          },
        ),
      ),
    );
  }
}
