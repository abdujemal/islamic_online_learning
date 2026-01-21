import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/model/monthly_score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/discussion_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/exam_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/monthly_score_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/rest_card.dart';

class CurrentLessonList extends ConsumerStatefulWidget {
  final AssignedCourse assignedCourse;
  const CurrentLessonList({super.key, required this.assignedCourse});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentLessonListState();
}

class _CurrentLessonListState extends ConsumerState<CurrentLessonList> {
  @override
  Widget build(BuildContext context) {
    // int realIndex = -1;
    // int discussionIndex = -1;
    List<DiscussionData> discussionInUpToExam = [];
    LessonCardStatus status = LessonCardStatus.NONE;
    final state = ref.watch(assignedCoursesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    List<dynamic> lessonStructureWRest = ref
        .read(assignedCoursesNotifierProvider.notifier)
        .getLessonStructureWRest(
          authState.user!.group.courseStartDate!,
          state.curriculum!.lessons!.length,
          authState.user!.group.noOfLessonsPerDay,
          state.rests,
        );
    List<Rest> rests = lessonStructureWRest[1] as List<Rest>;
    List<MonthlyScore> monthlyScores = state.monthlyScores;
    List<int> lessonStructure = lessonStructureWRest[0] as List<int>;
    final currentLessonNum = authState.courseRelatedData?.lessonNum ?? 0;
    final currentLessonIndexes = List.generate(
      authState.user!.group.noOfLessonsPerDay,
      (i) => currentLessonNum + i,
    );
    final notOpenedYet =
        DateTime.now().compareTo(authState.user!.group.startDate!) == -1;
    // print("currentLessonIndexes: $currentLessonIndexes");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        if (notOpenedYet)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "ሰኞ ቂራት ይጀመራል። ኢንሻአላህ!",
              textAlign: TextAlign.center,
            ),
          ),
        ...List.generate(
          state.curriculum!.lessons!.length,
          (index) {
            Lesson lesson = state.curriculum!.lessons![index];
            bool isCurrentLesson = currentLessonIndexes
                .contains(lesson.order); //lesson.order == currentLessonIndex;
            bool isPastLesson = lesson.order < currentLessonNum;
            bool isLocked = (lesson.order > currentLessonIndexes.last);

            final rest = rests.where((e) => e.afterLesson == index).firstOrNull;

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
            // bool isExamLocked = isLocked;

//

            // print("at $index => isTodayLesson: $isTodayLesson, isCurrentLesson: $isCurrentLesson");
            if (isTodayLesson) {
              status = LessonCardStatus.LESSON;
              if (isCurrentLesson) {
                isDiscussionLocked = true;
                // isExamLocked = true;
              }
            }
            if (isTodayDiscussion) {
              status = LessonCardStatus.DISCUSSION;
              if (isCurrentLesson) {
                isDiscussionLocked = false;
                // isExamLocked = true;
                isPastLesson = true;
              }
            }
            if (isTodayExam) {
              status = LessonCardStatus.EXAM;
              if (isCurrentLesson) {
                isPastLesson = true;
                // isExamLocked = false;
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
              // isExamLocked = true;
            }

            if (notOpenedYet) {
              isLocked = true;
              isCurrentLesson = false;
              isPastLesson = false;
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
                if (rest != null)
                  RestCard(
                    rest: rest,
                    isLocked: isLocked,
                  ),
                // Text("Rest date:${rest.date} for: ${rest.amount}"),
                if (hasDiscussion && rest == null)
                  DiscussionCard(
                    examData: examData,
                    assignedCourse: widget.assignedCourse,
                    discussionData: discussionData!,
                    afterLesson: index,
                    isLocked:
                        isDiscussionLocked, //|| status != LessonCardStatus.DISCUSSION,
                    isCurrent: isCurrentLesson &&
                        status == LessonCardStatus.DISCUSSION,
                  ),
                if (hasExam && rest == null)
                  ExamCard(
                    examData: examData!,
                    afterLesson: index,
                    discussionData: discussionData!,
                    isLastExam: index + 1 == state.curriculum!.lessons!.length,
                    isLocked:
                        isDiscussionLocked, //|| status != LessonCardStatus.EXAM,
                    isCurrent: isCurrentLesson &&
                        status == LessonCardStatus.DISCUSSION,
                  ),
                if (monthlyScores.any((ms) => ms.endLesson == index))
                  MonthlyScoreCard(
                    monthlyScore:
                        monthlyScores.firstWhere((ms) => ms.endLesson == index),
                  ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
