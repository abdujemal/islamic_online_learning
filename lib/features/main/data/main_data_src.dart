import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'course_model.dart';

abstract class MainDataSrc {
  Future<List<CourseModel>> getCourses(int page, );
  Future<List<CourseModel>> getCoursesHistory();
  Future<List<CourseModel>> getFavoriteCourses();
  Future<List<CourseModel>> getDownloadedCourses();
  Future<List<String>> getUstazs();
  Future<List<String>> getCategories();
}

class IMainDataSrc extends MainDataSrc {
  final FirebaseDatabase firebaseDatabase;
  IMainDataSrc(this.firebaseDatabase);

  @override
  Future<List<CourseModel>> getCourses(int page) async {
    final ds = await firebaseDatabase
        .ref(FirebaseConst.courses)
        .startAt(page * numOfDoc)
        .limitToFirst(numOfDoc)
        .get();
    List<CourseModel> courses = [];
    for (var d in (ds.value as Map).entries) {
      courses.add(CourseModel.fromMap(d.value as Map, d.key as String));
    }
    return courses;
  }

  @override
  Future<List<CourseModel>> getCoursesHistory() {
    // TODO: implement getCoursesHistory
    throw UnimplementedError();
  }

  @override
  Future<List<CourseModel>> getDownloadedCourses() {
    // TODO: implement getDownloadedCourses
    throw UnimplementedError();
  }

  @override
  Future<List<CourseModel>> getFavoriteCourses() {
    // TODO: implement getFavoriteCourses
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getCategories() async {
    final ds = await firebaseDatabase.ref(FirebaseConst.category).get();
    List<String> categories = [];
    for (var d in (ds.value as Map).values) {
      categories.add(d['name']);
    }
    return categories;
  }

  @override
  Future<List<String>> getUstazs() async {
    final ds = await firebaseDatabase.ref(FirebaseConst.ustaz).get();
    List<String> ustazs = [];
    for (var d in (ds.value as Map).values) {
      ustazs.add(d['name']);
    }
    return ustazs;
  }
}
