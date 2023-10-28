// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: annotate_overrides, overridden_fields

import '../domain/course_entity.dart';

class CourseModel extends CourseEntity {
  final String courseId;
  final String author;
  final int? id;
  final String category;
  final String courseIds;
  final int noOfRecord;
  final String pdfId;
  final String title;
  final String ustaz;
  final String lastViewed;
  final bool isFav;
  final bool isStarted;
  final bool isFinished;
  final int pausedAtAudioNum;
  final int pausedAtAudioMin;
  final int pdfPage;
  final String image;

  const CourseModel({
    required this.courseId,
    required this.author,
    required this.id,
    required this.category,
    required this.courseIds,
    required this.noOfRecord,
    required this.pdfId,
    required this.title,
    required this.ustaz,
    required this.lastViewed,
    required this.isFav,
    required this.isStarted,
    required this.isFinished,
    required this.pausedAtAudioNum,
    required this.pausedAtAudioMin,
    required this.pdfPage,
    required this.image,
  }) : super(
          id: id,
          courseId: courseId,
          author: author,
          category: category,
          courseIds: courseIds,
          noOfRecord: noOfRecord,
          pdfId: pdfId,
          title: title,
          ustaz: ustaz,
          lastViewed: lastViewed,
          isFav: isFav,
          isStarted: isStarted,
          isFinished: isFinished,
          pausedAtAudioNum: pausedAtAudioNum,
          pausedAtAudioMin: pausedAtAudioMin,
          pdfPage: pdfPage,
          image: image,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
      "image": image,
      'lastViewed': lastViewed,
      'isFav': isFav ? 1 : 0,
      'isStarted': isStarted ? 1 : 0,
      'isFinished': isFinished ? 1 : 0,
      'pausedAtAudioNum': pausedAtAudioNum,
      'pausedAtAudioMin': pausedAtAudioMin,
      'pdfPage': pdfPage,
    };
  }

  factory CourseModel.fromMap(Map map, String id) {
    return CourseModel(
      courseId: id,
      id: map['id'],
      author: map['author'] as String,
      category: map['category'] as String,
      courseIds: map['courseIds'] as String,
      noOfRecord: map['noOfRecord'] as int,
      pdfId: map['pdfId'] as String,
      title: map['title'] as String,
      ustaz: map['ustaz'] as String,
      lastViewed: map['lastViewed'] ?? "",
      isFav: map['isFav'] == 1,
      isStarted: map['isStarted'] == 1,
      isFinished: map['isFinished'] == 1,
      pausedAtAudioNum: map['pausedAtAudioNum'] ?? 0,
      pausedAtAudioMin: map['pausedAtAudioMin'] ?? 0,
      pdfPage: map['pdfPage'] ?? 1,
      image: map['image'],
    );
  }

  CourseModel copyWith({
    String? courseId,
    String? author,
    int? id,
    String? category,
    String? courseIds,
    int? noOfRecord,
    String? pdfId,
    String? title,
    String? ustaz,
    String? lastViewed,
    bool? isFav,
    bool? isStarted,
    bool? isFinished,
    int? pausedAtAudioNum,
    int? pausedAtAudioMin,
    int? pdfPage,
    String? image,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      author: author ?? this.author,
      id: id ?? this.id,
      category: category ?? this.category,
      courseIds: courseIds ?? this.courseIds,
      noOfRecord: noOfRecord ?? this.noOfRecord,
      pdfId: pdfId ?? this.pdfId,
      title: title ?? this.title,
      ustaz: ustaz ?? this.ustaz,
      lastViewed: lastViewed ?? this.lastViewed,
      isFav: isFav ?? this.isFav,
      isStarted: isStarted ?? this.isStarted,
      isFinished: isFinished ?? this.isFinished,
      pausedAtAudioNum: pausedAtAudioNum ?? this.pausedAtAudioNum,
      pausedAtAudioMin: pausedAtAudioMin ?? this.pausedAtAudioMin,
      pdfPage: pdfPage ?? this.pdfPage,
      image: image ?? this.image,
    );
  }
}
