// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: annotate_overrides, overridden_fields

import 'dart:convert';

import '../../domain/course_entity.dart';


class CourseModel extends CourseEntity {
  final String author;
  final String category;
  final String courseIds;
  final int noOfRecord;
  final String pdfId;
  final String title;
  final String ustaz;
  const CourseModel({
    required this.author,
    required this.category,
    required this.courseIds,
    required this.noOfRecord,
    required this.pdfId,
    required this.title,
    required this.ustaz,
  }) : super(
          author: author,
          category: category,
          courseIds: courseIds,
          noOfRecord: noOfRecord,
          pdfId: pdfId,
          title: title,
          ustaz: ustaz,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'category': category,
      'courseIds': courseIds,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
    };
  }

  factory CourseModel.fromMap(Map map) {
    return CourseModel(
      author: map['author'] as String,
      category: map['category'] as String,
      courseIds: map['courseIds'] as String,
      noOfRecord: map['noOfRecord'] as int,
      pdfId: map['pdfId'] as String,
      title: map['title'] as String,
      ustaz: map['ustaz'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}