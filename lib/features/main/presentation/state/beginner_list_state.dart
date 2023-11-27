// import 'package:islamic_online_learning/features/main/data/model/faq_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/failure.dart';
import '../../data/model/course_model.dart';

part 'beginner_list_state.freezed.dart';

@freezed
class BeginnerListState with _$BeginnerListState {
  const factory BeginnerListState.initial() = _Initial;
  const factory BeginnerListState.loading() = _Loading;
  const factory BeginnerListState.loaded({
    required List<CourseModel> courses,
  }) = _Loaded;
  const factory BeginnerListState.empty({required List<CourseModel> courses}) =
      _Empty;
  const factory BeginnerListState.error({required Failure error}) = _Error;
}
