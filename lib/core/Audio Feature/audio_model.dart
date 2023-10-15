import 'package:equatable/equatable.dart';

class AudioModel extends Equatable {
  final String title;
  final String ustaz;
  final double min;
  final AudioState audioState;
  const AudioModel({
    required this.title,
    required this.min,
    required this.audioState,
    required this.ustaz,
  });

  copyWith({
    String? title,
    double? min,
    AudioState? audioState,
    String? ustaz,
  }) {
    return AudioModel(
      title: title ?? this.title,
      min: min ?? this.min,
      audioState: audioState ?? this.audioState,
      ustaz: ustaz ?? this.ustaz,
    );
  }

  @override
  List<Object?> get props => [
        title,
        min,
        audioState,
      ];
}

enum AudioState { idle, playing, paused }

extension AudioModifier on AudioState {
  isPlaying() => this == AudioState.playing;
  isPlaused() => this == AudioState.paused;
  isIdle() => this == AudioState.idle;
}
