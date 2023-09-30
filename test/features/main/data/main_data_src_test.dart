
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_online_learning/features/main/data/Model/course_model.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:mockito/mockito.dart';

import '../../../teat_helper.mocks.dart';

void main() {
  late MFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;
  late IMainDataSrc mainDataSrc;
  late MockDataSnapshot mockSnapshot;

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

  const Map rawData = {
    '1': {
      "author": "author",
      'category': "category",
      'courseIds': "courseIds",
      'noOfRecord': 10,
      'pdfId': "pdfId",
      'title': "title",
      'ustaz': "ustaz",
    },
    '2': {
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
    mockFirebaseDatabase = MFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    mainDataSrc = IMainDataSrc(mockFirebaseDatabase);
  });

  group("get courses", () {
    test("should return List<CourseModel> if it is successfull.", () async {
      // act
      when(mockFirebaseDatabase.ref('Courses')).thenReturn(
          mockDatabaseReference); // Stub get() method on child reference
      when(mockDatabaseReference.get())
          .thenAnswer((realInvocation) async => mockSnapshot);
      when(mockSnapshot.value).thenAnswer((realInvocation) => rawData);

      final result = await mainDataSrc.getCourses(page);

      // assert
      expect(result, equals(courses));
    });

  });
}