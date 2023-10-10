import 'package:dartz/dartz.dart';

import '../../../core/failure.dart';
import '../../../core/typedef.dart';
import '../domain/main_repo.dart';
import 'course_model.dart';
import 'main_data_src.dart';

class IMainRepo extends MainRepo {
  final MainDataSrc mainDataSrc;
  IMainRepo(this.mainDataSrc);

  @override
  FutureEither<List<CourseModel>> getCourses(bool isNew) async {
    try {
      final res = await mainDataSrc.getCourses(isNew);
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
  FutureEither<List<CourseModel>> getCoursesHistory() {
    // TODO: implement getCoursesHistory
    throw UnimplementedError();
  }
  
  @override
  FutureEither<List<CourseModel>> getDownloadedCourses() {
    // TODO: implement getDownloadedCourses
    throw UnimplementedError();
  }
  
  @override
  FutureEither<List<CourseModel>> getFavoriteCourses() {
    // TODO: implement getFavoriteCourses
    throw UnimplementedError();
  }
  
}
