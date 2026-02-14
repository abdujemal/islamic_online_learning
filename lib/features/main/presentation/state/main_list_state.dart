import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class MainListState {
  final bool isLoading;
  final List<CourseModel> courses;
  final bool noMoreToLoad, isLoadingMore, initial;
  final String? error;

  MainListState({
    this.isLoading = false,
    this.courses = const [],
    this.noMoreToLoad = false,
    this.isLoadingMore = false,
    this.error,
    this.initial = true,
  });

  Widget map({
    required Widget Function(MainListState _) loading,
    required Widget Function(MainListState _) loaded,
    required Widget Function(MainListState _) empty,
    required Widget Function(MainListState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
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

  MainListState copyWith({
    bool? isLoading,
    List<CourseModel>? courses,
    bool? noMoreToLoad,
    isLoadingMore,
    String? error,
  }) {
    return MainListState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      courses: courses ?? this.courses,
      noMoreToLoad: noMoreToLoad ?? this.noMoreToLoad,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}
