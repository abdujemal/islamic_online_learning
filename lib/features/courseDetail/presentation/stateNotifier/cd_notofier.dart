import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/downloaded_files_page.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

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
    toast("ትንሽ ይጠብቁን...", ToastType.normal, context);
    final res = await courseDetailRepo.downloadFile(
        fileId, fileName, folderName, cancelToken, ref);

    File? file;

    res.fold(
      (l) {
        if (!l.messege.contains("[request cancelled]")) {
          if (l.messege.contains("Failed host lookup")) {
            toast("እባክዎ ኢንተርኔትዎን ያብሩ!", ToastType.error, context, isLong: true);
          } else {
            if (kDebugMode) {
              print(l.messege);
            }
          }
        } else if (l.messege == "out of storage") {
          toast("ስልክዎ ስለሞላ የተወሰነ ፋይሎችን ያጥፉ!", ToastType.error, context);
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
    bool isAudio,
    BuildContext context, {
    bool showError = true,
  }) async {
    final res = await courseDetailRepo.loadFileOnline(fileId, isAudio);

    String? url;

    res.fold(
      (l) {
        if (showError) {
          toast("እባክዎ ኢንተርኔትዎን ያብሩ!", ToastType.error, context, isLong: true);
        }
        if (kDebugMode) {
          print(l.messege);
        }
      },
      (r) {
        url = r;
      },
    );

    return url;
  }

  Future<bool> isDownloaded(
      String fileName, String folderName, BuildContext context) async {
    bool isAvailable = false;
    final res =
        await courseDetailRepo.checkIfTheFileIsDownloaded(fileName, folderName);

    res.fold(
      (l) {
        toast(l.toString(), ToastType.error, context);
      },
      (r) {
        isAvailable = r;
      },
    );

    return isAvailable;
  }

  Future<bool> deleteFile(
      String fileName, String folderName, BuildContext context) async {
    bool isDeleted = false;

    final res = await courseDetailRepo.deleteFile(fileName, folderName);

    res.fold(
      (l) {
        toast(l.messege, ToastType.error, context);
        isDeleted = false;
      },
      (r) {
        isDeleted = true;
      },
    );

    return isDeleted;
  }

  Future<String> createDynamicLink(
      CourseModel courseModel, BuildContext context) async {
    String url = "";

    final res = await courseDetailRepo.createDynamicLink(courseModel);

    res.fold(
      (l) {
        toast(l.messege, ToastType.error, context);
        print(l.messege);
      },
      (r) {
        url = r;
        print("url: $url");
      },
    );

    return url;
  }

  // playOffline(String audioPath, String title, CourseModel courseModel,
  //     String audioId) async {
  //   // PlaylistHelper.audioPlayer.setFilePath(audioPath);
  //   ref
  //       .read(audioProvider.notifier)
  //       .update((state) => state..setFilePath(audioPath));

  //   PlaylistHelper.audioPlayer.play();
  // }

  // Future<void> playOnline(
  //     String url, String title, CourseModel courseModel, String audioId) async {
  //   // ref.read(startListnersProvider);
  //   ref.read(audioProvider.notifier).update(
  //         (state) => state
  //           ..setUrl(
  //             url,
  //           ),
  //       );

  //   PlaylistHelper.audioPlayer.play();
  // }
}
