import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class DFDataSrc {
  Future<List<File>> getPdfs();
  Future<List<File>> getAudios();
  Future<void> deleteAllFiles(String folderName);
}

class DFDataSrcImpl extends DFDataSrc {
  @override
  Future<List<File>> getAudios() async {
    Directory dir = await getApplicationSupportDirectory();

    dir = Directory("${dir.path}/Audio");

    List<File> audios = [];

    if (await dir.exists()) {
      final files = dir.listSync();

      for (var file in files) {
        if (file is File) {
          audios.add(File(file.path));
        }
      }
      return audios;
    } else {
      return [];
    }
  }

  @override
  Future<List<File>> getPdfs() async {
    Directory dir = await getApplicationSupportDirectory();

    dir = Directory("${dir.path}/PDF");

    List<File> pdfs = [];

    if (await dir.exists()) {
      final files = dir.listSync();

      for (var file in files) {
        if (file is File) {
          pdfs.add(File(file.path));
        }
      }
      return pdfs;
    } else {
      return [];
    }
  }

  @override
  Future<void> deleteAllFiles(String folderName) async {
    Directory dir = await getApplicationSupportDirectory();

    dir = Directory("${dir.path}/$folderName");

    await dir.delete(recursive: true);
  }
}
