// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';

import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/pdfs_state.dart';

class PdfsNotifier extends StateNotifier<PdfsState> {
  final DFRepo dfRepo;
  PdfsNotifier(
    this.dfRepo,
  ) : super(PdfsState());

  getPdfs() async {
    state = state.copyWith(isLoading: true);
    final res = await dfRepo.getPdfs();

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        state = state.copyWith(isLoading: false, pdf: r);
      },
    );
  }

  Future<void> deleteAllFiles(BuildContext context) async {
    toast("deleting...", ToastType.normal, context);

    final res = await dfRepo.deleteAllFiles("PDF");

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
