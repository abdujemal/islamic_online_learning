import 'dart:io';
import 'package:islamic_online_learning/core/typedef.dart';

abstract class CourseDetailRepo {
  FutureEither<File> downloadFile(
      String fileId, String fileName, String folderName);
  FutureEither<bool> checkIfTheFileIsDownloaded(String path);
}
