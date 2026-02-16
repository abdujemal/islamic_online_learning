
// import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_data_src.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_repo_impl.dart';
import 'package:islamic_online_learning/features/courseDetail/domain/course_detail_repo.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/cd_notofier.dart';

final dioProvider = Provider<Dio>((ref) {
  // final resolver =  InternetAddress('8.8.8.8');
  // final client =  DnsOverUdp.withTarget(resolver);

  // // Set the URL of the file to download
  // final url = 'https://example.com/file-to-download';

  // // Set the local file path to save the downloaded file
  // final savePath = '/path/to/save/downloaded/file';

  // // Set the range header to continue the download if it was previously interrupted
  // final file = File(savePath);
  // final initialSize = await file.length();
  // final headers = {'range': 'bytes=$initialSize-'};

  // try {
  //   final addresses = await InternetAddress.lookup('example.com',
  //       type: InternetAddressType.IPv4);

  //   if (addresses.isNotEmpty) {
  //     final ipAddress = addresses.first.address;

  //     // Create a Dio instance with custom DNS resolver
  //     final dio = Dio()
  //       ..options.baseUrl = 'http://$ipAddress'
  //       ;
  //   if (addresses.isNotEmpty) {
  //     final ipAddress = addresses.first.address;

      
  //   }
  //   }
  //   }catch(e){
  //     print(e.toString());
  //   }
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
