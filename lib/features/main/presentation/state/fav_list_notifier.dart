import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/fav_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

import '../../../../core/constants.dart';

class FavListNotifier extends StateNotifier<FavListState> {
  final MainRepo mainRepo;
  final Ref ref;
  FavListNotifier(this.mainRepo, this.ref) : super(FavListState());

  getCourse() async {
    state = state.copyWith(isLoading: true);

    final res = await mainRepo.getFavoriteCourses();

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        state = state.copyWith(isLoading: false, courses: r);
      },
    );
  }

  deleteCourse(int? id, BuildContext context) async {
    if (id != null) {
      final res = await mainRepo.deleteCourse(id);

      res.fold(
        (l) {
          toast(l.messege, ToastType.error, context);
        },
        (r) {
          toast("በተሳካ ሁኔታ ጠፍቷል", ToastType.success, context);
          getCourse();
          ref.read(mainNotifierProvider.notifier).updateCourses();
          ref.read(startedNotifierProvider.notifier).getCouses();
        },
      );
    } else {
      toast("መጥፋት አይቻልም", ToastType.error, context);
    }
  }
}
