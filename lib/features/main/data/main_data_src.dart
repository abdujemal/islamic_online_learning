import 'dart:async';
import 'dart:convert';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'model/course_model.dart';
import 'model/faq_model.dart';
import 'package:http/http.dart' as http;

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
  int page = 1;
  IMainDataSrc();

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
          null,
          null,
          SortingMethod.dateDSC,
          (page - 1) * numOfDoc,
        );

        List<String> categories = await DatabaseHelper().getCategories();
        List<String> ustazs = await DatabaseHelper().getUstazs();
        List<String> contents = await DatabaseHelper().getContent();

        // final qs = await firebaseFirestore
        //     .collection(FirebaseConst.courses)
        //     .orderBy(
        //       'dateTime',
        //       descending: false,
        //     )
        //     .startAfter([res.first["dateTime"]]).get();

        final qs = await http.get(
            Uri.parse("$serverUrl/courses?dateTime=${res.first["dateTime"]}"));

        List courses = jsonDecode(qs.body);

        print("New Docs ${courses.length}");

        if (courses.isNotEmpty) {
          for (var d in courses) {
            if (d["audioSizes"] != null) {
              print("categories: ${categories.length}");
              if (!categories.contains(d['category'])) {
                print(
                    'adding cateogry ${d['category']} from ${d['title']} be ${d['ustaz']}');
                await DatabaseHelper().insertCategory(d['category']);
                categories.add(d['category']);
              }

              if (!ustazs.contains(d['ustaz'])) {
                print('adding ustaz');

                await DatabaseHelper().insertUstaz(d['ustaz']);
                ustazs.add(d['ustaz']);
              }

              if (!contents.contains(d['title'])) {
                print('adding title');

                await DatabaseHelper().insertContent(d['title']);
                contents.add(d['title']);
              }

              final id =
                  await DatabaseHelper().isCourseAvailable(d['courseId']);
              if (id != null) {
                if (d['isDeleted'] == true) {
                  // final course = await getSingleCourse(d['courseId'], false);
                  // if (course != null) {
                  print("deleting course");
                  await deleteCourse(id);
                  // } else {
                  //   print('course is null');
                  // }
                } else {
                  print("updateing");

                  await DatabaseHelper().updateCourseFromCloud(
                      CourseModel.fromMap(d, d['courseId']).copyWith(id: id));
                }
              } else {
                print("adding");
                if (d['isDeleted'] != true) {
                  await DatabaseHelper()
                      .insertCourse(CourseModel.fromMap(d, d['courseId']));
                }
              }
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
      faqdata = await DatabaseHelper().getFaqs();
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
