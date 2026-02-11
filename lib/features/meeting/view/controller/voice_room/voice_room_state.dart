// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/meeting/model/discussion.dart';
// import 'package:livekit_client/livekit_client.dart';

enum VoiceRoomStatus {
  initial,
  discussing,
  choice,
  choiceDone,
  short,
  shortDone,
  end,
}

class VoiceRoomState {
  bool isConnecting;
  VoiceRoomStatus status;
  bool pdfShown;
  // Room? room;
  bool isMuted;
  GivenTime? givenTime;
  int discussionSec;
  Timer? timer;
  String identity;
  String roomName;
  ExamData? examData;
  // EventsListener<RoomEvent>? listener;
  AssignedCourse? assignedCourse;

  VoiceRoomState({
    // this.room,
    this.isConnecting = false,
    this.isMuted = false,
    this.pdfShown = false,
    this.discussionSec = 0,
    this.roomName = '',
    this.identity = "",
    this.givenTime,
    this.status = VoiceRoomStatus.initial,
    // this.listener,
    this.timer,
    this.examData,
    this.assignedCourse,
  });

  VoiceRoomState copyWith({
    // Room? room,
    Timer? timer,
    bool? isConnecting,
    bool? isMuted,
    String? identity,
    GivenTime? givenTime,
    String? roomName,
    // EventsListener<RoomEvent>? listener,
    VoiceRoomStatus? status,
    int? discussionSec,
    ExamData? examData,
    bool? pdfShown,
    AssignedCourse? assignedCourse,
  }) {
    return VoiceRoomState(
      // room: room ?? this.room,
      isConnecting: isConnecting ?? this.isConnecting,
      isMuted: isMuted ?? this.isMuted,
      identity: identity ?? this.identity,
      roomName: roomName ?? this.roomName,
      // listener: listener ?? this.listener,
      givenTime: givenTime ?? this.givenTime,
      timer: timer ?? this.timer,
      status: status ?? this.status,
      discussionSec: discussionSec ?? this.discussionSec,
      examData: examData ?? this.examData,
      pdfShown: pdfShown ?? this.pdfShown,
      assignedCourse: assignedCourse ?? this.assignedCourse,
    );
  }
}
