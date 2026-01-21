// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';
import 'package:islamic_online_learning/features/auth/model/monthly_score.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';
import 'package:islamic_online_learning/features/curriculum/service/curriculum_db_helper.dart';
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

      if (currNGroup.curriculum != null) {
        await pref.setString(
            PrefConsts.curriculumDate, currNGroup.curriculum!.updatedOn);

        await CurriculumDbHelper.instance
            .insertCurriculum(currNGroup.curriculum!.toMap());
        for (AssignedCourse course
            in currNGroup.curriculum!.assignedCourses ?? []) {
          await CurriculumDbHelper.instance
              .insertAssignedCourse(course.toMap());
        }
        for (Lesson lesson in currNGroup.curriculum!.lessons ?? []) {
          await CurriculumDbHelper.instance.insertLesson(lesson.toMap());
        }

        return currNGroup;
      } else {
        final currsFromDb =
            await CurriculumDbHelper.instance.getCurriculumWithDetails(
          currNGroup.group.curriculumId,
          currNGroup.group.courseNum,
        );
        // print("currsFromDb: $currsFromDb");
        final currData = currsFromDb != null
            ? Curriculum.fromMap(currsFromDb, fromDb: true)
            : null;

        return CurriculumNGroup(
          curriculum: currData,
          discussions: currNGroup.discussions,
          group: currNGroup.group,
          scores: currNGroup.scores,
          monthlyScores: currNGroup.monthlyScores,
          testAttempts: currNGroup.testAttempts,
          rests: currNGroup.rests,
          unreadChats: currNGroup.unreadChats,
          unReadNotifications: currNGroup.unReadNotifications,
        );
      }
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
  final List<Discussion> discussions;
  final List<TestAttempt> testAttempts;
  final List<Rest> rests;
  final int unreadChats;
  final int unReadNotifications;
  CurriculumNGroup({
    required this.curriculum,
    required this.group,
    required this.scores,
    required this.monthlyScores,
    required this.testAttempts,
    required this.discussions,
    required this.rests,
    required this.unreadChats,
    required this.unReadNotifications,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'curriculum': curriculum?.toMap(),
      'group': group.toMap(),
      'scores': scores.map((e) => e.toMap()),
      'testAttempts': testAttempts.map((e) => e.toMap()),
      "discussions": discussions.map((e) => e.toMap()),
      "rests": rests.map((e) => e.toMap()),
      "unreadChats": unreadChats,
      'unReadNotifications': unReadNotifications,
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
      discussions:
          List<Discussion>.from((map["discussions"] as List<dynamic>).map(
        (e) => Discussion.fromMap(e, null, null),
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
    List<Discussion>? discussions,
    List<TestAttempt>? testAttempts,
    List<Rest>? rests,
    int? unreadChats,
    int? unReadNotifications,
  }) {
    return CurriculumNGroup(
      curriculum: curriculum ?? this.curriculum,
      group: group ?? this.group,
      scores: scores ?? this.scores,
      monthlyScores: monthlyScores ?? this.monthlyScores,
      discussions: discussions ?? this.discussions,
      testAttempts: testAttempts ?? this.testAttempts,
      rests: rests ?? this.rests,
      unreadChats: unreadChats ?? this.unreadChats,
      unReadNotifications: unReadNotifications ?? this.unReadNotifications,
    );
  }
}
