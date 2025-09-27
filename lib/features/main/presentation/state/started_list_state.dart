import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class StartedListState {
  final bool isLoading;
  final List<CourseModel> courses;
  final String? error;

  StartedListState({
    this.isLoading = false,
    this.courses = const [],
    this.error,
  });

  Widget map({
    required Widget Function(StartedListState _) loading,
    required Widget Function(StartedListState _) loaded,
    required Widget Function(StartedListState _) empty,
    required Widget Function(StartedListState _) error,
  }) {
    if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && courses.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && courses.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  StartedListState copyWith({
    bool? isLoading,
    List<CourseModel>? courses,
    String? error,
  }) {
    return StartedListState(
      isLoading: isLoading ?? this.isLoading,
      courses: courses ?? this.courses,
      error: error,
    );
  }
}
