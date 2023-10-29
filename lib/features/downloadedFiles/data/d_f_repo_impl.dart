// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:islamic_online_learning/core/failure.dart';
import 'package:islamic_online_learning/core/typedef.dart';
import 'package:islamic_online_learning/features/downloadedFiles/data/d_f_data_src.dart';
import 'package:islamic_online_learning/features/downloadedFiles/domain/d_f_repo.dart';

class DFRepoImpl extends DFRepo {
  final DFDataSrc dfDataSrc;
  DFRepoImpl({
    required this.dfDataSrc,
  });

  @override
  FutureEither<void> deleteAllFiles(String folderName) async {
    try {
      final res = await dfDataSrc.deleteAllFiles(folderName);
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<File>> getAudios() async {
    try {
      final res = await dfDataSrc.getAudios();
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }

  @override
  FutureEither<List<File>> getPdfs() async {
    try {
      final res = await dfDataSrc.getPdfs();
      return right(res);
    } catch (e) {
      return left(Failure(messege: e.toString()));
    }
  }
}
