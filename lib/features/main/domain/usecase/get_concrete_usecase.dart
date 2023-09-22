import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_usecase.dart';
import '../../../../core/failure.dart';
import '../../data/Model/course_model.dart';
import '../main_repo.dart';

class GetCoursesUsecase
    extends BaseUseCase<List<CourseModel>, GetConcreteParams> {
  final MainRepo mainRepo;
  GetCoursesUsecase(this.mainRepo);

  @override
  Future<Either<Failure, List<CourseModel>>> call(
      GetConcreteParams parameters) async {
    final res = await mainRepo.getCourses(parameters.page);
    return res;
  }
}

class GetConcreteParams extends Equatable {
  final int page;
  const GetConcreteParams({required this.page});

  @override
  List<Object?> get props => [page];
}
