import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/faq_list_state.dart';

class FaqListNotifier extends StateNotifier<FAQListState> {
  MainRepo mainRepo;
  FaqListNotifier(this.mainRepo) : super(const FAQListState.initial());

  getFAQs() async {
    state = const FAQListState.loading();

    final res = await mainRepo.getFAQ();

    res.fold(
      (l) {
        state = FAQListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = FAQListState.empty(faqs: r);
        } else {
          state = FAQListState.loaded(faqs: r);
        }
      },
    );
  }
}
