// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:islamic_online_learning/features/template/model/discussion.dart';
import 'package:livekit_client/livekit_client.dart';

enum VoiceRoomStatus {
  initial,
  discussing,
  choice,
  short,
  end,
}

class VoiceRoomState {
  bool isConnecting;
  VoiceRoomStatus status;
  Room? room;
  bool isMuted;
  GivenTime? givenTime;
  int discussionSec;
  Timer? timer;
  String identity;
  String roomName;
  EventsListener<RoomEvent>? listener;

  VoiceRoomState({
    this.room,
    this.isConnecting = false,
    this.isMuted = false,
    this.discussionSec = 0,
    this.roomName = '',
    this.identity = "",
    this.givenTime,
    this.status = VoiceRoomStatus.initial,
    this.listener,
    this.timer,
  });

  VoiceRoomState copyWith({
    Room? room,
    Timer? timer,
    bool? isConnecting,
    bool? isMuted,
    String? identity,
    GivenTime? givenTime,
    String? roomName,
    EventsListener<RoomEvent>? listener,
    VoiceRoomStatus? status,
    int? discussionSec,
  }) {
    return VoiceRoomState(
      room: room ?? this.room,
      isConnecting: isConnecting ?? this.isConnecting,
      isMuted: isMuted ?? this.isMuted,
      identity: identity ?? this.identity,
      roomName: roomName ?? this.roomName,
      listener: listener ?? this.listener,
      givenTime: givenTime ?? this.givenTime,
      timer: timer ?? this.timer,
      status: status ?? this.status,
      discussionSec: discussionSec ?? this.discussionSec,
    );
  }
}
