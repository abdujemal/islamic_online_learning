import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/auth/model/curriculum_score.dart';

class CertificatesState {
  final bool isLoading, initial;
  final List<CurriculumScore> curriculumScores;
  final String? error;

  CertificatesState({
    this.initial = true,
    this.isLoading = false,
    this.curriculumScores = const [],
    this.error,
  });

  Widget map({
    required Widget Function(CertificatesState _) loading,
    required Widget Function(CertificatesState _) loaded,
    required Widget Function(CertificatesState _) empty,
    required Widget Function(CertificatesState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && curriculumScores.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && curriculumScores.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  CertificatesState copyWith({
    bool? isLoading,
    List<CurriculumScore>? curriculumScores,
    String? error,
  }) {
    return CertificatesState(
      initial: false,
      isLoading: isLoading ?? this.isLoading,
      curriculumScores: curriculumScores ?? this.curriculumScores,
      error: error,
    );
  }
}
