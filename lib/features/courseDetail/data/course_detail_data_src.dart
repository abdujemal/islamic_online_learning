// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

abstract class CourseDetailDataSrc {
  Future<File> downloadFile(
      String fileId, String fileName, String folderName, Ref ref);
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
      String fileId, String fileName, String folderName, Ref ref) async {
    Directory dir = await getApplicationSupportDirectory();

    final filePath = "${dir.path}/$folderName/$fileName";

    if (await File(filePath).exists()) {
      ref.read(downloadProgressProvider.notifier).update((state) => null);
      return File(filePath);
    }

    String botToken = dotenv.env["bot_token"]!;
    final fileUrl =
        'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    final response = await dio.get(fileUrl);
    final fileData = response.data['result'];
    final fileDownloadUrl =
        'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
    await dio.download(fileDownloadUrl, filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
      if (totalBytes != -1) {
        double progress = (receivedBytes / totalBytes) * 100;
        if (progress <= 100.0) {
          ref.read(downloadProgressProvider.notifier).update(
                (state) => DownloadProgress(
                  progress: progress,
                  filePath: filePath,
                ),
              );
          print('Download progress: ${progress.toStringAsFixed(2)}%');
        }
      }
    });

    ref.read(downloadProgressProvider.notifier).update((state) => null);
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
  DownloadProgress({
    required this.progress,
    required this.filePath,
  });
}

final downloadProgressProvider = StateProvider<DownloadProgress?>((ref) {
  return null;
});

final downloadProgressCheckernProvider =
    Provider.family<DownloadProgress?, String?>((ref, path) {
  final downloadProgress = ref.watch(downloadProgressProvider);
 
  if (downloadProgress == null) {
    return null;
  } else if (downloadProgress.filePath == path) {
    return downloadProgress;
  } else {
    return null;
  }
});
