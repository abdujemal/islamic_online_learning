// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:livekit_client/livekit_client.dart';

class VoiceRoomState {
  bool isConnecting;
  Room? room;
  bool isMuted;
  int totalSeconds;
  List<dynamic> participants;
  Timer? timer;
  String identity;
  String roomName;
  EventsListener<RoomEvent>? listener;

  VoiceRoomState({
    this.room,
    this.isConnecting = false,
    this.isMuted = false,
    this.participants = const [],
    this.roomName = '',
    this.identity = "",
    this.totalSeconds = 0,
    this.listener,
    this.timer,
  });

  VoiceRoomState copyWith({
    Room? room,
    Timer? timer,
    bool? isConnecting,
    bool? isMuted,
    List<dynamic>? participants,
    String? identity,
    int? totalSeconds,
    String? roomName,
    EventsListener<RoomEvent>? listener,
  }) {
    return VoiceRoomState(
      room: room ?? this.room,
      isConnecting: isConnecting ?? this.isConnecting,
      isMuted: isMuted ?? this.isMuted,
      participants: participants ?? this.participants,
      identity: identity ?? this.identity,
      roomName: roomName ?? this.roomName,
      listener: listener ?? this.listener,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      timer: timer ?? this.timer,
    );
  }
}
