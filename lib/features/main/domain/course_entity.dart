// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String author;
  final String category;
  final String courseIds;
  final int noOfRecord;
  final String pdfId;
  final String title;
  final String ustaz;
  const CourseEntity({
    required this.author,
    required this.category,
    required this.courseIds,
    required this.noOfRecord,
    required this.pdfId,
    required this.title,
    required this.ustaz,
  });

  @override
  List<Object?> get props => [
        author,
        category,
        courseIds,
        noOfRecord,
        pdfId,
        title,
        ustaz,
      ];
}
