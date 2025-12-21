import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';

class PrerequisiteTestState {
  final bool isLoading, initial;
  final List<Quiz> quizzes;
  final String? error;

  PrerequisiteTestState({
    this.initial = true,
    this.isLoading = false,
    this.quizzes = const [],
    this.error,
  });

  Widget map({
    required Widget Function(PrerequisiteTestState _) loading,
    required Widget Function(PrerequisiteTestState _) loaded,
    required Widget Function(PrerequisiteTestState _) empty,
    required Widget Function(PrerequisiteTestState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && quizzes.isNotEmpty) {
      return loaded(this);
    }  else if (!isLoading && quizzes.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  PrerequisiteTestState copyWith({
    bool? isLoading,
    List<Quiz>? quizzes,
    String? error,
  }) {
    return PrerequisiteTestState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      quizzes: quizzes ?? this.quizzes,
      error: error,
    );
  }
}
