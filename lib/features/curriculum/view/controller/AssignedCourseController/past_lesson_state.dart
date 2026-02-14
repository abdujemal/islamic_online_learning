import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';

class PastLessonState {
  final bool isLoading, initial;
  final List<Lesson> lessons;
  final String? error;

  PastLessonState({
    this.isLoading = false,
    this.initial = true,
    this.lessons = const [],
    this.error,
  });

  Widget map({
    required Widget Function(PastLessonState _) loading,
    required Widget Function(PastLessonState _) loaded,
    required Widget Function(PastLessonState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && lessons.isNotEmpty) {
      return loaded(this);
    } else {
      return SizedBox();
    }
  }

  PastLessonState copyWith({
    bool? isLoading,
    List<Lesson>? lessons,
    String? error,
  }) {
    return PastLessonState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      lessons: lessons ?? this.lessons,
      error: error,
    );
  }
}
