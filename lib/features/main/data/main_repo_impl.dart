// ignore_for_file: void_checks, avoid_print

import 'package:dartz/dartz.dart';
import 'package:islamic_online_learning/features/main/data/model/faq_model.dart';

import '../../../core/failure.dart';
import '../../../core/typedef.dart';
import '../domain/main_repo.dart';
import 'model/course_model.dart';
import 'main_data_src.dart';

class IMainRepo extends MainRepo {
  final MainDataSrc mainDataSrc;
  IMainRepo(this.mainDataSrc);

  @override
  FutureEither<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
    SortingMethod method,
  ) async {
    try {
      final res = await mainDataSrc.getCourses(isNew, key, val, method);
      return right(res);
    } catch (e) {
      print(e.toString());
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<String>> getUstazs() async {
    try {
      final res = await mainDataSrc.getUstazs();
      return right(res);
    } catch (e) {
      print(e.toString());
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<String>> getCategories() async {
    try {
      final res = await mainDataSrc.getCategories();
      return right(res);
    } catch (e) {
      print(e.toString());
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<CourseModel>> getFavoriteCourses() async {
    try {
      final res = await mainDataSrc.getFavoriteCourses();
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<CourseModel>> searchCourses(
      String query, int? numOfElt) async {
    try {
      final res = await mainDataSrc.searchCourses(query, numOfElt);
      return right(res);
    } catch (e) {
      print(e.toString());
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<int> saveCourse(CourseModel courseModel) async {
    try {
      final id = await mainDataSrc.saveTheCourse(courseModel);
      return right(id);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<void> deleteCourse(int id) async {
    try {
      await mainDataSrc.deleteCourse(id);
      return right("");
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<FAQModel>> getFAQ() async {
    try {
      final res = await mainDataSrc.getFAQ();
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<CourseModel?> getSingleCourse(String courseId) async {
    try {
      final res = await mainDataSrc.getSingleCourse(courseId);

      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<CourseModel>> getSavedCourses() async {
    try {
      final res = await mainDataSrc.getSavedCourses();

      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<CourseModel>> getStartedCourses() async {
    try {
      final res = await mainDataSrc.getStartedCourses();

      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<CourseModel>> getBeginnerCourses() async {
    try {
      final res = await mainDataSrc.getBeginnerCourses();

      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }
}
