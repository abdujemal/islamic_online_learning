import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/quiz/model/question.dart';
import 'package:islamic_online_learning/features/quiz/model/test_attempt.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';

class QuestionState {
  final bool isLoading, isSubmitting, initial, submitted, isThereUnfinishedTest;
  final List<Question> questions;
  final List<QA> answers;
  final TestAttempt? testAttempt;
  final String? error, submittingError;
  final int? givenTime;

  QuestionState({
    this.initial = true,
    this.isLoading = false,
    this.submitted = false,
    this.isSubmitting = false,
    this.isThereUnfinishedTest = false,
    this.questions = const [],
    this.answers = const [],
    this.givenTime,
    this.error,
    this.testAttempt,
    this.submittingError,
  });

  Widget map({
    required Widget Function(QuestionState _) loading,
    required Widget Function(QuestionState _) loaded,
    required Widget Function(QuestionState _) testStarted,
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
    } else if (!isLoading && questions.isNotEmpty && testAttempt == null) {
      return loaded(this);
    } else if (!isLoading && questions.isNotEmpty && testAttempt != null) {
      return testStarted(this);
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
    bool? isThereUnfinishedTest,
    List<Question>? questions,
    List<QA>? answers,
    String? error,
    TestAttempt? testAttempt,
    int? givenTime,
    String? submittingError,
  }) {
    return QuestionState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? false,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      error: error,
      submittingError: submittingError,
      testAttempt: testAttempt ?? this.testAttempt,
      givenTime: givenTime ?? this.givenTime,
      isThereUnfinishedTest:
          isThereUnfinishedTest ?? this.isThereUnfinishedTest,
    );
  }
}
