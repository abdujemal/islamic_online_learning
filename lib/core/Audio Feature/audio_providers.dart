
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';

final audioProvider = StateProvider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final currentAudioProvider = StateProvider<AudioModel?>((ref) {
  return null;
});

// final startListnersProvider = Provider<bool>((ref) {
//   ref.read(audioPlayerPositionSubscriptionProvider);
//   ref.read(audioPlayerDurationSubscriptionProvider);
//   ref.read(audioPlayerFinishedSubscriptionProvider);

//   return true;
// });

// final endListnersProvider = Provider<bool>((ref) {
//   ref.read(audioPlayerDurationSubscriptionProvider).cancel();
//   ref.read(audioPlayerPositionSubscriptionProvider).cancel();
//   ref.read(audioPlayerFinishedSubscriptionProvider).cancel();

//   return true;
// });

// final audioPlayerPositionProvider =
//     StateProvider<Duration>((ref) => Duration.zero);
// final audioPlayerDurationProvider =
//     StateProvider<Duration>((ref) => Duration.zero);

// final audioPlayerPositionSubscriptionProvider =
//     Provider.autoDispose<StreamSubscription<Duration>>((ref) {
//   final audioPlayer = ref.read(audioProvider);
//   final postionState = ref.read(audioPlayerPositionProvider.notifier);

//   return audioPlayer.onPositionChanged.listen((Duration position) {
//     postionState.update((state) => position);
//   });
// });

// final audioPlayerDurationSubscriptionProvider =
//     Provider.autoDispose<StreamSubscription<Duration>>((ref) {
//   final audioPlayer = ref.read(audioProvider);
//   final durationState = ref.read(audioPlayerDurationProvider.notifier);

//   return audioPlayer.onDurationChanged.listen((Duration duration) {
//     durationState.update((state) => duration);
//   });
// });

// final audioPlayerFinishedSubscriptionProvider =
//     Provider.autoDispose<StreamSubscription<void>>((ref) {
//   final audioPlayer = ref.read(audioProvider);
//   final currentAudio = ref.watch(currentAudioProvider.notifier);
//   final positionNotifier = ref.watch(audioPlayerPositionProvider.notifier);

//   return audioPlayer.onPlayerComplete.listen((duration) {
//     positionNotifier.update((state) => Duration.zero);
//     currentAudio
//         .update((state) => state?.copyWith(audioState: AudioState.idle));
//   });
// });

final checkAudioModelProvider = Provider.family<AudioState, String>((ref, id) {
  final currentAudio = ref.watch(currentAudioProvider);
  if (currentAudio == null) {
    return AudioState.idle;
  }
  if ("${currentAudio.ustaz},${currentAudio.title}" == id) {
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

final checkCourseProvider =
    Provider.family<CourseModel?, String>((ref, courseId) {
  final currentCourse = ref.watch(currentCourseProvider);

  if (currentCourse == null) {
    return null;
  } else if (currentCourse.courseId == courseId) {
    return currentCourse;
  } else {
    return null;
  }
});
