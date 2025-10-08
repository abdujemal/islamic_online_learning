import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_card.dart';

class PastLessonList extends ConsumerStatefulWidget {
  const PastLessonList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PastLessonListState();
}

class _PastLessonListState extends ConsumerState<PastLessonList> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(pastLessonStateProvider).map(
          loading: (state) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (state) =>
              Center(child: Text(state.error ?? "An error occurred")),
          loaded: (state) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: state.lessons.length,
                itemBuilder: (ctx, index) {
                  final lesson = state.lessons[index];
                  return LessonCard(
                    isCurrentLesson: false,
                    isPastLesson: true,
                    isLocked: false,
                    lesson: lesson,
                  );
                },
              ),
            ),
          ),
        );
  }
}
