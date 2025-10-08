import 'dart:convert';

class CourseRelatedData {
  final DateTime courseStartDate;
  final int courseNum;
  final int lessonNum;
  final String discussionDay;
  CourseRelatedData({
    required this.courseStartDate,
    required this.courseNum,
    required this.lessonNum,
    required this.discussionDay,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseStartDate': courseStartDate.millisecondsSinceEpoch,
      'courseNum': courseNum,
      'lessonNum': lessonNum,
      'discussionDay': discussionDay,
    };
  }

  factory CourseRelatedData.fromMap(Map<String, dynamic> map) {
    return CourseRelatedData(
      courseStartDate:
          DateTime.parse(map["group"]['courseStartDate'] as String),
      courseNum: map["group"]['courseNum'] as int,
      lessonNum: map["group"]['lessonNum'] as int,
      discussionDay: map["group"]['discussionDay'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseRelatedData.fromJson(String source) =>
      CourseRelatedData.fromMap(json.decode(source) as Map<String, dynamic>);
}
