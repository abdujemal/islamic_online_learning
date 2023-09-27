import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import 'Model/course_model.dart';

abstract class MainDataSrc {
  Future<List<CourseModel>> getCourses(int page);
}

class IMainDataSrc extends MainDataSrc {
  final FirebaseDatabase firebaseDatabase;
  IMainDataSrc(this.firebaseDatabase);
  @override
  Future<List<CourseModel>> getCourses(int page) async {
    
    final ds = await firebaseDatabase.ref('Courses').get();
    List<CourseModel> courses = [];
    for (var d in (ds.value as Map).values) {
      courses.add(CourseModel.fromMap(d as Map));
    }
    return courses;
  }
}
