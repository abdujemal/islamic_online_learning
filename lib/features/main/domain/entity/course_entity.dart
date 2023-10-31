// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final bool isStarted;
  final bool isFinished;
  final int pausedAtAudioNum;
  final int pausedAtAudioMin;
  final int pdfPage;
  final String image;

  const CourseEntity({
    required this.id,
    required this.author,
    required this.category,
    required this.courseIds,
    required this.courseId,
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
        isStarted,
        isFinished,
        pausedAtAudioMin,
        pausedAtAudioNum,
        pdfPage,
        image,
      ];
}