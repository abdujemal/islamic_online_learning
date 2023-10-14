import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/fav_list_state.dart';

import '../../../../core/constants.dart';

class FavListNotifier extends StateNotifier<FavListState> {
  final MainRepo mainRepo;
  FavListNotifier(this.mainRepo) : super(const FavListState.initial());

  getCourse() async {
    state = const FavListState.loading();

    final res = await mainRepo.getFavoriteCourses();

    res.fold(
      (l) {
        state = FavListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = FavListState.empty(courses: r);
        } else {
          state = FavListState.loaded(courses: r);
        }
      },
    );
  }

  deleteCourse(int? id) async {
    if (id != null) {
      final res = await mainRepo.deleteCourse(id);

      res.fold(
        (l) {
          toast(l.messege, ToastType.error);
        },
        (r) {
          toast("በተሳካ  ሁኔታ ጠፍትዋ", ToastType.success);
          getCourse();
        },
      );
    } else {
      toast("መጥፋት አይቻልም", ToastType.error);
    }
  }
}
