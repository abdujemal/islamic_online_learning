// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';

import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/pdfs_state.dart';

class PdfsNotifier extends StateNotifier<PdfsState> {
  final DFRepo dfRepo;
  PdfsNotifier(
    this.dfRepo,
  ) : super(const PdfsState.initial());

  getPdfs() async {
    state = const PdfsState.loading();
    final res = await dfRepo.getPdfs();

    res.fold(
      (l) {
        state = PdfsState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = PdfsState.empty(pdfs: r);
          return;
        }
        state = PdfsState.loaded(pdfs: r);
      },
    );
  }

  Future<void> deleteAllFiles() async {
    toast("deleting...", ToastType.normal);

    final res = await dfRepo.deleteAllFiles("PDF");

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
