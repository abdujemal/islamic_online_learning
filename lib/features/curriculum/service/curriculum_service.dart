// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';
import 'package:islamic_online_learning/features/auth/model/course_score.dart';
import 'package:islamic_online_learning/features/auth/model/curriculum_score.dart';
import 'package:islamic_online_learning/features/auth/model/monthly_score.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
// import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
// import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';
// import 'package:islamic_online_learning/features/curriculum/service/curriculum_db_helper.dart';
import 'package:islamic_online_learning/features/meeting/model/discussion.dart';
import 'package:islamic_online_learning/features/quiz/model/test_attempt.dart';

class CurriculumService {
  Future<List<Curriculum>> fetchCurriculums() async {
    final response = await customGetRequest(
      curriculumsApi,
      authorized: true,
    );

    if (response.statusCode == 200) {
      return Curriculum.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load curriculums: ${response.body}');
    }
  }

  Future<bool> checkPaymentStatus() async {
    final response = await customGetRequest(
      paymentStatusApi,
      authorized: true,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] ?? false;
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to check payment: ${response.body}');
    }
  }

  // Future<void> loadDb() async {
  //   final currsFromDb =
  //       await CurriculumDbHelper.instance.getCurriculumWithDetails(
  //     "cddc8507-fc3f-4e55-97a1-bca5aef0c93e",
  //     0,
  //   );
  //   print("currsFromDb: $currsFromDb");
  // }

  Future<CurriculumNGroup> fetchCurriculum() async {
    final pref = await SharedPreferences.getInstance();
    // await pref.remove(PrefConsts.curriculumDate);
    // loadDb();
    final dateTime =
        pref.getString(PrefConsts.curriculumDate) ?? DateTime(2017).toString();

    final response = await customPostRequest(
      getCurriculumApi,
      {
        "date": dateTime,
      },
      authorized: true,
    );

    if (response.statusCode == 200) {
      CurriculumNGroup currNGroup = CurriculumNGroup.fromJson(response.body);
      // return currNGroup;

      // getting the archived scores
      final urls = currNGroup.monthlyScores.map((e) => e.archiveUrl).toList();
      final archivedScores = await Score.fetchArchivedScoresMultiple(urls);

      currNGroup = currNGroup.copyWith(
        scores: [...currNGroup.scores, ...archivedScores],
      );

      // if (currNGroup.curriculum != null) {
      //   await pref.setString(
      //       PrefConsts.curriculumDate, currNGroup.curriculum!.updatedOn);

      //   await CurriculumDbHelper.instance
      //       .insertCurriculum(currNGroup.curriculum!.toMap());
      //   for (AssignedCourse course
      //       in currNGroup.curriculum!.assignedCourses ?? []) {
      //     await CurriculumDbHelper.instance
      //         .insertAssignedCourse(course.toMap());
      //   }
      //   for (Lesson lesson in currNGroup.curriculum!.lessons ?? []) {
      //     await CurriculumDbHelper.instance.insertLesson(lesson.toMap());
      //   }

      //   return currNGroup;
      // } else {
        // final currsFromDb =
        //     await CurriculumDbHelper.instance.getCurriculumWithDetails(
        //   currNGroup.group.curriculumId,
        //   currNGroup.group.courseNum,
        // );
        // print("currsFromDb: $currsFromDb");
        // final currData = currsFromDb != null
        //     ? Curriculum.fromMap(currsFromDb, fromDb: true)
        //     : null;

        return CurriculumNGroup(
          curriculum: currNGroup.curriculum,
          discussions: currNGroup.discussions,
          group: currNGroup.group,
          scores: currNGroup.scores,
          courseScores: currNGroup.courseScores,
          curriculumScores: currNGroup.curriculumScores,
          monthlyScores: currNGroup.monthlyScores,
          testAttempts: currNGroup.testAttempts,
          rests: currNGroup.rests,
          unreadChats: currNGroup.unreadChats,
          unReadNotifications: currNGroup.unReadNotifications,
          confusions: currNGroup.confusions,
        );
      // }
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load curriculum: ${response.body}');
    }
  }
}

