import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_data_src.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_repo_impl.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/cd_notofier.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final cdDataSrcProvider = Provider<CourseDetailDataSrc>((ref) {
  return ICourseDatailDataSrc(ref.read(dioProvider));
});

final cdRepoProvider = Provider<CourseDetailRepo>((ref) {
  return ICourseDetailRepo(ref.read(cdDataSrcProvider));
});

final cdNotifierProvider = StateNotifierProvider<CDNotifier, bool>((ref) {
  return CDNotifier(ref.read(cdRepoProvider), ref);
});

final loadAudiosProvider = StateProvider<int>((ref) {
  return 0;
});
