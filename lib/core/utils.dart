import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> download(String fileId, String name) async {
  Directory? dir = await getExternalStorageDirectory();

  const String botToken = "6152316528:AAH3NEDElz5ApQz_8Qb1Xw9YJXaeTOOCoZ4";
  String filePath = "${dir!.path}/$name";
  final dio = Dio();
  final fileUrl =
      'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
  final response = await dio.get(fileUrl);
  final fileData = response.data['result'];
  final fileDownloadUrl =
      'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
  await dio.download(fileDownloadUrl, filePath);

  return filePath;
}
