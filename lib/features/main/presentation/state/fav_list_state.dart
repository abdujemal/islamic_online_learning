
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class FavListState {
  final bool isLoading;
  final List<CourseModel> courses;
  final String? error;

  FavListState({
    this.isLoading = false,
    this.courses = const [],
    this.error,
  });

  FavListState copyWith({
    bool? isLoading,
    List<CourseModel>? courses,
    String? error,
  }) {
    return FavListState(
      isLoading: isLoading ?? this.isLoading,
      courses: courses ?? this.courses,
      error: error,
    );
  }
}
