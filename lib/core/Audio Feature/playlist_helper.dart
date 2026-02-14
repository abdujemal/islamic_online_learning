import 'package:just_audio/just_audio.dart';

class PlaylistHelper {
  static PlaylistHelper? _playlistHelper;
  static List<AudioSource>? nplayList;
  static AudioPlayer audioPlayer = AudioPlayer();
  static List<int> mainPlayListIndexes = []; 

  PlaylistHelper._createInstance();
  factory PlaylistHelper() {
    _playlistHelper ??= PlaylistHelper._createInstance();
    return _playlistHelper!;
  }

  List<AudioSource> initializeDatabase() {
    return [];
  }

  List<AudioSource> get playList {
    nplayList ??= initializeDatabase();
    return nplayList!;
  }

  // List<int> get playListIndexes => _playListIndxes;
}
