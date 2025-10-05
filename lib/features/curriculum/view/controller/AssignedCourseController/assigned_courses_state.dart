import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';

class AssignedCoursesState {
  final bool isLoading, initial, isErrorAuth, isErrorPayment;
  final Curriculum? curriculum;
  final String? error;

  AssignedCoursesState({
    this.initial = true,
    this.isLoading = false,
    this.isErrorAuth = false,
    this.isErrorPayment = false,
    this.curriculum,
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
    }else if (!isLoading &&
        curriculum != null &&
        curriculum!.assignedCourses != null &&
        curriculum!.assignedCourses!.isNotEmpty) {
      return loaded(this);
    } else {
      print("yep");
      return SizedBox();
    }
  }

  AssignedCoursesState copyWith({
    bool? isLoading,
    bool? isErrorAuth,
    bool? isErrorPayment,
    Curriculum? curriculum,
    String? error,
  }) {
    return AssignedCoursesState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      curriculum: curriculum ?? this.curriculum,
      isErrorAuth: isErrorAuth ?? false,
      isErrorPayment: isErrorPayment ?? false,
      error: error,
    );
  }
}
