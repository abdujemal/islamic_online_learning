
import 'package:islamic_online_learning/features/main/data/model/faq_model.dart';

class FaqListState {
  final bool isLoading;
  final List<FAQModel> faqs;
  final String? error;

  FaqListState({
    this.isLoading = false,
    this.faqs = const [],
    this.error,
  });

  FaqListState copyWith({
    bool? isLoading,
    List<FAQModel>? faqs,
    String? error,
  }) {
    return FaqListState(
      isLoading: isLoading ?? this.isLoading,
      faqs: faqs ?? this.faqs,
      error: error,
    );
  }
}
