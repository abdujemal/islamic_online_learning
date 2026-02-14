// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

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

class AudioData {
  final ProcessingState processingState;
  final SequenceState? sequenceState;
  AudioData({
    required this.processingState,
    this.sequenceState,
  });
}

class AudioTrack {
  final String id;
  final String courseId;
  final String title;
  final String ustaz;
  final String url; // remote URL
  final String category;
  final String image;
  final String? localPath; // filled when downloaded
  final bool isDownloading;
  CancelToken cancelToken = CancelToken();

  AudioTrack({
    required this.id,
    required this.courseId,
    required this.title,
    required this.ustaz,
    required this.url,
    required this.image,
    required this.category,
    this.localPath,
    this.isDownloading = false,
  });

  AudioTrack copyWith({
    String? localPath,
    bool? isDownloading,
  }) {
    return AudioTrack(
      id: id,
      courseId: courseId,
      title: title,
      url: url,
      ustaz: ustaz,
      category: category,
      image: image,
      localPath: localPath ?? this.localPath,
      isDownloading: isDownloading ?? this.isDownloading,
    );
  }
}
