import 'dart:io';

class AudiosState {
  final bool isLoading;
  final List<File> audios;
  final String? error;

  AudiosState({
    this.isLoading = false,
    this.audios = const [],
    this.error,
  });

  AudiosState copyWith({
    bool? isLoading,
    List<File>? audios,
    String? error,
  }) {
    return AudiosState(
      isLoading: isLoading ?? this.isLoading,
      audios: audios ?? this.audios,
      error: error,
    );
  }
}
