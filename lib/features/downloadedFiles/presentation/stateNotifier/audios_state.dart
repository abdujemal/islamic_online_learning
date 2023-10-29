import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';

part 'audios_state.freezed.dart';

@freezed
class AudiosState with _$AudiosState {
  const factory AudiosState.initial() = _Initial;
  const factory AudiosState.loading() = _Loading;
  const factory AudiosState.loaded({
    required List<File> audios,
  }) = _Loaded;
  const factory AudiosState.empty({required List<File> audios}) = _Empty;
  const factory AudiosState.error({required Failure error}) = _Error;
}
