import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
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
    final state = ref.watch(assignedCoursesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentLessonIndex = authState.user?.group.lessonNum ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: List.generate(
          state.curriculum?.lessons != null
              ? state.curriculum!.lessons!.length +
                  ref
                      .read(assignedCoursesNotifierProvider.notifier)
                      .getDiscussionNumOfCurrentCourse(ref)
              : 0,
          (index) {
            if (ref
                .read(assignedCoursesNotifierProvider.notifier)
                .isIndexDiscussion(index, ref)) {
              final discussionData = ref
                  .read(assignedCoursesNotifierProvider.notifier)
                  .getDiscussionData(index, realIndex, ref);
              Lesson lesson = state.curriculum!.lessons![realIndex];
              final bool isLocked = (lesson.order > currentLessonIndex);

              final bool isCurrentLesson = lesson.order == currentLessonIndex;
              return DiscussionCard(
                discussionData: discussionData,
                isLocked: isLocked && !ref.read(assignedCoursesNotifierProvider.notifier).isTodayDiscussionDay(ref),
                isCurrent: isCurrentLesson && ref.read(assignedCoursesNotifierProvider.notifier).isTodayDiscussionDay(ref),
              );
            } else {
              realIndex++;
              // return Text("Lesson");
              Lesson lesson = state.curriculum!.lessons![realIndex];
              final bool isCurrentLesson = lesson.order == currentLessonIndex;
              final bool isPastLesson = lesson.order < currentLessonIndex;
              final bool isLocked = (lesson.order > currentLessonIndex);
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
