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
  final int isFav;
  final int isStarted;
  final int isFinished;
  final int pausedAtAudioNum;
  final int pausedAtAudioSec;
  final String sheduleTime;
  final String sheduleDates;
  final double pdfPage;
  final double pdfNum;
  final String image;
  final int totalDuration;

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
    required this.pausedAtAudioSec,
    required this.sheduleTime,
    required this.sheduleDates,
    required this.pdfPage,
    required this.pdfNum,
    required this.image,
    required this.totalDuration,
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
        pausedAtAudioSec,
        pausedAtAudioNum,
        sheduleDates,
        sheduleTime,
        pdfPage,
        pdfNum,
        image,
        totalDuration,
      ];
}
