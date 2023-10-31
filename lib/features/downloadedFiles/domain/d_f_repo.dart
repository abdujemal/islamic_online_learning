import 'dart:io';

import 'package:islamic_online_learning/core/typedef.dart';

abstract class DFRepo {
  FutureEither<List<File>> getPdfs();
  FutureEither<List<File>> getAudios();
  FutureEither<List<File>> getImages();

  FutureEither<void> deleteAllFiles(String folderName);
}
