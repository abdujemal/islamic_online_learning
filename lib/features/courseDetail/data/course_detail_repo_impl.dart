import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_data_src.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/failure.dart';
import '../../../core/typedef.dart';

class ICourseDetailRepo extends CourseDetailRepo {
  final CourseDetailDataSrc courseDetailDataSrc;

  ICourseDetailRepo(this.courseDetailDataSrc);

  @override
  FutureEither<bool> checkIfTheFileIsDownloaded(
      String fileName, String folderName) async {
    try {
      final res = await courseDetailDataSrc.checkIfTheFileIsDownloaded(
          fileName, folderName);
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<File> downloadFile(String fileId, String fileName,
      String folderName, CancelToken cancelToken, Ref ref) async {
    try {
      final res = await courseDetailDataSrc.downloadFile(
          fileId, fileName, folderName, cancelToken, ref);
      return right(res);
    } catch (e) {
      Directory dir = await getApplicationSupportDirectory();

      final filePath = "${dir.path}/$folderName/$fileName";

      ref.read(downloadProgressProvider.notifier).update(
          (state) => state.where((e) => e.filePath != filePath).toList());

      if (e is DioException && e.error is FileSystemException) {
        // Handle out of storage error
        return left(const Failure(messege: "out of storage"));
      }

      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<String> loadFileOnline(String fileId, bool isAudio) async {
    try {
      final res = await courseDetailDataSrc.loadFileOnline(fileId, isAudio);
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<bool> deleteFile(String fileName, String folderName) async {
    try {
      final res = await courseDetailDataSrc.deleteFile(fileName, folderName);
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<String> createDynamicLink(CourseModel courseModel) async {
    try {
      final res = await courseDetailDataSrc.createDynamicLink(courseModel);
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }
}
