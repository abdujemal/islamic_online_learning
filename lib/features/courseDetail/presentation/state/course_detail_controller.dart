import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class CourseDetailNotifier extends StateNotifier<bool> {
  CourseDetailNotifier() : super(true);

  CourseModel? courseModel;

  void setCourseModel(CourseModel model) {
    courseModel = model;
  }
}

final courseDetailProvider = StateNotifierProvider<CourseDetailNotifier, bool>(
  (ref) => CourseDetailNotifier(),
);
