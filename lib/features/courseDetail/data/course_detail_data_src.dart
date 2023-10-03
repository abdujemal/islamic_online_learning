import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

abstract class CourseDetailDataSrc{
  Future<File> downloadFile(String fileId, String fileName, String folderName);
  Future<bool> checkIfTheFileIsDownloaded(String path);
}

class ICourseDatailDataSrc extends CourseDetailDataSrc {
  @override
  Future<bool> checkIfTheFileIsDownloaded(String path) {
    // TODO: implement checkIfTheFileIsDownloaded
    throw UnimplementedError();
  }

  @override
  Future<File> downloadFile(String fileId, String fileName, String folderName) async {
     Directory? dir = await getExternalStorageDirectory();

    String botToken = dotenv.env["bot_token"]!;
    final filePath = "${dir!.path}/$folderName/$fileName";
    final dio = Dio();
    final fileUrl =
        'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    final response = await dio.get(fileUrl);
    final fileData = response.data['result'];
    final fileDownloadUrl =
        'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
    await dio.download(fileDownloadUrl, filePath);

    return File(filePath);
  }

}