import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';//firebase_database_mocks
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_online_learning/features/main/data/Model/course_model.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:mockito/mockito.dart';

import '../../../teat_helper.mocks.dart';

// import '../../../teat_helper.mocks.dart';

class MockDatabaseReference extends Mock implements DatabaseReference {}

void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late IMainDataSrc mainDataSrc;
  // late MockDatabaseReference mockDatabaseRef;

  // setUpAll(() async {
  //   TestWidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       appId: 'your_app_id',
  //       apiKey: 'your_api_key',
  //       databaseURL: 'http://localhost:9000', // Firebase Database emulator URL
  //       projectId: '',
  //       messagingSenderId: '',
  //     ),
  //   );
  // });

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

  mockFirebaseDatabase = MockFirebaseDatabase();

  mockFirebaseDatabase.ref().child("Courses").set({
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
  });

  FirebaseException exception = FirebaseException(plugin: "plugin");
  // final mockDataSnapshot = MockDataSnapshot();
  group("get courses", () {
    setUp(() {
      // mockDatabaseRef = MockDatabaseReference();
      mainDataSrc = IMainDataSrc(mockFirebaseDatabase);
    });
    test("should return List<CourseModel> if it is successfull.", () async {
      // arrange
      // when(mockFirebaseDatabase.ref().child("Courses").get())
      //     .thenAnswer((i) async => mockDataSnapshot);
      // when(mockDatabaseRef.child("Courses").get())
      //     .thenAnswer((_) async => mockDataSnapshot);
      // when(mockDataSnapshot.value).thenReturn({
      //   '1': {
      //     "author": "author",
      //     'category': "category",
      //     'courseIds': "courseIds",
      //     'noOfRecord': 10,
      //     'pdfId': "pdfId",
      //     'title': "title",
      //     'ustaz': "ustaz",
      //   },
      //   '2': {
      //     'author': "author1",
      //     'category': "category1",
      //     'courseIds': "courseIds1",
      //     'noOfRecord': 20,
      //     'pdfId': "pdfId1",
      //     'title': "title1",
      //     'ustaz': "ustaz1",
      //   }
      // });

      // act
      final result = await mainDataSrc.getCourses(page);

      // assert
      expect(result, equals(courses));

      // verify(mainDataSrc.getCourses(page)).called(1);
      // verify(mockDatabaseRef.child("Courses").get()).called(1);
    });


    test("should throw an error if it is not successfull.", () async {
      // arrange
      final mockReference = MockDatabaseReference();
      when(mockFirebaseDatabase.ref()).thenReturn(mockReference);
      when(mockReference.child("Courses")).thenReturn(MockDatabaseReference());
      when(mockFirebaseDatabase.ref().child("Courses").get()) 
          .thenThrow(exception);

      // act
      final result = await mainDataSrc.getCourses(page);

      // assert
      expect(result, throwsException);
    });



  });
}
