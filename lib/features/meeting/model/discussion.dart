// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Discussion {
  final String id;
  final int fromLesson;
  final int toLesson;
  final int courseNum;
  final int? discussionSecond;
  final String curriculumId;
  final String title;
  final DateTime startAt;
  final String groupId;
  final GivenTime? givenTime;
  final String? url;
  Discussion({
    required this.id,
    required this.fromLesson,
    required this.toLesson,
    required this.courseNum,
    required this.discussionSecond,
    required this.curriculumId,
    required this.title,
    required this.startAt,
    required this.groupId,
    required this.givenTime,
    required this.url,
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
    String? url,
  }) {
    return Discussion(
      id: id ?? this.id,
      fromLesson: afterLesson ?? this.fromLesson,
      toLesson: afterLesson ?? this.toLesson,
      courseNum: courseNum ?? this.courseNum,
      discussionSecond: discussionSecond ?? this.discussionSecond,
      curriculumId: curriculumId ?? this.curriculumId,
      title: title ?? this.title,
      startAt: startAt ?? this.startAt,
      groupId: groupId ?? this.groupId,
      givenTime: givenTime ?? this.givenTime,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fromLesson': fromLesson,
      'toLesson': toLesson,
      'courseNum': courseNum,
      'discussionSecond': discussionSecond,
      'curriculumId': curriculumId,
      'title': title,
      'startAt': startAt.toString(),
      'groupId': groupId,
      'givenTime': givenTime?.toMap(),
      "live_kit_url": url,
    };
  }

  factory Discussion.fromMap(Map<String, dynamic> map, int? discussionSec,
      Map<String, dynamic>? givenTimeMap, String? url) {
    // printMap(map);
    print("Discussion.fromMap");
    return Discussion(
      id: map['id'] as String,
      fromLesson: map['fromLesson'] as int,
      toLesson: map['toLesson'] as int,
      courseNum: map['courseNum'] as int,
      curriculumId: map['curriculumId'] as String,
      title: map['title'] as String,
      startAt: DateTime.parse(map['startAt'] as String).toLocal(),
      groupId: map['groupId'] as String,
      discussionSecond: discussionSec,
      givenTime: givenTimeMap == null ? null : GivenTime.fromMap(givenTimeMap),
      url: url,
    );
  }

  String toJson() => json.encode(toMap());

  factory Discussion.fromJson(String source) => Discussion.fromMap(
        json.decode(source)["result"]["discussion"] as Map<String, dynamic>,
        json.decode(source)["result"]["discussionTime"] as int,
        json.decode(source)["result"]["givenTime"] as Map<String, dynamic>,
        json.decode(source)["result"]["live_kit_url"] as String,
      );

  @override
  String toString() {
    return 'Discussion(id: $id,  courseNum: $courseNum, discussionSecond: $discussionSecond, curriculumId: $curriculumId, title: $title, startAt: $startAt, groupId: $groupId, givenTime: $givenTime)';
  }

  @override
  bool operator ==(covariant Discussion other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
    print("GivenTime.fromMap");
    return GivenTime(
      totalTime: map['totalTime'] as int,
      segments: Segments.fromMap(map['segments'] as Map<String, dynamic>),
    );
  }
}

class Segments {
  final int discussion;
  final int quiz;
  final int assignment;
  Segments({
    required this.discussion,
    required this.quiz,
    required this.assignment,
  });
  Segments copyWith({
    int? discussion,
    int? quiz,
    int? assignment,
  }) {
    return Segments(
      discussion: discussion ?? this.discussion,
      quiz: quiz ?? this.quiz,
      assignment: assignment ?? this.assignment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discussion': discussion,
      'quiz': quiz,
      'assignment': assignment,
    };
  }

  factory Segments.fromMap(Map<String, dynamic> map) {
    print("segment:$map");
    return Segments(
      discussion: map['discussion'] as int,
      quiz: map['quiz'] as int,
      assignment: map['assignment'] as int,
    );
  }
}

// totalTime: number;
//     segments: {
//         discussion: number;
//         quiz: number;
//         assignment: number;
//     };
