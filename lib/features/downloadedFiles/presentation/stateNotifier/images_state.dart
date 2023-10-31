import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';

part 'images_state.freezed.dart';

@freezed
class ImagesState with _$ImagesState {
  const factory ImagesState.initial() = _Initial;
  const factory ImagesState.loading() = _Loading;
  const factory ImagesState.loaded({
    required List<File> images,
  }) = _Loaded;
  const factory ImagesState.empty({required List<File> images}) = _Empty;
  const factory ImagesState.error({required Failure error}) = _Error;
}
