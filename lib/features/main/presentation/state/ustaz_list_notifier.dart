import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_state.dart';

class UstazListNotifier extends StateNotifier<UstazListState> {
  final MainRepo mainRepo;
  UstazListNotifier(this.mainRepo) : super(const UstazListState.initial());

   Future<void> getUstaz() async {
    state = const UstazListState.loading();

    final res = await mainRepo.getUstazs();

    res.fold(
      (l) {
        state = UstazListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = UstazListState.empty(ustazs: r);
          return;
        }
        state = UstazListState.loaded(ustazs: r);
      },
    );
  }
}
