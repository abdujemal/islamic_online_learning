import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

import '../../../../core/failure.dart';

part 'fav_list_state.freezed.dart';

@freezed
class FavListState with _$FavListState {
  const factory FavListState.initial() = _Initial;
  const factory FavListState.loading() = _Loading;
  const factory FavListState.loaded({
    required List<CourseModel> courses,
  }) = _Loaded;
  const factory FavListState.empty({required List<CourseModel> courses}) =
      _Empty;
  const factory FavListState.error({required Failure error}) = _Error;
}
