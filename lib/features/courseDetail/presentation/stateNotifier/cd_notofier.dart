import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

import '../../../../core/Audio Feature/audio_model.dart';
import '../../../../core/Audio Feature/audio_providers.dart';

class CDNotifier extends StateNotifier<bool> {
  final CourseDetailRepo courseDetailRepo;
  final Ref ref;
  CDNotifier(this.courseDetailRepo, this.ref) : super(true);

  Future<File?> downloadFile(
      String fileId, String fileName, String folderName) async {
    toast("Loading...", ToastType.normal);
    final res =
        await courseDetailRepo.downloadFile(fileId, fileName, folderName, ref);

    File? file;

    res.fold(
      (l) {
        toast(l.messege, ToastType.error);
      },
      (r) {
        file = r;
      },
    );

    return file;
  }

  Future<String?> loadFileOnline(String fileId) async {
    final res = await courseDetailRepo.loadFileOnline(fileId);

    String? url;

    res.fold(
      (l) {
        toast(l.messege, ToastType.error);
      },
      (r) {
        url = r;
      },
    );

    return url;
  }

  Future<bool> isDownloaded(String fileName, String folderName) async {
    bool isAvailable = false;
    final res =
        await courseDetailRepo.checkIfTheFileIsDownloaded(fileName, folderName);

    res.fold(
      (l) {
        toast(l.toString(), ToastType.error);
      },
      (r) {
        isAvailable = r;
      },
    );

    return isAvailable;
  }

  Future<bool> deleteFile(String fileName, String folderName) async {
    bool isDeleted = false;

    final res = await courseDetailRepo.deleteFile(fileName, folderName);

    res.fold(
      (l) {
        toast(l.toString(), ToastType.error);
        isDeleted = false;
      },
      (r) {
        isDeleted = true;
      },
    );

    return isDeleted;
  }

  playOffline(String audioPath, String title, CourseModel courseModel, String audioId) async {
    ref.read(startListnersProvider);
    ref.read(audioProvider).play(DeviceFileSource(audioPath));

    ref.read(currentAudioProvider.notifier).update(
          (state) => AudioModel(
            title: title,
            ustaz: courseModel.ustaz,
            audioState: AudioState.playing,
            audioId: audioId,
          ),
        );

    ref.read(currentCourseProvider.notifier).update((state) => courseModel);
  }

  playOnline(String url, String title, CourseModel courseModel, String audioId) async {
    ref.read(startListnersProvider);
    ref.read(audioProvider).play(UrlSource(url));

    ref.read(currentAudioProvider.notifier).update(
          (state) => AudioModel(
            title: title,
            ustaz: courseModel.ustaz,
            audioState: AudioState.playing,
            audioId: audioId
          ),
        );

    ref.read(currentCourseProvider.notifier).update((state) => courseModel);
  }
}
