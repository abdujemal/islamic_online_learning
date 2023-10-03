import 'dart:io';

import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';

import '../../../core/typedef.dart';

class ICourseDetailRepo extends CourseDetailRepo{
  @override
  FutureEither<bool> checkIfTheFileIsDownloaded(String path) {
    // TODO: implement checkIfTheFileIsDownloaded
    throw UnimplementedError();
  }

  @override
  FutureEither<File> downloadFile(String fileId, String fileName, String folderName) {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }
  
}