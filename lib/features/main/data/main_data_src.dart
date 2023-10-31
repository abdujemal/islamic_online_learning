import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'model/course_model.dart';
import 'model/faq_model.dart';

abstract class MainDataSrc {
  Future<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
  );
  Future<List<CourseModel>> getFavoriteCourses();
  Future<List<CourseModel>> getDownloadedCourses();
  Future<List<FAQModel>> getFAQ();
  Future<int> saveTheCourse(CourseModel courseModel);
  Future<List<String>> getUstazs();
  Future<List<String>> getCategories();
  Future<List<CourseModel>> searchCourses(String query, int? numOfelt);
  Future<void> deleteCourse(int id);
}

class IMainDataSrc extends MainDataSrc {
  final FirebaseFirestore firebaseFirestore;
  IMainDataSrc( this.firebaseFirestore);

  DocumentSnapshot? lastCourse;

  @override
  Future<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
  ) async {
    late QuerySnapshot ds;

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

    List<CourseModel> favCourses = await getFavoriteCourses();

    List<CourseModel> courses = [];
    if (ds.docs.isNotEmpty) {
      for (var d in ds.docs) {
        bool isFav = false;
        int? id;
        for (var fav in favCourses) {
          if (fav.courseId == d.id) {
            isFav = true;
            id = fav.id;
          }
        }
        courses.add(
          CourseModel.fromMap(d.data() as Map, d.id).copyWith(
            isFav: isFav,
            id: id,
          ),
        );
      }
    }

    courses.sort((a, b) => b.courseId.compareTo(a.courseId));

    return courses;
  }

  @override
  Future<List<CourseModel>> searchCourses(String query, int? numOfelt) async {
    final ds = await firebaseFirestore
        .collection(FirebaseConst.courses)
        .orderBy('title')
        .startAfter([query])
        .limit(numOfelt ?? numOfDoc)
        .get();

    List<CourseModel> courses = [];
    if (ds.docs.isNotEmpty) {
      for (var d in ds.docs) {
        courses.add(CourseModel.fromMap(d.data(), d.id));
      }
    }
    return courses;
  }

  @override
  Future<List<CourseModel>> getDownloadedCourses() async {
    List<CourseModel> res = await DatabaseHelper().getDownloadedCourses();
    return res;
  }

  @override
  Future<List<CourseModel>> getFavoriteCourses() async {
    List<CourseModel> res = await DatabaseHelper().getFavCourses();
    return res;
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
  Future<int> saveTheCourse(CourseModel courseModel) async {
    if (await DatabaseHelper().isCourseAvailable(courseModel.courseId)) {
      return await DatabaseHelper().updateCourse(courseModel);
    } else {
      return await DatabaseHelper().insertCourse(courseModel);
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    await DatabaseHelper().deleteCourse(id);
  }

  @override
  Future<List<FAQModel>> getFAQ() async {
    final ds = await firebaseFirestore.collection(FirebaseConst.faq).get();
    List<FAQModel> faq = [];
    for (var d in ds.docs) {
      faq.add(FAQModel.fromMap(d));
    }
    return faq;
  }
}
