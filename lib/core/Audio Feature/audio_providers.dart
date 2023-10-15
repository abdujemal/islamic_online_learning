import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

final audioProvider = Provider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final currentAudioProvider = StateProvider<AudioModel?>((ref) {
  return null;
});

final checkAudioModelProvider =
    Provider.family<AudioState, String>((ref, id) {
  final currentAudio = ref.watch(currentAudioProvider);
  if (currentAudio == null) {
    return AudioState.idle;
  }
  if ("${currentAudio.title} ${currentAudio.ustaz}" == id) {
    if (currentAudio.audioState.isPlaused()) {
      return AudioState.paused;
    } else {
      return AudioState.playing;
    }
  } else {
    return AudioState.idle;
  }
});

final currentCourseProvider = StateProvider<CourseModel?>((ref) {
  return null;
});
