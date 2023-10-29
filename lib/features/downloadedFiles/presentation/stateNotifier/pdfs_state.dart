import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';

part 'pdfs_state.freezed.dart';

@freezed
class PdfsState with _$PdfsState {
  const factory PdfsState.initial() = _Initial;
  const factory PdfsState.loading() = _Loading;
  const factory PdfsState.loaded({
    required List<File> pdfs,
  }) = _Loaded;
  const factory PdfsState.empty({required List<File> pdfs}) =
      _Empty;
  const factory PdfsState.error({required Failure error}) = _Error;
}
