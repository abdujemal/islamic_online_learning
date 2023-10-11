import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'course_model.dart';

abstract class MainDataSrc {
  Future<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
  );
  Future<List<CourseModel>> getFavoriteCourses();
  Future<List<CourseModel>> getDownloadedCourses();
  Future<void> saveTheCourse(CourseModel courseModel, bool isFav);
  Future<List<String>> getUstazs();
  Future<List<String>> getCategories();
  Future<List<CourseModel>> searchCourses(String query);
}

class IMainDataSrc extends MainDataSrc {
  final FirebaseDatabase firebaseDatabase;
  final FirebaseFirestore firebaseFirestore;
  IMainDataSrc(this.firebaseDatabase, this.firebaseFirestore);

  DocumentSnapshot? lastCourse;

  @override
  Future<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
  ) async {
    QuerySnapshot ds;

    if (key == null) {
      ds = isNew
          ? await firebaseFirestore
              .collection(FirebaseConst.courses)
              .orderBy('courseId', descending: true)
              .limit(numOfDoc)
              .get()
          : await firebaseFirestore
              .collection(FirebaseConst.courses)
              .orderBy('courseId', descending: true)
              .startAfterDocument(lastCourse!)
              .limit(numOfDoc)
              .get();
    } else {
      ds = isNew
          ? await firebaseFirestore
              .collection(FirebaseConst.courses)
              .where(key, isEqualTo: val)
              .orderBy('courseId', descending: true)
              .limit(numOfDoc)
              .get()
          : await firebaseFirestore
              .collection(FirebaseConst.courses)
              .where(key, isEqualTo: val)
              .orderBy('courseId', descending: true)
              .startAfterDocument(lastCourse!)
              .limit(numOfDoc)
              .get();
    }

    if (ds.docs.isNotEmpty) {
      lastCourse = ds.docs[ds.docs.length - 1];
    }

    List<CourseModel> courses = [];
    if (ds.docs.isNotEmpty) {
      for (var d in ds.docs) {
        courses.add(CourseModel.fromMap(d.data()! as Map, d.id));
      }
    }

    // courses.sort((a, b) => b.courseId.compareTo(a.courseId));

    return courses;
  }

  @override
  Future<List<CourseModel>> searchCourses(String query) async {
    // final ds = await firebaseFirestore.collection(FirebaseConst.courses).orderBy(title).get();
    throw UnimplementedError();
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
    final ds = await firebaseFirestore.collection(FirebaseConst.category).get();
    List<String> categories = [];
    for (var d in ds.docs) {
      categories.add(d.data()['name']);
    }
    return categories;
  }

  @override
  Future<List<String>> getUstazs() async {
    final ds = await firebaseFirestore.collection(FirebaseConst.ustaz).get();
    List<String> ustazs = [];
    for (var d in ds.docs) {
      ustazs.add(d['name']);
    }
    return ustazs;
  }
  
  @override
  Future<void> saveTheCourse(CourseModel courseModel, bool isFav) {
    // TODO: implement saveTheCourse
    throw UnimplementedError();
  }
}
