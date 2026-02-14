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
  final String audioSizes;
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
  final int isScheduleOn;
  final double pdfPage;
  final double pdfNum;
  final String scheduleTime;
  final String scheduleDates;
  final String image;
  final int totalDuration;
  final int isCompleted;
  final int isBeginner;
  final String dateTime;

  const CourseModel({
    required this.courseId,
    required this.author,
    required this.id,
    required this.category,
    required this.courseIds,
    required this.audioSizes,
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
    required this.scheduleDates,
    required this.scheduleTime,
    required this.isScheduleOn,
    required this.pdfPage,
    required this.pdfNum,
    required this.image,
    required this.dateTime,
    required this.totalDuration,
    required this.isCompleted,
    required this.isBeginner,
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
          isScheduleOn: isScheduleOn,
          pausedAtAudioNum: pausedAtAudioNum,
          pausedAtAudioSec: pausedAtAudioSec,
          scheduleDates: scheduleDates,
          scheduleTime: scheduleTime,
          pdfPage: pdfPage,
          pdfNum: pdfNum,
          image: image,
          totalDuration: totalDuration,
          audioSizes: audioSizes,
          isCompleted: isCompleted,
          isBeginner: isBeginner,
          dateTime: dateTime,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      "audioSizes": audioSizes,
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
      "scheduleDates": scheduleDates,
      "scheduleTime": scheduleTime,
      'isScheduleOn': isScheduleOn,
      'pdfPage': pdfPage,
      'pdfNum': pdfNum,
      'totalDuration': totalDuration,
      "isCompleted": isCompleted,
      'isBeginner': isBeginner,
      'dateTime': dateTime,
    };
  }

  Map<String, dynamic> toOriginalMap() {
    return {
      'courseId': courseId,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      'audioSizes': audioSizes,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
      'image': image,
      'totalDuration': totalDuration,
      "isCompleted": isCompleted,
      'dateTime': dateTime,
      'isBeginner': isBeginner,
    };
  }

  factory CourseModel.fromMap(Map map, String id,
      {CourseModel? copyFrom, bool urlIsList = false}) {
    return CourseModel(
      courseId: id,
      id: map['id'] ?? (copyFrom?.id),
      author: map['author'] as String,
      category: map['category'] as String,
      courseIds: urlIsList
          ? (map['courseIds'] as List<String>).join(",")
          : map['courseIds'] as String,
      audioSizes: map['audioSizes'] ??
          List.generate(map['courseIds'].toString().split(",").length,
              (index) => index).join(","),
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
      scheduleDates: map['scheduleDates'] ??
          (copyFrom != null ? copyFrom.scheduleDates : ""),
      scheduleTime: map['scheduleTime'] ??
          (copyFrom != null ? copyFrom.scheduleTime : ""),
      dateTime: map['dateTime'],
      isScheduleOn:
          map['isScheduleOn'] ?? (copyFrom != null ? copyFrom.isScheduleOn : 0),
      pdfPage: map['pdfPage'] ?? (copyFrom != null ? copyFrom.pdfPage : 0.0),
      pdfNum: map['pdfNum'] ?? (copyFrom != null ? copyFrom.pdfNum : 1),
      image: map['image'],
      totalDuration: map["totalDuration"] ?? 0,
      isCompleted: map['isCompleted'] ?? 1,
      isBeginner: map['isBeginner'] == true || map['isBeginner'] == 1 ? 1 : 0,
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
      int? isScheduleOn,
      String? scheduleDates,
      String? scheduleTime,
      double? pdfPage,
      double? pdfNum,
      String? image,
      String? audioSizes,
      int? isCompleted,
      String? dateTime,
      int? isBeginner,
      int? totalDuration}) {
    return CourseModel(
        courseId: courseId ?? this.courseId,
        author: author ?? this.author,
        id: id ?? this.id,
        isBeginner: isBeginner ?? this.isBeginner,
        category: category ?? this.category,
        courseIds: courseIds ?? this.courseIds,
        audioSizes: audioSizes ?? this.audioSizes,
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
        scheduleDates: scheduleDates ?? this.scheduleDates,
        scheduleTime: scheduleTime ?? this.scheduleTime,
        isScheduleOn: isScheduleOn ?? this.isScheduleOn,
        pdfPage: pdfPage ?? this.pdfPage,
        pdfNum: pdfNum ?? this.pdfNum,
        image: image ?? this.image,
        totalDuration: totalDuration ?? this.totalDuration,
        isCompleted: isCompleted ?? this.isCompleted,
        dateTime: dateTime ?? this.dateTime);
  }

  String toJsonString() => json.encode(toMap());

  CourseModel fromJsonString(String jsn, String id) =>
      CourseModel.fromMap(json.decode(jsn), id);
}
