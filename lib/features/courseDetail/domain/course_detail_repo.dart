import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/typedef.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

abstract class CourseDetailRepo {
  FutureEither<File> downloadFile(String fileId, String fileName,
      String folderName, int fileSize, CancelToken cancelToken, Ref ref);
  FutureEither<bool> checkIfTheFileIsDownloaded(
      String fileName, String folderName, int fileSize);
  FutureEither<String> loadFileOnline(String fileId, bool isAudio);
  FutureEither<bool> deleteFile(String fileName, String folderName);
  FutureEither<String> createDynamicLink(CourseModel courseModel);

}
