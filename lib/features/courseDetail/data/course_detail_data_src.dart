// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class CourseDetailDataSrc {
  Future<File> downloadFile(
    String fileId,
    String fileName,
    String folderName,
    int fileSize,
    CancelToken cancelToken,
    Ref ref,
  );
  Future<bool> checkIfTheFileIsDownloaded(
      String fileName, String folderName, int fileSize);
  Future<String> loadFileOnline(String fileId, bool isAudio);
  Future<String> createDynamicLink(CourseModel courseModel);
  Future<bool> deleteFile(String fileName, String folderName);
}

class ICourseDatailDataSrc extends CourseDetailDataSrc {
  final Dio dio;
  ICourseDatailDataSrc(this.dio);
  @override
  Future<bool> checkIfTheFileIsDownloaded(
      String fileName, String folderName, int fileSize) async {
    Directory dir = await getApplicationSupportDirectory();

    final filePath = "${dir.path}/$folderName/$fileName";

    return await verifyFileLength(
      filePath: filePath,
      expectedSize: fileSize,
    );
  }

  @override
  Future<File> downloadFile(
    String fileId,
    String fileName,
    String folderName,
    int fileSize,
    CancelToken cancelToken,
    Ref ref,
  ) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    Directory dir = await getApplicationSupportDirectory();
    await Directory("${dir.path}/$folderName").create(recursive: true);

    final filePath = "${dir.path}/$folderName/$fileName";
    final file = File(filePath);

    final fileDownloaded =
        await checkIfTheFileIsDownloaded(fileName, folderName, fileSize);
    
    if(fileDownloaded){
      return file;
    }

    // int downloadedBytes = 0;

    // The actual file URL
    final fileDownloadUrl = fileId;

    ref.read(downloadProgressProvider.notifier).update(
          (s) => [
            ...s,
            DownloadProgress(
              cancelToken: cancelToken,
              progress: 0,
              receivedBytes: 0,
              totalBytes: 0,
              filePath: filePath,
              title: fileName.split(",").last,
            ),
          ],
        );

    await resumableDownload(
      url: fileDownloadUrl,
      savePath: filePath,
      cancelToken: cancelToken,
      onProgress: (received, totalBytes) {
        double progress = (received / totalBytes) * 100;
        ref.read(downloadProgressProvider.notifier).update((state) {
          return state
              .map(
                (e) => e.filePath == filePath
                    ? e.copyWith(
                        progress: progress,
                        receivedBytes: received,
                        totalBytes: totalBytes,
                      )
                    : e,
              )
              .toList();
        });
      },
      onDone: () async {
        ref.read(downloadProgressProvider.notifier).update(
              (state) => state.where((e) => e.filePath != filePath).toList(),
            );
      },
      onError: (error) {
        throw Exception(error.toString());
      },
    );
    return file;
    // if (await file.exists()) {
    //   downloadedBytes = await file.length();
    // }

    // // Add progress item if not exists
    // ref.read(downloadProgressProvider.notifier).update((state) {
    //   final exists = state.any((e) => e.filePath == filePath);
    //   if (!exists) {
    //     return [
    //       ...state,
    //       DownloadProgress(
    //         cancelToken: cancelToken,
    //         progress: 0,
    //         receivedBytes: downloadedBytes,
    //         totalBytes: 0,
    //         filePath: filePath,
    //         title: fileName.split(",").last,
    //       ),
    //     ];
    //   }
    //   return state;
    // });

    // // Add header to continue download
    // Map<String, dynamic> headers =
    //     downloadedBytes > 0 ? {"Range": "bytes=$downloadedBytes-"} : {};

    // final response = await dio.get<ResponseBody>(
    //   fileDownloadUrl,
    //   options: Options(
    //     responseType: ResponseType.stream,
    //     headers: headers,
    //   ),
    //   cancelToken: cancelToken,
    // );

    // final totalBytes = response.headers.map["content-length"]?.first != null
    //     ? int.parse(response.headers.map["content-length"]!.first) +
    //         downloadedBytes
    //     : downloadedBytes;

    // final sink = file.openWrite(
    //   mode: downloadedBytes > 0 ? FileMode.append : FileMode.write,
    // );

    // int received = downloadedBytes;

    // await response.data!.stream.listen(
    //   (chunk) {
    //     sink.add(chunk);
    //     received += chunk.length;

    //     double progress = (received / totalBytes) * 100;

    //     ref.read(downloadProgressProvider.notifier).update((state) {
    //       return state
    //           .map(
    //             (e) => e.filePath == filePath
    //                 ? e.copyWith(
    //                     progress: progress,
    //                     receivedBytes: received,
    //                     totalBytes: totalBytes,
    //                   )
    //                 : e,
    //           )
    //           .toList();
    //     });
    //   },
    //   onDone: () async {
    //     await sink.close();

    //     ref.read(downloadProgressProvider.notifier).update(
    //           (state) => state.where((e) => e.filePath != filePath).toList(),
    //         );
    //   },
    //   onError: (e) async {
    //     await sink.close();
    //     throw e;
    //   },
    //   cancelOnError: true,
    // ).asFuture();

