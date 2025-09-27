import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_state.dart';

class UstazListNotifier extends StateNotifier<UstazListState> {
  final MainRepo mainRepo;
  UstazListNotifier(this.mainRepo) : super(UstazListState());

  Future<void> getUstaz() async {
    state = state.copyWith(isLoading: true);

    final res = await mainRepo.getUstazs();

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);

        // state = UstazListState.error(error: l);
      },
      (r) {
        if (kDebugMode) {
          print("loaded");
        }
        if (r.isEmpty) {
          state = state.copyWith(isLoading: false, ustazs: r);

          return;
        }
        state = state.copyWith(isLoading: false, ustazs: r);
      },
    );
  }
}
