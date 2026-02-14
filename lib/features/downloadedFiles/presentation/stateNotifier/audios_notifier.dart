// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/audios_state.dart';

import '../../../../core/constants.dart';

class AudiosNotifier extends StateNotifier<AudiosState> {
  final DFRepo dfRepo;
  AudiosNotifier(
    this.dfRepo,
  ) : super(AudiosState());

  getAudios() async {
    state = state.copyWith(isLoading: true);
    final res = await dfRepo.getAudios();

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        state = state.copyWith(isLoading: false, audios: r);
      },
    );
  }

  Future<void> deleteAllFiles(BuildContext context) async {
    toast("deleting...", ToastType.normal, context);
    final res = await dfRepo.deleteAllFiles("Audio");

    res.fold(
      (l) {
        toast(l.toString(), ToastType.error, context);
      },
      (r) {
        toast("ሁሉም ፋይሎች ጠፍቷል", ToastType.success, context);
      },
    );
  }
}
