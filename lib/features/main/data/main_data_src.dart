import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'model/course_model.dart';
import 'model/faq_model.dart';

abstract class MainDataSrc {
  Future<List<CourseModel>> getCourses(
      bool isNew, String? key, String? val, SortingMethod method);
  Future<List<CourseModel>> getFavoriteCourses();
  Future<List<CourseModel>> getStartedCourses();
  Future<List<CourseModel>> getSavedCourses();
  Future<CourseModel?> getSingleCourse(String courseId, bool fromCloud);
  Future<List<FAQModel>> getFAQ();
  Future<int> saveTheCourse(CourseModel courseModel);
  Future<List<String>> getUstazs();
  Future<List<String>> getCategories();
  Future<List<CourseModel>> getBeginnerCourses();
  Future<List<CourseModel>> searchCourses(String query, int? numOfelt);
  Future<void> deleteCourse(int id);
}

class IMainDataSrc extends MainDataSrc {
  final FirebaseFirestore firebaseFirestore;

  int page = 1;
  IMainDataSrc(this.firebaseFirestore);

  int? lastCourseIndex;

  @override
  Future<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    dynamic val,
    SortingMethod method,
  ) async {
    // late QuerySnapshot ds;

    // if (key == null) {
    //   ds = isNew
    //       ? await firebaseFirestore
    //           .collection(FirebaseConst.courses)
    //           .orderBy(
    //             method == SortingMethod.dateDSC ? 'dateTime' : "title",
    //             descending: method == SortingMethod.dateDSC,
    //           )
    //           .limit(numOfDoc)
    //           .get()
    //       : await firebaseFirestore
    //           .collection(FirebaseConst.courses)
    //           .orderBy(
    //             method == SortingMethod.dateDSC ? 'dateTime' : "title",
    //             descending: method == SortingMethod.dateDSC,
    //           )
    //           .startAfterDocument(lastCourse!)
    //           .limit(numOfDoc)
    //           .get();
    // } else {
    //   ds = isNew
    //       ? await firebaseFirestore
    //           .collection(FirebaseConst.courses)
    //           .where(key, isEqualTo: val)
    //           .orderBy(method == SortingMethod.dateDSC ? 'dateTime' : "title",
    //               descending: method == SortingMethod.dateDSC)
    //           .limit(numOfDoc)
    //           .get()

    //       : await firebaseFirestore
    //           .collection(FirebaseConst.courses)
    //           .where(key, isEqualTo: val)
    //           .orderBy(method == SortingMethod.dateDSC ? 'dateTime' : "title",
    //               descending: method == SortingMethod.dateDSC)
    //           .startAfterDocument(lastCourse!)
    //           .limit(numOfDoc)
    //           .get();
    // }
    if (isNew) {
      page = 1;
    } else {
      page++;
    }

    if (isNew && key == null) {
      try {
        final res = await DatabaseHelper().getCouses(
            null, null, SortingMethod.dateDSC, (page - 1) * numOfDoc);

        final categories = await DatabaseHelper().getCategories();
        final ustazs = await DatabaseHelper().getUstazs();
        final contents = await DatabaseHelper().getContent();

        final qs = await firebaseFirestore
            .collection(FirebaseConst.courses)
            .orderBy(
              'dateTime',
              descending: false,
            )
            .startAfter([res.first["dateTime"]]).get();

        print("New Docs ${qs.docs.length}");
        if (qs.docs.isNotEmpty) {
          for (var d in qs.docs) {
            if (!categories.contains(d.data()['category'])) {
              print('adding cateogry');
              await DatabaseHelper().insertCategory(d.data()['category']);
            }

            if (!ustazs.contains(d.data()['ustaz'])) {
              print('adding ustaz');

              await DatabaseHelper().insertCategory(d.data()['ustaz']);
            }

            if (!contents.contains(d.data()['title'])) {
              print('adding title');

              await DatabaseHelper().insertContent(d.data()['title']);
            }

            final id = await DatabaseHelper().isCourseAvailable(d.id);
            if (id != null) {
              print("updateing");

              await DatabaseHelper().updateCourseFromCloud(
                  CourseModel.fromMap(d.data(), d.id).copyWith(id: id));
            } else {
              print("adding");

              await DatabaseHelper()
                  .insertCourse(CourseModel.fromMap(d.data(), d.id));
            }
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }

    // await Future.delayed(const Duration(seconds: 2));

    final res = await DatabaseHelper()
        .getCouses(key, val, method, (page - 1) * numOfDoc);
    // if (res.isNotEmpty) {
    //   lastCourseIndex = ds.docs[ds.docs.length - 1];
    // }

    // List<CourseModel> savedCourses = await getSavedCourses();

    List<CourseModel> courses = [];
    for (var d in res) {
      courses.add(CourseModel.fromMap(d, d["courseId"]));
    }
    // if (ds.docs.isNotEmpty) {
    //   for (var d in ds.docs) {
    //     if (d.data() != null) {
    //       final matchings = savedCourses.where((e) => e.courseId == d.id);
    //       if (matchings.isNotEmpty) {
    //         CourseModel savedCourse = matchings.first;
    //         courses.add(CourseModel.fromMap(d.data() as Map, d.id,
    //             copyFrom: savedCourse));
    //       } else {
    //         courses.add(CourseModel.fromMap(d.data() as Map, d.id));
    //       }
    //     }
    //   }
    // }

    return courses;
  }

  @override
  Future<List<CourseModel>> searchCourses(String query, int? numOfelt) async {
    // final ds = await firebaseFirestore
    //     .collection(FirebaseConst.courses)
    //     .orderBy('title')
    //     .startAfter([query])
    //     .limit(numOfelt ?? numOfDoc)
    //     .get();

    // List<CourseModel> courses = [];
    // if (ds.docs.isNotEmpty) {
    //   for (var d in ds.docs) {
    //     courses.add(CourseModel.fromMap(d.data(), d.id));
    //   }
    // }

    return DatabaseHelper().searchCourses(query);
  }

  @override
  Future<List<CourseModel>> getStartedCourses() async {
    List<CourseModel> res = await DatabaseHelper().getStartedCourses();
    return res;
  }

  @override
  Future<List<CourseModel>> getFavoriteCourses() async {
    List<CourseModel> res = await DatabaseHelper().getFavCourses();
    return res;
  }

  @override
  Future<List<String>> getCategories() async {
    return DatabaseHelper().getCategories();
    // final ds = await firebaseFirestore.collection(FirebaseConst.category).get();
    // List<String> categories = [];
    // for (var d in ds.docs) {
    //   categories.add(d.data()['name']);
    // }
    // return categories;
  }

  @override
  Future<List<CourseModel>> getBeginnerCourses() async {
    return getCourses(
      true,
      "isBeginner",
      1,
      SortingMethod.nameDSC,
    );
    // final ds = await firebaseFirestore
    //     .collection(FirebaseConst.courses)
    //     .where(
    //       "isBeginner",
    //       isEqualTo: true,
    //     )
    //     .get();
    // List<CourseModel> courses = [];
    // for (var d in ds.docs) {
    //   courses.add(CourseModel.fromMap(d.data(), d.id));
    // }
    // print(courses);
    // return courses;
  }

  @override
  Future<List<String>> getUstazs() async {
    return DatabaseHelper().getUstazs();
    // final ds = await firebaseFirestore.collection(FirebaseConst.ustaz).get();
    // List<String> ustazs = [];
    // for (var d in ds.docs) {
    //   ustazs.add(d['name']);
    // }
    // return ustazs;
  }

  @override
  Future<int> saveTheCourse(CourseModel courseModel) async {
    final id = await DatabaseHelper().isCourseAvailable(courseModel.courseId);
    if (id != null) {
      return await DatabaseHelper().updateCourse(courseModel);
    }
    throw Exception("Not found");
  }

  @override
  Future<void> deleteCourse(int id) async {
    await DatabaseHelper().deleteCourse(id);
  }

  @override
  Future<List<FAQModel>> getFAQ() async {
    List<FAQModel> faqdata = await DatabaseHelper().getFaqs();

    try {
      final aq =
          await firebaseFirestore.collection(FirebaseConst.faq).count().get();
      if (aq.count != null && faqdata.length < aq.count!) {
        final qs = await firebaseFirestore.collection(FirebaseConst.faq).get();
        for (var d in qs.docs) {
          final id =
              await DatabaseHelper().isFAQAvailable(d.data()['question']);
          if (id != null) {
            await DatabaseHelper().updateFaq(FAQModel(
                id: id,
                question: d.data()['question'],
                answer: d.data()['answer']));
          } else {
            await DatabaseHelper().insertFaq(FAQModel(
                id: null,
                question: d.data()['question'],
                answer: d.data()['answer']));
          }
        }
        faqdata = await DatabaseHelper().getFaqs();
      }
    } catch (e) {
      print(e);
    }

    return faqdata;
    // List<FAQModel> faq = [];
    // for (var d in ds.docs) {
    //   faq.add(FAQModel.fromMap(d.data() , d.id));
    // }
    // return faq;
  }

  @override
  Future<List<CourseModel>> getSavedCourses() async {
    List<CourseModel> res = await DatabaseHelper().getSavedCourses();
    return res;
  }

  @override
  Future<CourseModel?> getSingleCourse(String courseId, bool fromCloud) async {
    // if (fromCloud) {
    //   final res = await firebaseFirestore
    //       .collection(FirebaseConst.courses)
    //       .doc(courseId)
    //       .get();

    //   if (res.exists) {
    //     return CourseModel.fromMap(res.data() as Map, res.id);
    //   } else {
    //     return null;
    //   }
    // }
    final res = await DatabaseHelper().getSingleCourse(courseId);
    return res;
  }
}

enum SortingMethod { nameDSC, dateDSC }
