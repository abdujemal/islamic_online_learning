// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CourseRelatedData {
  final DateTime courseStartDate;
  final int courseNum;
  final int lessonNum;
  final String discussionDay;
  final String curriculumId;
  CourseRelatedData({
    required this.courseStartDate,
    required this.courseNum,
    required this.lessonNum,
    required this.discussionDay,
    required this.curriculumId,
  });

  CourseRelatedData copyWith({
    DateTime? courseStartDate,
    int? courseNum,
    int? lessonNum,
    String? discussionDay,
    String? curriculumId,
  }) {
    return CourseRelatedData(
      courseStartDate: courseStartDate ?? this.courseStartDate,
      courseNum: courseNum ?? this.courseNum,
      lessonNum: lessonNum ?? this.lessonNum,
      discussionDay: discussionDay ?? this.discussionDay,
      curriculumId: curriculumId ?? this.curriculumId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseStartDate': courseStartDate.toString(),
      'courseNum': courseNum,
      'lessonNum': lessonNum,
      'discussionDay': discussionDay,
      'curriculumId': curriculumId,
    };
  }

  factory CourseRelatedData.fromMap(Map<String, dynamic> map) {
    // print("map: $map");
    return CourseRelatedData(
      courseStartDate: DateTime.parse(map['courseStartDate'] as String).toLocal(),
      courseNum: map['courseNum'] as int,
      lessonNum: map['lessonNum'] as int,
      discussionDay: map['discussionDay'] as String,
      curriculumId: map['curriculumId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseRelatedData.fromJson(String source) => CourseRelatedData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CourseRelatedData(courseStartDate: $courseStartDate, courseNum: $courseNum, lessonNum: $lessonNum, discussionDay: $discussionDay, curriculumId: $curriculumId)';
  }

  @override
  bool operator ==(covariant CourseRelatedData other) {
    if (identical(this, other)) return true;
  
    return 
      other.courseStartDate == courseStartDate &&
      other.courseNum == courseNum &&
      other.lessonNum == lessonNum &&
      other.discussionDay == discussionDay &&
      other.curriculumId == curriculumId;
  }

  @override
  int get hashCode {
    return courseStartDate.hashCode ^
      courseNum.hashCode ^
      lessonNum.hashCode ^
      discussionDay.hashCode ^
      curriculumId.hashCode;
  }
}
