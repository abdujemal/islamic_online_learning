// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

abstract class CourseDetailDataSrc {
  Future<File> downloadFile(
    String fileId,
    String fileName,
    String folderName,
    CancelToken cancelToken,
    Ref ref,
  );
  Future<bool> checkIfTheFileIsDownloaded(String fileName, String folderName);
  Future<String> loadFileOnline(String fileId);
  Future<bool> deleteFile(String fileName, String folderName);
}

class ICourseDatailDataSrc extends CourseDetailDataSrc {
  final Dio dio;
  ICourseDatailDataSrc(this.dio);
  @override
  Future<bool> checkIfTheFileIsDownloaded(
      String fileName, String folderName) async {
    Directory dir = await getApplicationSupportDirectory();

    final filePath = "${dir.path}/$folderName/$fileName";

    return await File(filePath).exists();
  }

  @override
  Future<File> downloadFile(
    String fileId,
    String fileName,
    String folderName,
    CancelToken cancelToken,
    Ref ref,
  ) async {
    Directory dir = await getApplicationSupportDirectory();

    final filePath = "${dir.path}/$folderName/$fileName";

    // if it is clicked again
    // final isDownloading =
    //     ref.read(downloadProgressProvider).any((e) => e.filePath == filePath);
    // CancelToken? cancelToken;
    // if (isDownloading) {
    //   return ;
    // print("problem");
    // cancelToken = CancelToken();
    // cancelToken.cancel("በተሳካ ሁኔታ ቆሟል።");
    // }

    if (await File(filePath).exists()) {
      // ref.read(downloadProgressProvider.notifier).update((state) => []);
      return File(filePath);
    }

    String botToken = dotenv.env["bot_token"]!;
    final fileUrl =
        'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    ref.read(downloadProgressProvider.notifier).update((state) {
      print(state.length);
      print(filePath);
      print("adding...");
      return [
        ...state,
        DownloadProgress(
          progress: 0,
          filePath: filePath,
          title: fileName.split(",").last,
        ),
      ];
    });

    final response = await dio.get(fileUrl);
    final fileData = response.data['result'];
    final fileDownloadUrl =
        'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
    await dio.download(
      fileDownloadUrl,
      filePath,
      cancelToken: cancelToken,
      onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          double progress = (receivedBytes / totalBytes) * 100;
          if (progress <= 100.0) {
            ref.read(downloadProgressProvider.notifier).update((state) {
              return state
                  .map(
                    (DownloadProgress e) => e.filePath == filePath
                        ? e.copyWith(
                            progress: progress,
                            filePath: filePath,
                          )
                        : e,
                  )
                  .toList();
            });
          }
        }
      },
    );

    ref
        .read(downloadProgressProvider.notifier)
        .update((state) => state.where((e) => e.filePath != filePath).toList());
    return File(filePath);
  }

  @override
  Future<String> loadFileOnline(String fileId) async {
    String? botToken = dotenv.env['bot_token'];

    final fileUrl =
        'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    final response = await dio.get(fileUrl);
    final fileData = response.data['result'];
    final fileDownloadUrl =
        'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';

    return fileDownloadUrl;
  }

  @override
  Future<bool> deleteFile(String fileName, String folderName) async {
    Directory dir = await getApplicationSupportDirectory();

    final filePath = "${dir.path}/$folderName/$fileName";

    await File(filePath).delete();

    return true;
  }
}

class DownloadProgress {
  final double progress;
  final String filePath;
  final String title;
  DownloadProgress({
    required this.progress,
    required this.filePath,
    required this.title,
  });

  DownloadProgress copyWith({
    double? progress,
    String? filePath,
    String? title,
  }) {
    return DownloadProgress(
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      title: title ?? this.title,
    );
  }
}

final downloadProgressProvider = StateProvider<List<DownloadProgress>>((ref) {
  return [];
});

final downloadProgressCheckernProvider =
    Provider.family<DownloadProgress?, String?>((ref, path) {
  final downloadProgresses = ref.watch(downloadProgressProvider);

  if (downloadProgresses.isEmpty) {
    return null;
  } else {
    final myProgress =
        downloadProgresses.where((e) => e.filePath == path).toList();
    if (myProgress.isNotEmpty) {
      return myProgress[0];
    } else {
      return null;
    }
  }
});
