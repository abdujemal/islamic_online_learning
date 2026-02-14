import 'dart:io';

class PdfsState {
  final bool isLoading;
  final List<File> pdf;
  final String? error;

  PdfsState({
    this.isLoading = false,
    this.pdf = const [],
    this.error,
  });

  PdfsState copyWith({
    bool? isLoading,
    List<File>? pdf,
    String? error,
  }) {
    return PdfsState(
      isLoading: isLoading ?? this.isLoading,
      pdf: pdf ?? this.pdf,
      error: error,
    );
  }
}
