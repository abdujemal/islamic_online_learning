import 'package:just_audio/just_audio.dart';

class PlaylistHelper {
  static PlaylistHelper? _playlistHelper;
  static ConcatenatingAudioSource? _playList;
  // static final List<int> _playListIndxes = [];

  PlaylistHelper._createInstance();
  factory PlaylistHelper() {
    _playlistHelper ??= PlaylistHelper._createInstance();
    return _playlistHelper!;
  }

  ConcatenatingAudioSource initializeDatabase() {
    return ConcatenatingAudioSource(children: []);
  }

  ConcatenatingAudioSource? get playList {
    _playList ??= initializeDatabase();
    return _playList;
  }

  // List<int> get playListIndexes => _playListIndxes;
}
