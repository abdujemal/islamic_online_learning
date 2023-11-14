import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';
import '../../data/model/course_model.dart';

part 'started_list_state.freezed.dart';

@freezed
class StartedListState with _$StartedListState {
  const factory StartedListState.initial() = _Initial;
  const factory StartedListState.loading() = _Loading;
  const factory StartedListState.loaded({
    required List<CourseModel> courses,
  }) = _Loaded;
  const factory StartedListState.empty({required List<CourseModel> courses}) =
      _Empty;
  const factory StartedListState.error({required Failure error}) = _Error;
}
