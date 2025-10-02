import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';

class CurriculumState {
  final bool isLoading, initial;
  final List<Curriculum> curriculums;
  final String? error;

  CurriculumState({
    this.initial = true,
    this.isLoading = false,
    this.curriculums = const [],
    this.error,
  });

  Widget map({
    required Widget Function(CurriculumState _) loading,
    required Widget Function(CurriculumState _) loaded,
    required Widget Function(CurriculumState _) empty,
    required Widget Function(CurriculumState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && curriculums.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && curriculums.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  CurriculumState copyWith({
    bool? isLoading,
    List<Curriculum>? curriculums,
    String? error,
  }) {
    return CurriculumState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      curriculums: curriculums ?? this.curriculums,
      error: error,
    );
  }
}

