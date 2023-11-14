// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/audios_state.dart';

import '../../../../core/constants.dart';



class AudiosNotifier extends StateNotifier<AudiosState> {
  final DFRepo dfRepo;
  AudiosNotifier(
    this.dfRepo,
  ) : super(const AudiosState.initial());



  getAudios() async {
    state = const AudiosState.loading();
    final res = await dfRepo.getAudios();

    res.fold(
      (l) {
        state = AudiosState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = AudiosState.empty(audios: r);
          return;
        }

        state = AudiosState.loaded(audios: r);
      },
    );
  }

  Future<void> deleteAllFiles() async {
    toast("deleting...", ToastType.normal);
    final res = await dfRepo.deleteAllFiles("Audio");

    res.fold(
      (l) {
        toast(l.toString(), ToastType.error);
      },
      (r) {
        toast("ሁሉም ፋይሎች ጠፍትዋል", ToastType.success);
      },
    );
  }
}
