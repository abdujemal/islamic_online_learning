import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/template/model/discussion.dart';

final voiceRoomServiceProvider = Provider<VoiceRoomService>((ref) {
  return VoiceRoomService();
});

class VoiceRoomService {
  Future<Discussion> createDiscussion(String title) async {
    final res = await customPostRequest(
      discussionsApi,
      {
        "title": title,
      },
      authorized: true,
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create discussion: ${res.body}');
    }
    return Discussion.fromJson(res.body);
  }
}
