// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: annotate_overrides, overridden_fields

import 'dart:convert';

import '../../domain/entity/course_entity.dart';

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
  final int isFav;
  final int isStarted;
  final int isFinished;
  final int pausedAtAudioNum;
  final int pausedAtAudioSec;
  final double pdfPage;
  final double pdfNum;
  final String sheduleTime;
  final String sheduleDates;
  final String image;
  final int totalDuration;

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
    required this.pausedAtAudioSec,
    required this.sheduleDates,
    required this.sheduleTime,
    required this.pdfPage,
    required this.pdfNum,
    required this.image,
    required this.totalDuration,
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
          pausedAtAudioSec: pausedAtAudioSec,
          sheduleDates: sheduleDates,
          sheduleTime: sheduleTime,
          pdfPage: pdfPage,
          pdfNum: pdfNum,
          image: image,
          totalDuration: totalDuration,
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
      'image': image,
      'lastViewed': lastViewed,
      'isFav': isFav,
      'isStarted': isStarted,
      'isFinished': isFinished,
      'pausedAtAudioNum': pausedAtAudioNum,
      'pausedAtAudioSec': pausedAtAudioSec,
      'sheduleDates': sheduleDates,
      'sheduleTime': sheduleTime,
      'pdfPage': pdfPage,
      'pdfNum': pdfNum,
      'totalDuration': totalDuration
    };
  }

  Map<String, dynamic> toOriginalMap() {
    return {
      'courseId': courseId,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
      'image': image,
      'totalDuration': totalDuration
    };
  }

  factory CourseModel.fromMap(Map map, String id, {CourseModel? copyFrom}) {
    return CourseModel(
      courseId: id,
      id: map['id'] ?? (copyFrom?.id),
      author: map['author'] as String,
      category: map['category'] as String,
      courseIds: map['courseIds'] as String,
      noOfRecord: map['noOfRecord'] as int,
      pdfId: map['pdfId'] as String,
      title: map['title'] as String,
      ustaz: map['ustaz'] as String,
      lastViewed:
          map['lastViewed'] ?? (copyFrom != null ? copyFrom.lastViewed : ""),
      isFav: map['isFav'] ?? (copyFrom != null ? copyFrom.isFav : 0),
      isStarted:
          map['isStarted'] ?? (copyFrom != null ? copyFrom.isStarted : 0),
      isFinished:
          map['isFinished'] ?? (copyFrom != null ? copyFrom.isFinished : 0),
      pausedAtAudioNum: map['pausedAtAudioNum'] ??
          (copyFrom != null ? copyFrom.pausedAtAudioNum : 0),
      pausedAtAudioSec: map['pausedAtAudioSec'] ??
          (copyFrom != null ? copyFrom.pausedAtAudioSec : 0),
      sheduleDates: map['sheduleDates'] ??
          (copyFrom != null ? copyFrom.sheduleDates : ""),
      sheduleTime:
          map['sheduleTime'] ?? (copyFrom != null ? copyFrom.sheduleTime : ""),
      pdfPage: map['pdfPage'] ?? (copyFrom != null ? copyFrom.pdfPage : 0.0),
      pdfNum: map['pdfNum'] ?? (copyFrom != null ? copyFrom.pdfNum : 1),
      image: map['image'],
      totalDuration: map["totalDuration"] ?? 0,
    );
  }

  CourseModel copyWith(
      {String? courseId,
      String? author,
      int? id,
      String? category,
      String? courseIds,
      int? noOfRecord,
      String? pdfId,
      String? title,
      String? ustaz,
      String? lastViewed,
      int? isFav,
      int? isStarted,
      int? isFinished,
      int? pausedAtAudioNum,
      int? pausedAtAudioSec,
      String? sheduleDates,
      String? sheduleTime,
      double? pdfPage,
      double? pdfNum,
      String? image,
      int? totalDuration}) {
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
      pausedAtAudioSec: pausedAtAudioSec ?? this.pausedAtAudioSec,
      sheduleDates: sheduleDates ?? this.sheduleDates,
      sheduleTime: sheduleTime ?? this.sheduleTime,
      pdfPage: pdfPage ?? this.pdfPage,
      pdfNum: pdfNum ?? this.pdfNum,
      image: image ?? this.image,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  String toJsonString() => json.encode(toMap());

  CourseModel fromJsonString(String jsn, String id) =>
      CourseModel.fromMap(json.decode(jsn), id);
}
