import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_online_learning/core/failure.dart';
import 'package:islamic_online_learning/features/main/data/Model/course_model.dart';
import 'package:islamic_online_learning/features/main/domain/usecase/get_concrete_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../teat_helper.mocks.dart';

void main() {
  late GetCoursesUsecase usecase;
  late MockMainRepo mockMainRepo;

  setUp(() {
    mockMainRepo = MockMainRepo();
    usecase = GetCoursesUsecase(mockMainRepo);
  });

  const GetConcreteParams getConcreteParams = GetConcreteParams(page: 1);
  const int page = 1;
  const List<CourseModel> courses = [
    CourseModel(
      author: "author",
      category: "category",
      courseIds: "courseIds",
      noOfRecord: 10,
      pdfId: "pdfId",
      title: "title",
      ustaz: "ustaz",
    ),
    CourseModel(
      author: "author1",
      category: "category1",
      courseIds: "courseIds1",
      noOfRecord: 20,
      pdfId: "pdfId1",
      title: "title1",
      ustaz: "ustaz1",
    ),
  ];

  const Failure failure = Failure(messege: "Failed");

  test("should get Courses when GetCoursesUsecase.call", () async {
    // arrange
    when(mockMainRepo.getCourses(page))
        .thenAnswer((i) async => const Right(courses));
    // act
    final result = await usecase.call(getConcreteParams);
    // assert
    expect(result, equals(const Right(courses)));
    // verify(mockMainRepo.getCourses(page));

    // verifyNoMoreInteractions(mockMainRepo);
  });

  test("should throw exception when GetCoursesUsecase.call", () async {
    // arrange
    when(mockMainRepo.getCourses(page))
        .thenAnswer((i) async => const Left(failure));
    // act
    final result = await usecase.call(getConcreteParams);
    // assert
    expect(result, equals(const Left(failure)));
    // verify(mockMainRepo.getCourses(page));

    // verifyNoMoreInteractions(mockMainRepo);
  });
}
