import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/downloadedFiles/data/d_f_data_src.dart';
import 'package:islamic_online_learning/features/downloadedFiles/data/d_f_repo_impl.dart';
import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/audios_notifier.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/audios_state.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/images_notifier.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/images_state.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/pdfs_notifier.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/pdfs_state.dart';

final dFDataSrcProvider = Provider<DFDataSrc>((ref) {
  return DFDataSrcImpl();
});

final dFRepoProvider = Provider<DFRepo>((ref) {
  return DFRepoImpl(dfDataSrc: ref.read(dFDataSrcProvider));
});

final audiosNotifierProvider =
    StateNotifierProvider<AudiosNotifier, AudiosState>((ref) {
  return AudiosNotifier(ref.read(dFRepoProvider));
});

final pdfsNotifierProvider =
    StateNotifierProvider<PdfsNotifier, PdfsState>((ref) {
  return PdfsNotifier(ref.read(dFRepoProvider));
});

final imagesNotifierProvider =
    StateNotifierProvider<ImagesNotifier, ImagesState>((ref) {
  return ImagesNotifier(ref.read(dFRepoProvider));
});
