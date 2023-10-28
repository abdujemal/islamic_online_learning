// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AudioModel extends Equatable {
  final String title;
  final String ustaz;
  final AudioState audioState;
  final String audioId;
  const AudioModel({
    required this.title,
    required this.ustaz,
    required this.audioState,
    required this.audioId,
  });

  copyWith({
    String? title,
    AudioState? audioState,
    String? ustaz,
    String? audioId,
  }) {
    return AudioModel(
      title: title ?? this.title,
      audioState: audioState ?? this.audioState,
      ustaz: ustaz ?? this.ustaz,
      audioId: audioId ?? this.audioId,
    );
  }

  @override
  List<Object?> get props => [
        title,
        ustaz,
        audioState,
        audioId,
      ];
}

enum AudioState { idle, playing, paused }

extension AudioModifier on AudioState {
  isPlaying() => this == AudioState.playing;
  isPlaused() => this == AudioState.paused;
  isIdle() => this == AudioState.idle;
}
