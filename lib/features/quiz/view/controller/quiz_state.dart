import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';

class QuizState {
  final bool isLoading, isSubmitting, initial;
  final List<Quiz> quizzes;
  final String? error;

  QuizState({
    this.initial = true,
    this.isLoading = false,
    this.isSubmitting = false,
    this.quizzes = const [],
    this.error,
  });

  Widget map({
    required Widget Function(QuizState _) loading,
    required Widget Function(QuizState _) loaded,
    required Widget Function(QuizState _) empty,
    required Widget Function(QuizState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && quizzes.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && quizzes.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  QuizState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Quiz>? quizzes,
    String? error,
  }) {
    return QuizState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      quizzes: quizzes ?? this.quizzes,
      error: error,
    );
  }
}
