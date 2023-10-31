import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:islamic_online_learning/features/main/data/model/faq_model.dart';

import '../../../../core/failure.dart';

part 'faq_list_state.freezed.dart';

@freezed
class FAQListState with _$FAQListState {
  const factory FAQListState.initial() = _Initial;
  const factory FAQListState.loading() = _Loading;
  const factory FAQListState.loaded({
    required List<FAQModel> faqs,
  }) = _Loaded;
  const factory FAQListState.empty({required List<FAQModel> faqs}) = _Empty;
  const factory FAQListState.error({required Failure error}) = _Error;
}
