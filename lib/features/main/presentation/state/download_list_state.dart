import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';
import '../../data/model/course_model.dart';

part 'download_list_state.freezed.dart';

@freezed
class DownloadListState with _$DownloadListState {
  const factory DownloadListState.initial() = _Initial;
  const factory DownloadListState.loading() = _Loading;
  const factory DownloadListState.loaded({
    required List<CourseModel> courses,
  }) = _Loaded;
  const factory DownloadListState.empty({required List<CourseModel> courses}) =
      _Empty;
  const factory DownloadListState.error({required Failure error}) = _Error;
}