    // return file;
  }

  // @override
  // Future<File> downloadFile(
  //   String fileId,
  //   String fileName,
  //   String folderName,
  //   CancelToken cancelToken,
  //   Ref ref,
  // ) async {
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //     return client;
  //   };
  //   Directory dir = await getApplicationSupportDirectory();

  //   final filePath = "${dir.path}/$folderName/$fileName";

  //   if (await File(filePath).exists()) {
  //     // ref.read(downloadProgressProvider.notifier).update((state) => []);
  //     return File(filePath);
  //   }

  //   ref.read(downloadProgressProvider.notifier).update((state) {
  //     if (kDebugMode) {
  //       print(state.length);
  //       print(filePath);
  //       print("adding...");
  //     }
  //     return [
  //       ...state,
  //       DownloadProgress(
  //         cancelToken: cancelToken,
  //         progress: 0,
  //         receivedBytes: 0,
  //         totalBytes: 0,
  //         filePath: filePath,
  //         title: fileName.split(",").last,
  //       ),
  //     ];
  //   });

  //   String fileDownloadUrl = "";
  //   // if (folderName == "Audio") {
  //   fileDownloadUrl = fileId;
  //   // } else {
  //   //   final fileUrl =
  //   //       'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
  //   //   final response = await dio.get(fileUrl);
  //   //   final fileData = response.data['result'];
  //   //   fileDownloadUrl =
  //   //       'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
  //   // }

  //   await dio.download(
  //     fileDownloadUrl,
  //     filePath,
  //     cancelToken: cancelToken,
  //     onReceiveProgress: (receivedBytes, totalBytes) {
  //       if (totalBytes != -1) {
  //         double progress = (receivedBytes / totalBytes) * 100;
  //         if (progress <= 100.0) {
  //           ref.read(downloadProgressProvider.notifier).update((state) {
  //             return state
  //                 .map(
  //                   (DownloadProgress e) => e.filePath == filePath
  //                       ? e.copyWith(
  //                           progress: progress,
  //                           filePath: filePath,
  //                           receivedBytes: receivedBytes,
  //                           totalBytes: totalBytes,
  //                         )
  //                       : e,
  //                 )
  //                 .toList();
  //           });
  //         }
  //       }
  //     },
  //   );

  //   ref
  //       .read(downloadProgressProvider.notifier)
  //       .update((state) => state.where((e) => e.filePath != filePath).toList());
  //   return File(filePath);
  // }

  @override
  Future<String> loadFileOnline(String fileId, bool isAudio) async {
    // String? botToken = dotenv.env['bot_token'];

    // if (isAudio) {
    //   print("$botToken");
    //   //replaceAll("botToken", botToken!)
    //   List<String> l = fileId.split("/");
    //   l[4] = "bot${botToken}";
    //   // print(fileId.replaceAll("botToken", botToken!));
    return fileId;
    // } else {
    //   final fileUrl =
    //       'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
    //   final response = await dio.get(fileUrl);
    //   final fileData = response.data['result'];
    //   final fileDownloadUrl =
    //       'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
    //   return fileDownloadUrl;
    // }
  }

  @override
  Future<bool> deleteFile(String fileName, String folderName) async {
    Directory dir = await getApplicationSupportDirectory();

    final filePath = "${dir.path}/$folderName/$fileName";

    await File(filePath).delete();

    return true;
  }

  @override
  Future<String> createDynamicLink(CourseModel courseModel) async {
    // final dynamicLinkParams = DynamicLinkParameters(
    //   link:
    //       Uri.parse("https://ilmfelagi.com/courses?id=${courseModel.courseId}"),
    //   uriPrefix: "https://ilmfelagi.page.link",
    //   androidParameters: const AndroidParameters(
    //     packageName: "com.aj.islamic_online_learning_dev",
    //   ),
    //   socialMetaTagParameters: SocialMetaTagParameters(
    //     title: courseModel.title,
    //     imageUrl: Uri.parse(courseModel.image),
    //     description: "በ${courseModel.ustaz}",
    //   ),
    // );
    // final dynamicLink =
    //     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    // return dynamicLink.shortUrl.toString();
    throw Exception("Dynamic links are not implemented yet.");
  }
}

class DownloadProgress {
  final double progress;
  final int receivedBytes;
  final int totalBytes;
  final String filePath;
  final String title;
  final CancelToken cancelToken;
  DownloadProgress({
    required this.progress,
    required this.receivedBytes,
    required this.totalBytes,
    required this.filePath,
    required this.title,
    required this.cancelToken,
  });

  DownloadProgress copyWith({
    double? progress,
    int? totalBytes,
    int? receivedBytes,
    String? filePath,
    String? title,
    CancelToken? cancelToken,
  }) {
    return DownloadProgress(
      progress: progress ?? this.progress,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      filePath: filePath ?? this.filePath,
      title: title ?? this.title,
      cancelToken: cancelToken ?? this.cancelToken,
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
