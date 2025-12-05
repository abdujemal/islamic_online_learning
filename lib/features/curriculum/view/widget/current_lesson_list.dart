import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/discussion_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/exam_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_card.dart';

class CurrentLessonList2 extends ConsumerStatefulWidget {
  final AssignedCourse assignedCourse;
  const CurrentLessonList2({super.key, required this.assignedCourse});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentLessonList2State();
}

class _CurrentLessonList2State extends ConsumerState<CurrentLessonList2> {
  @override
  Widget build(BuildContext context) {
    // int realIndex = -1;
    // int discussionIndex = -1;
    List<DiscussionData> discussionInUpToExam = [];
    LessonCardStatus status = LessonCardStatus.NONE;
    final state = ref.watch(assignedCoursesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    List<int> lessonStructure =
        ref.read(assignedCoursesNotifierProvider.notifier).getLessonStructure(
              authState.user!.group.noOfLessonsPerDay,
              authState.user!.group.courseStartDate!,
              state.curriculum!.lessons!.length,
            );
    final currentLessonNum = authState.courseRelatedData?.lessonNum ?? 0;
    final currentLessonIndexes = List.generate(
      authState.user!.group.noOfLessonsPerDay,
      (i) => currentLessonNum + i,
    );
    // print("currentLessonIndexes: $currentLessonIndexes");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: List.generate(
          state.curriculum!.lessons!.length,
          (index) {
            Lesson lesson = state.curriculum!.lessons![index];
            bool isCurrentLesson = currentLessonIndexes
                .contains(lesson.order); //lesson.order == currentLessonIndex;
            bool isPastLesson = lesson.order < currentLessonNum;
            final bool isLocked = (lesson.order > currentLessonIndexes.last);

            // if (isCurrentLesson && isTodayDiscussion) {
            //   isCurrentLesson = false;
            //   isPastLesson = true;
            // }
            // if (!isTodayLesson && isCurrentLesson) {
            //   isCurrentLesson = false;
            //   isPastLesson = true;
            // }

            final hasExam =
                ref.read(assignedCoursesNotifierProvider.notifier).hasExam(
                      lessonStructure,
                      state.curriculum!.lessons!.length,
                      index,
                      authState.user!.group.noOfLessonsPerDay,
                    );

            final hasDiscussion = ref
                .read(assignedCoursesNotifierProvider.notifier)
                .hasDiscussion(
                  lessonStructure,
                  state.curriculum!.lessons!.length,
                  index,
                );

            DiscussionData? discussionData;
            if (hasDiscussion) {
              discussionData = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .getDiscussionData2(index, lessonStructure);
              discussionInUpToExam.add(discussionData);
            }

            ExamData? examData;
            if (hasExam) {
              examData = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .getExamData(discussionInUpToExam, ref);
              discussionInUpToExam = [];
            }

            final bool isTodayDiscussion = ref
                .read(assignedCoursesNotifierProvider.notifier)
                .isTodayDiscussionDay(ref);

            final bool isTodayLesson = ref
                .read(assignedCoursesNotifierProvider.notifier)
                .isTodayLessonDay();

            final bool isTodayExam = ref
                .read(assignedCoursesNotifierProvider.notifier)
                .isTodayExamDay(
                  index,
                  lessonStructure,
                  state.curriculum!.lessons!.length,
                  authState.user!.group.noOfLessonsPerDay,
                );

            bool isDiscussionLocked = isLocked;
            bool isExamLocked = isLocked;

//

            // print("at $index => isTodayLesson: $isTodayLesson, isCurrentLesson: $isCurrentLesson");
            if (isTodayLesson) {
              status = LessonCardStatus.LESSON;
              if (isCurrentLesson) {
                isDiscussionLocked = true;
                isExamLocked = true;
              }
            }
            if (isTodayDiscussion) {
              status = LessonCardStatus.DISCUSSION;
              if (isCurrentLesson) {
                isDiscussionLocked = false;
                isExamLocked = true;
                isPastLesson = true;
              }
            }
            if (isTodayExam) {
              status = LessonCardStatus.EXAM;
              if (isCurrentLesson) {
                isPastLesson = true;
                isExamLocked = false;
                isDiscussionLocked = false;
              }
            }
            if (isCurrentLesson && status == LessonCardStatus.NONE) {
              isPastLesson = true;
            }

            final bnLessonNDis = ref
                .read(assignedCoursesNotifierProvider.notifier)
                .isBetweenLessonAndDiscussion(ref);

            if (isCurrentLesson && bnLessonNDis) {
              isDiscussionLocked = true;
              isExamLocked = true;
            }

            // if (authState.user!.group.courseNum ==
            //     widget.assignedCourse.order) {
            //  isCurrentLesson = false;
            // }

            // print("at $index => status: $status");

            // print("at $index isDiscussionLocked: $isDiscussionLocked");
            return Column(
              children: [
                LessonCard(
                  lesson: lesson,
                  isCurrentLesson:
                      isCurrentLesson && status == LessonCardStatus.LESSON,
                  isPastLesson:
                      isPastLesson, //&& status != LessonCardStatus.LESSON,
                  isLocked: isLocked, // && status != LessonCardStatus.LESSON,
                ),
                if (hasDiscussion)
                  DiscussionCard(
                    discussionData: discussionData!,
                    afterLesson: index,
                    isLocked:
                        isDiscussionLocked, //|| status != LessonCardStatus.DISCUSSION,
                    isCurrent: isCurrentLesson &&
                        status == LessonCardStatus.DISCUSSION,
                  ),
                if (hasExam)
                  ExamCard(
                    examData: examData!,
                    afterLesson: index,
                    discussionData: discussionData!,
                    isLastExam: index + 1 == state.curriculum!.lessons!.length,
                    isLocked:
                        isExamLocked, //|| status != LessonCardStatus.EXAM,
                    isCurrent:
                        isCurrentLesson && status == LessonCardStatus.EXAM,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
