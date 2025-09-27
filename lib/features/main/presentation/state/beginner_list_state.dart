import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class BeginnerListState {
  final bool isLoading;
  final List<CourseModel> courses;
  final String? error;

  BeginnerListState({
    this.isLoading = false,
    this.courses = const [],
    this.error,
  });

  BeginnerListState copyWith({
    bool? isLoading,
    List<CourseModel>? courses,
    String? error,
  }) {
    return BeginnerListState(
      isLoading: isLoading ?? this.isLoading,
      courses: courses ?? this.courses,
      error: error,
    );
  }
}
