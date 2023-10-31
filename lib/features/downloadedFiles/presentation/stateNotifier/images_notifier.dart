// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';

import '../../../../core/constants.dart';
import 'images_state.dart';

class ImagesNotifier extends StateNotifier<ImagesState> {
  final DFRepo dfRepo;
  ImagesNotifier(
    this.dfRepo,
  ) : super(const ImagesState.initial());

  getImages() async {
    state = const ImagesState.loading();
    final res = await dfRepo.getImages();

    res.fold(
      (l) {
        state = ImagesState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = ImagesState.empty(images: r);
          return;
        }
        state = ImagesState.loaded(images: r);
      },
    );
  }

  Future<void> deleteAllFiles() async {
    toast("deleting...", ToastType.normal);
    final res = await dfRepo.deleteAllFiles("Images");

    res.fold(
      (l) {
        toast(l.toString(), ToastType.error);
      },
      (r) {
        toast("ሁሉም ፒዲኡፍ ጠፍትዋል", ToastType.success);
      },
    );
  }
}
