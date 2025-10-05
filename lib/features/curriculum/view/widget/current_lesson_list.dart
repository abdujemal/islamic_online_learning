import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
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
    final state = ref.watch(assignedCoursesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentLessonIndex = authState.user?.group.lessonNum ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: List.generate(
          state.curriculum?.lessons?.length ?? 0,
          (index) {
            Lesson lesson = state.curriculum!.lessons![index];
            final bool isCurrentLesson = lesson.order == currentLessonIndex;
            final bool isPastLesson = lesson.order < currentLessonIndex;
            final bool isLocked = (lesson.order > currentLessonIndex);

            return LessonCard(
              lesson: lesson,
              isCurrentLesson: isCurrentLesson,
              isPastLesson: isPastLesson,
              isLocked: isLocked,
            );
          },
        ),
      ),
    );
  }
}
