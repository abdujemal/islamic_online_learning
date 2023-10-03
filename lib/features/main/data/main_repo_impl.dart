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
  FutureEither<List<CourseModel>> getCourses(int page) async {
    try {
      final res = await mainDataSrc.getCourses(page);
      return right(res);
    } on Exception catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }
}