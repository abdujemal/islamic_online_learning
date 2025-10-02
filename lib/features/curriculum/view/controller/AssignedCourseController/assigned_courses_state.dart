import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';

class AssignedCoursesState {
  final bool isLoading, initial;
  final List<AssignedCourse> assignedCourses;
  final String? error;

  AssignedCoursesState({
    this.initial = true,
    this.isLoading = false,
    this.assignedCourses = const [],
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
    } else if (!isLoading && assignedCourses.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && assignedCourses.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  AssignedCoursesState copyWith({
    bool? isLoading,
    List<AssignedCourse>? assignedCourses,
    String? error,
  }) {
    return AssignedCoursesState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      assignedCourses: assignedCourses ?? this.assignedCourses,
      error: error,
    );
  }
}
