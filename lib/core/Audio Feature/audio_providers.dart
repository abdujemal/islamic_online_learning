import 'dart:io';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/cd_notofier.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'audio_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//playlist
class PlaylistNotifier extends StateNotifier<List<AudioTrack>> {
  PlaylistNotifier() : super([]);

  void addTrack(AudioTrack track) {
    state = [...state, track];
  }

  void removeTrack(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void updateTrack(AudioTrack updated) {
    state = [
      for (final t in state)
        if (t.id == updated.id) updated else t
    ];
  }
}

final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, List<AudioTrack>>(
        (ref) => PlaylistNotifier());

//audio central
class AudioController extends StateNotifier<AudioPlayer> {
  List<int> playListIndexes = [];
  List<AudioSource> playlist = [];
  CourseModel? currentPlayingCourse;
  AudioController(super.state);

  Future<String?> _download(
      WidgetRef ref, AudioTrack track, CourseModel model) async {
    final notifier = ref.read(playlistProvider.notifier);
    notifier.updateTrack(track.copyWith(isDownloading: true));
    CDNotifier cdNotifier = ref.read(cdNotifierProvider.notifier);
    final file = await cdNotifier.downloadFile(
      track.url,
      '${track.ustaz},${track.title}.mp3',
      "Audio",
      track.cancelToken,
      ref.context,
    );
    if (file != null) {
      notifier.updateTrack(
        track.copyWith(localPath: file.path, isDownloading: false),
      );
      Directory dir = await getApplicationSupportDirectory();
      String fileName = "${track.ustaz},${track.title}.mp3";

      await state.addAudioSource(
        AudioSource.file(
          "${dir.path}/Audio/$fileName",
          tag: MediaItem(
            id: track.id,
            title: track.title,
            artist: track.ustaz,
            album: track.category,
            artUri: Uri.parse(track.image),
            extras: model.toMap(),
          ),
        ),
      );
      return file.path;
    } else {
      toast("Error while playing", ToastType.error, ref.context);
      return null;
    }
  }

  Future<bool> fileExists(String fileName) async {
    Directory dir = await getApplicationSupportDirectory();
    return await File("${dir.path}/Audio/$fileName").exists();
  }

  Future<bool> isPlayingCourseCurrent(AudioTrack track) async {
    return currentPlayingCourse?.courseId == track.courseId;
  }

  Future<List<AudioSource>> addAllToPlaylist(CourseModel model) async {
    Directory dir = await getApplicationSupportDirectory();

    List<String> urls = model.courseIds.split(",");
    urls.map((v) async {
      final i = urls.indexOf(v);
      var fileName = "${model.ustaz},${model.title} $i.mp3";
      if (await fileExists(fileName)) {
        playListIndexes.add(i);
        playlist.add(
          AudioSource.file(
            "${dir.path}/Audio/$fileName",
            tag: MediaItem(
              id: model.courseId,
              title: model.title,
              artist: model.ustaz,
              album: model.category,
              artUri: Uri.parse(model.image),
              extras: model.toMap(),
            ),
          ),
        );
      }
    });

    await state.setAudioSources(playlist);
    return playlist;
  }

  /// Add track to playlist (forces download first)
  Future<void> play(WidgetRef ref, AudioTrack track, CourseModel model) async {
    final notifier = ref.read(playlistProvider.notifier);
    notifier.updateTrack(track.copyWith(isDownloading: true));

    // check if the file is downloaded
    if (track.localPath == null) {
      final localPath = await _download(ref, track, model);
      if (localPath == null) {
        toast("Error happened while downloading", ToastType.error, ref.context);
        return;
      }
      await addAllToPlaylist(model);
      currentPlayingCourse = model;
      state.setAudioSources(playlist);
    }
    // Start playback if not already playing
    if (state.playing == false) {
      await state.play();
    }
  }

  Future<void> pause() async {
    await state.pause();
  }

  Future<void> stop() async {
    await state.stop();
  }

  Future<void> next() async {
    await state.seekToNext();
  }

  Future<void> insertTrack(
      int index, AudioTrack track, CourseModel model) async {
    if (track.localPath == null) return;
    if (await isPlayingCourseCurrent(track)) return;
    await state.insertAudioSource(
      index,
      AudioSource.file(
        track.localPath!,
        tag: MediaItem(
          id: track.courseId,
          title: track.title,
          artist: track.ustaz,
          album: track.category,
          artUri: Uri.parse(track.image),
          extras: model.toMap(),
        ),
      ),
    );
  }

