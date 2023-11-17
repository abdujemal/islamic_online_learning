import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/downloaded_files_page.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

import '../../../../core/Audio Feature/audio_providers.dart';

class CDNotifier extends StateNotifier<bool> {
  final CourseDetailRepo courseDetailRepo;
  final Ref ref;
  CDNotifier(this.courseDetailRepo, this.ref) : super(true);

  Future<File?> downloadFile(
    String fileId,
    String fileName,
    String folderName,
    CancelToken cancelToken,
    BuildContext context,
  ) async {
    toast("ትንሽ ይጠብቁን...", ToastType.normal);
    final res = await courseDetailRepo.downloadFile(
        fileId, fileName, folderName, cancelToken, ref);

    File? file;

    res.fold(
      (l) {
        if (!l.messege.contains("[request cancelled]")) {
          if (l.messege.contains("Failed host lookup")) {
            toast("እባክዎ ኢንተርኔትዎን ያብሩ!", ToastType.error, isLong: true);
          } else {
            print(l.messege);
          }
        } else if (l.messege == "out of storage") {
          toast("ስልክዎ ስለሞላ የተወሰነ ፋይሎችን ያጥፉ!", ToastType.error);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const DownloadedFilesPage(),
            ),
          );
        }
      },
      (r) {
        file = r;
      },
    );

    return file;
  }

  Future<String?> loadFileOnline(
    String fileId,
    bool isAudio, {
    bool showError = true,
  }) async {
    final res = await courseDetailRepo.loadFileOnline(fileId, isAudio);

    String? url;
   
    res.fold(
      (l) {
        if (showError) {
          toast("እባክዎ ኢንተርኔትዎን ያብሩ!", ToastType.error, isLong: true);
        }
        print(l.messege);
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
        toast(l.messege, ToastType.error);
        isDeleted = false;
      },
      (r) {
        isDeleted = true;
      },
    );

    return isDeleted;
  }

  playOffline(String audioPath, String title, CourseModel courseModel,
      String audioId) async {
    // ref.read(audioProvider).setFilePath(audioPath);
    ref
        .read(audioProvider.notifier)
        .update((state) => state..setFilePath(audioPath));

    ref.read(audioProvider).play();
  }

  Future<void> playOnline(
      String url, String title, CourseModel courseModel, String audioId) async {
    // ref.read(startListnersProvider);
    ref.read(audioProvider.notifier).update(
          (state) => state
            ..setUrl(
              url,
            ),
        );

    ref.read(audioProvider).play();
  }
}
