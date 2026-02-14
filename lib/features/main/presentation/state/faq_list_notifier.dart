import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/faq_list_state.dart';

class FaqListNotifier extends StateNotifier<FaqListState> {
  MainRepo mainRepo;
  FaqListNotifier(this.mainRepo) : super(FaqListState());

  getFAQs() async {
    state = state.copyWith(isLoading: true);
    final res = await mainRepo.getFAQ();

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        state = state.copyWith(isLoading: false, faqs: r);
      },
    );
  }
}
