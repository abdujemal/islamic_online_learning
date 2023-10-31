import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

import '../../../../core/failure.dart';

part 'main_list_state.freezed.dart';

@freezed
class MainListState with _$MainListState {
  const factory MainListState.initial() = _Initial;
  const factory MainListState.loading() = _Loading;
  const factory MainListState.loaded({
    required List<CourseModel> courses,
    required bool noMoreToLoad,
    required bool isLoadingMore,
  }) = _Loaded;
  const factory MainListState.empty({required List<CourseModel> courses}) =
      _Empty;
  const factory MainListState.error({required Failure error}) = _Error;
}