  Future<void> addTrack(int index, AudioTrack track, CourseModel model) async {
    if (track.localPath == null) return;
    if (!await isPlayingCourseCurrent(track)) return;
    await state.insertAudioSource(
      index,
      AudioSource.file(
        track.localPath!,
        tag: MediaItem(
          id: model.courseId,
          title: model.title,
          artist: model.ustaz,
          album: model.category,
          artUri: Uri.parse(model.image),
          extras: model.toMap(),
        ),
      ),
    );
  }

  Future<void> seekToIndex(int index) async {
    await state.seek(Duration.zero, index: index);
  }

  Future<void> seek10SecPlus() async {
    await state.seek(Duration(seconds: 10));
  }

  Future<void> seek10SecMinus() async {
    await state.seek(Duration(seconds: -10));
  }

  Future<void> previous() async {
    await state.seekToPrevious();
  }

  Future<void> delete(WidgetRef ref, AudioTrack track, int index) async {
    if (track.localPath != null) {
      final file = File(track.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    ref.read(playlistProvider.notifier).removeTrack(track.id);
    if (!await isPlayingCourseCurrent(track)) return;
    await state.removeAudioSourceAt(index);
  }
}

final audioControllerProvider =
    StateNotifierProvider<AudioController, AudioPlayer>(
        (ref) => AudioController(AudioPlayer()));

Stream<AudioData> myAudioStream(AudioPlayer audioPlayer) =>
    Rx.combineLatest2<ProcessingState, SequenceState?, AudioData>(
      audioPlayer.processingStateStream,
      audioPlayer.sequenceStateStream,
      (processingState, sequenceState) => AudioData(
        processingState: processingState,
        sequenceState: sequenceState,
      ),
    );

// final audioProvider = StateProvider<AudioPlayer>((ref) {
//   return AudioPlayer();
// });

// final currentAudioProvider = StateProvider<AudioModel?>((ref) {
//   return null;
// });

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
//   final audioPlayer = PlaylistHelper.audioPlayer;
//   final postionState = ref.read(audioPlayerPositionProvider.notifier);

//   return audioPlayer.onPositionChanged.listen((Duration position) {
//     postionState.update((state) => position);
//   });
// });

// final audioPlayerDurationSubscriptionProvider =
//     Provider.autoDispose<StreamSubscription<Duration>>((ref) {
//   final audioPlayer = PlaylistHelper.audioPlayer;
//   final durationState = ref.read(audioPlayerDurationProvider.notifier);

//   return audioPlayer.onDurationChanged.listen((Duration duration) {
//     durationState.update((state) => duration);
//   });
// });

// final audioPlayerFinishedSubscriptionProvider =
//     Provider.autoDispose<StreamSubscription<void>>((ref) {
//   final audioPlayer = PlaylistHelper.audioPlayer;
//   final currentAudio = ref.watch(currentAudioProvider.notifier);
//   final positionNotifier = ref.watch(audioPlayerPositionProvider.notifier);

//   return audioPlayer.onPlayerComplete.listen((duration) {
//     positionNotifier.update((state) => Duration.zero);
//     currentAudio
//         .update((state) => state?.copyWith(audioState: AudioState.idle));
//   });
// });

// final checkAudioModelProvider = Provider.family<AudioState, String>((ref, id) {
//   final currentAudio = ref.watch(currentAudioProvider);
//   final audioPlayer = PlaylistHelper.audioPlayer;

  // audioPlayer.sequenceStateStream.listen((event) {
  //   if (event != null) {
  //     final mediaItem = event.currentSource!.tag as MediaItem;

     
  //     ref.read(currentAudioProvider.notifier).update(
  //           (state) => AudioModel(
  //             title: mediaItem.title,
  //             ustaz: mediaItem.artist ?? "",
  //             audioState:
  //                 audioPlayer.playing ? AudioState.playing : AudioState.paused,
  //             audioId: mediaItem.id,
  //           ),
  //         );
  //   }
  // });

//   if (currentAudio == null) {
//     return AudioState.idle;
//   }
//   if ("${currentAudio.ustaz},${currentAudio.title}" == id) {
//     if (currentAudio.audioState.isPlaused()) {
//       return AudioState.paused;
//     } else {
//       return AudioState.playing;
//     }
//   } else {
//     return AudioState.idle;
//   }
// });

// final currentCourseProvider = StateProvider<CourseModel?>((ref) {
//   return null;
// });

// final checkCourseProvider =
//     Provider.family<CourseModel?, String>((ref, courseId) {
//   final currentCourse = ref.watch(currentCourseProvider);

//   if (currentCourse == null) {
//     return null;
//   } else if (currentCourse.courseId == courseId) {
//     return currentCourse;
//   } else {
//     return null;
//   }
// });
