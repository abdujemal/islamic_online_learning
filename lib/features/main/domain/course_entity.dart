import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final int? id;
  final String author;
  final String category;
  final String courseIds;
  final String courseId;
  final int noOfRecord;
  final String pdfId;
  final String title;
  final String ustaz;
  final String lastViewed;
  final bool isFav;
  final bool isDownloaded;
  final int audioMin;
  final int pdfPage;

  const CourseEntity({
    required this.courseId,
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
    required this.audioMin,
    required this.pdfPage,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        author,
        category,
        courseIds,
        noOfRecord,
        pdfId,
        title,
        ustaz,
        lastViewed,
        isFav,
        isDownloaded,
        audioMin,
        pdfPage,
      ];
}
