
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_data_src.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';

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
  FutureEither<File> downloadFile(
      String fileId, String fileName, String folderName, Ref ref) async {
    try {
      final res = await courseDetailDataSrc.downloadFile(fileId, fileName, folderName, ref);
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<String> loadFileOnline(String fileId) async {
    try {
      final res = await courseDetailDataSrc.loadFileOnline(fileId);
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
}
