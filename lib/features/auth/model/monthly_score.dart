class MonthlyScore {//generate model class
  final String id; 
  final String courseId;
  final String curriculumId;
  final String archiveUrl;
  final int endLesson;
  final int startLesson;
  final int month;
  final int score;
  final int outOf;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;

  MonthlyScore({
    required this.id,
    required this.courseId,
    required this.curriculumId,
    required this.archiveUrl,
    required this.endLesson,
    required this.startLesson,
    required this.month,
    required this.score,
    required this.outOf,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'curriculumId': curriculumId,
      'archiveUrl': archiveUrl,
      'endLesson': endLesson,
      'startLesson': startLesson,
      'month': month,
      'score': score,
      'outOf': outOf,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'userId': userId,
    };
  }

  factory MonthlyScore.fromMap(Map<String, dynamic> map) {
    return MonthlyScore(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      curriculumId: map['curriculumId'] as String,
      archiveUrl: map['archiveUrl'] as String,
      endLesson: map['endLesson'] as int,
      startLesson: map['startLesson'] as int,
      month: map['month'] as int,
      score: map['score'] as int,
      outOf: map['outOf'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      userId: map['userId'] as String,
    );
  }

}