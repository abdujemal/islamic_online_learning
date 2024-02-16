import 'package:just_audio/just_audio.dart';

class PlaylistHelper {
  static PlaylistHelper? _playlistHelper;
  static ConcatenatingAudioSource? nplayList;
  static AudioPlayer audioPlayer = AudioPlayer();
  static List<int> mainPlayListIndexes = []; 

  PlaylistHelper._createInstance();
  factory PlaylistHelper() {
    _playlistHelper ??= PlaylistHelper._createInstance();
    return _playlistHelper!;
  }

  ConcatenatingAudioSource initializeDatabase() {
    return ConcatenatingAudioSource(children: []);
  }

  ConcatenatingAudioSource get playList {
    nplayList ??= initializeDatabase();
    return nplayList!;
  }

  // List<int> get playListIndexes => _playListIndxes;
}