class CurriculumNGroup {
  final Curriculum? curriculum;
  final CourseRelatedData group;
  final List<Score> scores;
  final List<MonthlyScore> monthlyScores;
  final List<CourseScore> courseScores;
  final List<CurriculumScore> curriculumScores;
  final List<Discussion> discussions;
  final List<TestAttempt> testAttempts;
  final List<Rest> rests;
  final List<Confusion> confusions;
  final int unreadChats;
  final int unReadNotifications;
  CurriculumNGroup({
    required this.curriculum,
    required this.group,
    required this.scores,
    required this.courseScores,
    required this.curriculumScores,
    required this.monthlyScores,
    required this.testAttempts,
    required this.discussions,
    required this.rests,
    required this.unreadChats,
    required this.unReadNotifications,
    required this.confusions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentCurriculum': curriculum?.toMap(),
      'group': group.toMap(),
      'scores': scores.map((e) => e.toMap()).toList(),
      "courseScores": courseScores.map((e) => e.toMap()).toList(),
      "curriculumScores": curriculumScores.map((e) => e.toMap()).toList(),
      'monthlyScores': monthlyScores.map((e)=>e.toMap()).toList(),
      'testAttempts': testAttempts.map((e) => e.toMap()).toList(),
      "discussions": discussions.map((e) => e.toMap()).toList(),
      "rests": rests.map((e) => e.toMap()).toList(),
      "unreadChats": unreadChats,
      'unReadNotifications': unReadNotifications,
      "confusions": confusions,
    };
  }

  factory CurriculumNGroup.fromMap(Map<String, dynamic> map) {
    // printMap(map);

    return CurriculumNGroup(
      curriculum: map['currentCurriculum'] != null
          ? Curriculum.fromMap(map['currentCurriculum'] as Map<String, dynamic>)
          : null,
      group: CourseRelatedData.fromMap(map['group'] as Map<String, dynamic>),
      scores: List<Score>.from(
        (map["scores"] as List<dynamic>).map(
          (e) => Score.fromMap(e),
        ),
      ),
      monthlyScores: List<MonthlyScore>.from(
        (map["monthlyScores"] as List<dynamic>).map(
          (e) => MonthlyScore.fromMap(e),
        ),
      ),
      courseScores: List<CourseScore>.from(
        (map["courseScores"] as List<dynamic>).map(
          (e) => CourseScore.fromMap(e),
        ),
      ),
      curriculumScores: List<CurriculumScore>.from(
        (map["curriculumScores"] as List<dynamic>).map(
          (e) => CurriculumScore.fromMap(e),
        ),
      ),
      confusions: List<Confusion>.from(
        (map["confusions"] as List<dynamic>).map(
          (e) => Confusion.fromMap(e),
        ),
      ),
      discussions:
          List<Discussion>.from((map["discussions"] as List<dynamic>).map(
        (e) => Discussion.fromMap(e, null, null, null),
      )),
      testAttempts: List<TestAttempt>.from(
        (map["testAttempts"] as List<dynamic>).map(
          (e) => TestAttempt.fromMap(e),
        ),
      ),
      rests: List<Rest>.from(
        (map["rests"] as List<dynamic>).map(
          (e) => Rest.fromMap(e),
        ),
      ),
      unreadChats: map["unreadChats"] as int,
      unReadNotifications: map["unReadNotifications"] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurriculumNGroup.fromJson(String source) =>
      CurriculumNGroup.fromMap(json.decode(source) as Map<String, dynamic>);

  CurriculumNGroup copyWith({
    Curriculum? curriculum,
    CourseRelatedData? group,
    List<Score>? scores,
    List<MonthlyScore>? monthlyScores,
    List<CourseScore>? courseScores,
    List<CurriculumScore>? curriculumScores,
    List<Discussion>? discussions,
    List<TestAttempt>? testAttempts,
    List<Confusion>? confusions,
    List<Rest>? rests,
    int? unreadChats,
    int? unReadNotifications,
  }) {
    return CurriculumNGroup(
      curriculum: curriculum ?? this.curriculum,
      group: group ?? this.group,
      scores: scores ?? this.scores,
      monthlyScores: monthlyScores ?? this.monthlyScores,
      courseScores: courseScores ?? this.courseScores,
      curriculumScores: curriculumScores ?? this.curriculumScores,
      discussions: discussions ?? this.discussions,
      testAttempts: testAttempts ?? this.testAttempts,
      rests: rests ?? this.rests,
      unreadChats: unreadChats ?? this.unreadChats,
      unReadNotifications: unReadNotifications ?? this.unReadNotifications,
      confusions: confusions ?? this.confusions,
    );
  }

  @override
  String toString() {
    return 'CurriculumNGroup(curriculum: $curriculum, group: $group, scores: $scores, monthlyScores: $monthlyScores, courseScores: $courseScores, curriculumScores: $curriculumScores, discussions: $discussions, testAttempts: $testAttempts, rests: $rests, confusions: $confusions, unreadChats: $unreadChats, unReadNotifications: $unReadNotifications)';
  }
}
