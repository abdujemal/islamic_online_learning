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
  final bool isDownloaded;
  final int audioMin;
  final int pdfPage;

  const CourseModel({
    required this.isDownloaded,
    required this.lastViewed,
    required this.isFav,
    required this.id,
    required this.author,
    required this.category,
    required this.courseIds,
    required this.noOfRecord,
    required this.pdfId,
    required this.title,
    required this.ustaz,
    required this.courseId,
    required this.audioMin,
    required this.pdfPage,
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
          isDownloaded: isDownloaded,
          audioMin: audioMin,
          pdfPage: pdfPage,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': id,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
      'lastViewed': lastViewed,
      'isFav': isFav ? 1 : 0,
      'isDownloaded': isDownloaded ? 1 : 0,
      'audioMin': audioMin,
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
      isFav: map['isFav'] ?? false,
      isDownloaded: map['isDownloaded'] ?? false,
      audioMin: map['audioMin'] ?? 0,
      pdfPage: map['pdfPage'] ?? 1,
    );
  }
}
