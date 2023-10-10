import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';

part 'ustaz_list_state.freezed.dart';

@freezed
class UstazListState with _$UstazListState {
  const factory UstazListState.initial() = _Initial;
  const factory UstazListState.loading() = _Loading;
  const factory UstazListState.loaded({
    required List<String> ustazs,
  }) = _Loaded;
  const factory UstazListState.empty({required List<String> ustazs}) =
      _Empty;
  const factory UstazListState.error({required Failure error}) = _Error;
}
