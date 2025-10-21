import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';

class QuizState {
  final bool isLoading, isSubmitting, initial, submitted;
  final List<Quiz> quizzes;
  final String? error, submittingError;

  QuizState({
    this.initial = true,
    this.isLoading = false,
    this.submitted = false,
    this.isSubmitting = false,
    this.quizzes = const [],
    this.error,
    this.submittingError,
  });

  Widget map({
    required Widget Function(QuizState _) loading,
    required Widget Function(QuizState _) loaded,
    required Widget Function(QuizState _) empty,
    required Widget Function(QuizState _) error,
    required Widget Function(QuizState _) submittedW,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && quizzes.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && quizzes.isEmpty && submitted) {
      return submittedW(this);
    } else if (!isLoading && quizzes.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  QuizState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? submitted,
    List<Quiz>? quizzes,
    String? error,
    String? submittingError,
  }) {
    return QuizState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? false,
      quizzes: quizzes ?? this.quizzes,
      error: error,
      submittingError: submittingError,
    );
  }
}
