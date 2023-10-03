import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_online_learning/core/failure.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:islamic_online_learning/features/main/data/main_repo_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../teat_helper.mocks.dart';

void main() {
  late MockMainDataSrc mockMainDataSrc;
  late IMainRepo iMainRepo;

  const List<CourseModel> courses = [
    CourseModel(
      isDownloaded: false,
      lastViewed: "",
      isFav: false,
      id: null,
      author: 'author',
      category: 'category',
      courseIds: 'courseIds',
      noOfRecord: 10,
      pdfId: 'pdfId',
      title: 'title',
      ustaz: 'ustaz',
      courseId: 'courseId',
      audioMin: 0,
      pdfPage: 1,
    ),
    CourseModel(
      isDownloaded: false,
      lastViewed: "",
      isFav: false,
      id: null,
      author: 'author1',
      category: 'category1',
      courseIds: 'courseIds1',
      noOfRecord: 20,
      pdfId: 'pdfId1',
      title: 'title1',
      ustaz: 'ustaz1',
      courseId: 'courseId1',
      audioMin: 0,
      pdfPage: 1,
    ),
  ];

  const Failure failure = Failure(messege: "messege");

  setUp(() {
    mockMainDataSrc = MockMainDataSrc();
    iMainRepo = IMainRepo(mockMainDataSrc);
  });

  group("getCourses", () {
    test("should return List<CourseModel> if it is successfull.", () async {
      // arrange
      when(mockMainDataSrc.getCourses(0))
          .thenAnswer((realInvocation) async => courses);
      // act
      final result = await iMainRepo.getCourses(0);
      // assert
      expect(result, const Right(courses));
    });

    test("should return Failure if it is failed.", () async {
      Exception exception = Exception("messege");
      // arrange
      when(mockMainDataSrc.getCourses(0))
          .thenAnswer((realInvocation) async => throw exception);
      // act
      final result = await iMainRepo.getCourses(0);
      // assert
      expect(result, Left<Exception, List<CourseModel>>(exception));
    });
  });
}
