// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Discussion {
  final String id;
  final int afterLesson;
  final int courseNum;
  final int discussionSecond;
  final String curriculumId;
  final String title;
  final DateTime startAt;
  final String groupId;
  final GivenTime givenTime;
  Discussion({
    required this.id,
    required this.afterLesson,
    required this.courseNum,
    required this.discussionSecond,
    required this.curriculumId,
    required this.title,
    required this.startAt,
    required this.groupId,
    required this.givenTime,
  });

  Discussion copyWith({
    String? id,
    int? afterLesson,
    int? courseNum,
    int? discussionSecond,
    String? curriculumId,
    String? title,
    DateTime? startAt,
    String? groupId,
    GivenTime? givenTime,
  }) {
    return Discussion(
      id: id ?? this.id,
      afterLesson: afterLesson ?? this.afterLesson,
      courseNum: courseNum ?? this.courseNum,
      discussionSecond: discussionSecond ?? this.discussionSecond,
      curriculumId: curriculumId ?? this.curriculumId,
      title: title ?? this.title,
      startAt: startAt ?? this.startAt,
      groupId: groupId ?? this.groupId,
      givenTime: givenTime ?? this.givenTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'afterLesson': afterLesson,
      'courseNum': courseNum,
      'discussionSecond': discussionSecond,
      'curriculumId': curriculumId,
      'title': title,
      'startAt': startAt.millisecondsSinceEpoch,
      'groupId': groupId,
      'givenTime': givenTime.toMap(),
    };
  }

  factory Discussion.fromMap(Map<String, dynamic> map, int discussionSec,
      Map<String, dynamic> givenTimeMap) {
    return Discussion(
      id: map['id'] as String,
      afterLesson: map['afterLesson'] as int,
      courseNum: map['courseNum'] as int,
      curriculumId: map['curriculumId'] as String,
      title: map['title'] as String,
      startAt: DateTime.parse(map['startAt'] as String),
      groupId: map['groupId'] as String,
      discussionSecond: discussionSec,
      givenTime: GivenTime.fromMap(givenTimeMap),
    );
  }

  String toJson() => json.encode(toMap());

  factory Discussion.fromJson(String source) => Discussion.fromMap(
        json.decode(source)["result"]["discussion"] as Map<String, dynamic>,
        json.decode(source)["result"]["discussionTime"] as int,
        json.decode(source)["result"]["givenTime"] as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'Discussion(id: $id, afterLesson: $afterLesson, courseNum: $courseNum, discussionSecond: $discussionSecond, curriculumId: $curriculumId, title: $title, startAt: $startAt, groupId: $groupId, givenTime: $givenTime)';
  }

  @override
  bool operator ==(covariant Discussion other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.afterLesson == afterLesson &&
        other.courseNum == courseNum &&
        other.discussionSecond == discussionSecond &&
        other.curriculumId == curriculumId &&
        other.title == title &&
        other.startAt == startAt &&
        other.groupId == groupId &&
        other.givenTime == givenTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        afterLesson.hashCode ^
        courseNum.hashCode ^
        discussionSecond.hashCode ^
        curriculumId.hashCode ^
        title.hashCode ^
        startAt.hashCode ^
        groupId.hashCode ^
        givenTime.hashCode;
  }
}

class GivenTime {
  final int totalTime;
  final Segments segments;
  GivenTime({
    required this.totalTime,
    required this.segments,
  });
  GivenTime copyWith({
    int? totalTime,
    Segments? segments,
  }) {
    return GivenTime(
      totalTime: totalTime ?? this.totalTime,
      segments: segments ?? this.segments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalTime': totalTime,
      'segments': segments.toMap(),
    };
  }

  factory GivenTime.fromMap(Map<String, dynamic> map) {
    return GivenTime(
      totalTime: map['totalTime'] as int,
      segments: Segments.fromMap(map['segments'] as Map<String, dynamic>),
    );
  }
}

class Segments {
  final int attendance;
  final int quiz;
  final int assignment;
  Segments({
    required this.attendance,
    required this.quiz,
    required this.assignment,
  });
  Segments copyWith({
    int? attendance,
    int? quiz,
    int? assignment,
  }) {
    return Segments(
      attendance: attendance ?? this.attendance,
      quiz: quiz ?? this.quiz,
      assignment: assignment ?? this.assignment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendance': attendance,
      'quiz': quiz,
      'assignment': assignment,
    };
  }

  factory Segments.fromMap(Map<String, dynamic> map) {
    return Segments(
      attendance: map['attendance'] as int,
      quiz: map['quiz'] as int,
      assignment: map['assignment'] as int,
    );
  }
}

// totalTime: number;
//     segments: {
//         attendance: number;
//         quiz: number;
//         assignment: number;
//     };
