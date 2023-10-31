import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/typedef.dart';

abstract class CourseDetailRepo {
  FutureEither<File> downloadFile(String fileId, String fileName,
      String folderName, CancelToken cancelToken, Ref ref);
  FutureEither<bool> checkIfTheFileIsDownloaded(
      String fileName, String folderName);
  FutureEither<String> loadFileOnline(String fileId);
  FutureEither<bool> deleteFile(String fileName, String folderName);
}
