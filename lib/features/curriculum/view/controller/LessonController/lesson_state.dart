// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';

class LessonState {
  final Lesson? currentLesson;
  final AssignedCourse? currentCourse;
  final bool isDownloading;
  final String? pdfPath;
  final CancelToken? cancelToken;

  LessonState({
    this.currentLesson,
    this.currentCourse,
    this.cancelToken,
    this.isDownloading = false,
    this.pdfPath,
  });

  LessonState copyWith({
    Lesson? currentLesson,
    AssignedCourse? currentCourse,
    bool? isDownloading,
    String? pdfPath,
    CancelToken? cancelToken,
  }) {
    return LessonState(
      currentLesson: currentLesson ?? this.currentLesson,
      currentCourse: currentCourse ?? this.currentCourse,
      isDownloading: isDownloading ?? this.isDownloading,
      pdfPath: pdfPath ?? this.pdfPath,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }
}
