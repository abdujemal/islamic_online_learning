import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';

part 'category_list_state.freezed.dart';

@freezed
class CategoryListState with _$CategoryListState {
  const factory CategoryListState.initial() = _Initial;
  const factory CategoryListState.loading() = _Loading;
  const factory CategoryListState.loaded({
    required List<String> categories,
  }) = _Loaded;
  const factory CategoryListState.empty({required List<String> courses}) =
      _Empty;
  const factory CategoryListState.error({required Failure error}) = _Error;
}
