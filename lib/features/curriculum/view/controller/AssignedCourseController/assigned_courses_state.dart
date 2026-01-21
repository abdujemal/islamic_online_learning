import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/auth/model/monthly_score.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';
import 'package:islamic_online_learning/features/quiz/model/test_attempt.dart';
import 'package:islamic_online_learning/features/meeting/model/discussion.dart';

class AssignedCoursesState {
  final bool isLoading, initial, isErrorAuth, isErrorPayment;
  final Curriculum? curriculum;
  final List<Score> scores;
  final List<MonthlyScore> monthlyScores;
  final List<TestAttempt> testAttempts;
  final List<Discussion> discussions;
  final List<Rest> rests;
  final int? expandedCourseOrder;
  final String? error;

  AssignedCoursesState({
    this.initial = true,
    this.isLoading = false,
    this.isErrorAuth = false,
    this.isErrorPayment = false,
    this.scores = const [],
    this.monthlyScores = const [],
    this.testAttempts = const [],
    this.discussions = const [],
    this.rests = const [],
    this.curriculum,
    this.expandedCourseOrder,
    this.error,
  });

  Widget map({
    required Widget Function(AssignedCoursesState _) loading,
    required Widget Function(AssignedCoursesState _) loaded,
    required Widget Function(AssignedCoursesState _) empty,
    required Widget Function(AssignedCoursesState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading &&
        curriculum != null &&
        curriculum!.assignedCourses != null &&
        curriculum!.assignedCourses!.isEmpty) {
      return empty(this);
    } else if (!isLoading &&
        curriculum != null &&
        curriculum!.assignedCourses != null &&
        curriculum!.assignedCourses!.isNotEmpty) {
      return loaded(this);
    } else {
      return SizedBox();
    }
  }

  AssignedCoursesState copyWith({
    bool? isLoading,
    bool? isErrorAuth,
    bool? isErrorPayment,
    Curriculum? curriculum,
    List<Score>? scores,
    List<MonthlyScore>? monthlyScores,
    List<TestAttempt>? testAttempts,
    List<Discussion>? discussions,
    List<Rest>? rests,
    int? expandedCourseOrder,
    String? error,
  }) {
    return AssignedCoursesState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      curriculum: curriculum ?? this.curriculum,
      scores: scores ?? this.scores,
      monthlyScores: monthlyScores ?? this.monthlyScores,
      testAttempts: testAttempts ?? this.testAttempts,
      discussions: discussions ?? this.discussions,
      isErrorAuth: isErrorAuth ?? false,
      isErrorPayment: isErrorPayment ?? false,
      rests: rests ?? this.rests,
      expandedCourseOrder: expandedCourseOrder ?? this.expandedCourseOrder,
      error: error,
    );
  }
}
