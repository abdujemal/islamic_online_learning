import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/quiz/model/question.dart';

class QuestionState {
  final bool isLoading, isSubmitting, initial, submitted;
  final List<Question> questions;
  final String? error, submittingError;

  QuestionState({
    this.initial = true,
    this.isLoading = false,
    this.submitted = false,
    this.isSubmitting = false,
    this.questions = const [],
    this.error,
    this.submittingError,
  });

  Widget map({
    required Widget Function(QuestionState _) loading,
    required Widget Function(QuestionState _) loaded,
    required Widget Function(QuestionState _) empty,
    required Widget Function(QuestionState _) error,
    required Widget Function(QuestionState _) submittedW,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && questions.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && questions.isEmpty && submitted) {
      return submittedW(this);
    } else if (!isLoading && questions.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  QuestionState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? submitted,
    List<Question>? questions,
    String? error,
    String? submittingError,
  }) {
    return QuestionState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? false,
      questions: questions ?? this.questions,
      error: error,
      submittingError: submittingError,
    );
  }
}
