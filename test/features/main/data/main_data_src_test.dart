import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:mockito/mockito.dart';

import '../../../teat_helper.mocks.dart';

void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;
  late IMainDataSrc mainDataSrc;
  late MockDataSnapshot mockSnapshot;

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

  const Map<String, dynamic> rawData = {
    'courseId': {
      "author": "author",
      'category': "category",
      'courseIds': "courseIds",
      'noOfRecord': 10,
      'pdfId': "pdfId",
      'title': "title",
      'ustaz': "ustaz",
    },
    'courseId1': {
      'author': "author1",
      'category': "category1",
      'courseIds': "courseIds1",
      'noOfRecord': 20,
      'pdfId': "pdfId1",
      'title': "title1",
      'ustaz': "ustaz1",
    }
  };

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    mainDataSrc = IMainDataSrc(mockFirebaseDatabase);
  });

  group("MainDataSrc", () {
    test("should return List<CourseModel> when getCourses(int page) called",
        () async {
      MockQuery mockQuery1 = MockQuery();
      MockQuery mockQuery2 = MockQuery();
      const int page = 0;

      // arange
      when(mockFirebaseDatabase.ref(FirebaseConst.courses))
          .thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.startAt(0, key: null)).thenReturn(mockQuery1);
      when(mockQuery1.limitToFirst(numOfDoc)).thenReturn(mockQuery2);
      when(mockQuery2.get()).thenAnswer((realInvocation) async => mockSnapshot);
      when(mockSnapshot.value).thenAnswer((realInvocation) => rawData);

      // act
      final result = await mainDataSrc.getCourses(page);

      // assert
      expect(result, equals(courses));
    });

    test("should return List<CourseModel> when getCoursesHistory() called",
        () async {
      // arrange

      // act
      final result = await mainDataSrc.getCoursesHistory();
      // assert
      expect(result, courses);
    });

    test("should return List<CourseModel> when getDownloadHistory() called",
        () async {
      // arrange

      // act
      final result = await mainDataSrc.getDownloadedCourses();
      // assert
      expect(result, courses);
    });

    test("should return List<CourseModel> when getFavouriteCourse() called",
        () async {
      // arrange

      // act
      final result = await mainDataSrc.getFavoriteCourses();
      // assert
      expect(result, courses);
    });

    test("should return List<CourseModel> when getCategories() called",
        () async {
      // arrange

      // act
      final result = await mainDataSrc.getCategories();
      // assert
      expect(result, courses);
    });

    test("should return List<CourseModel> when getUstazs() called", () async {
      // arrange

      // act
      final result = await mainDataSrc.getUstazs();
      // assert
      expect(result, courses);
    });
  });
}
