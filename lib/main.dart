import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:path_provider/path_provider.dart';

import 'features/main/presentation/pages/main_page.dart';
import 'firebase_options.dart';

const defaultPlayerCount = 4;

typedef OnError = void Function(Exception exception);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await DatabaseHelper().initializeDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        appBarTheme: const AppBarTheme(
            backgroundColor: whiteColor,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            actionsIconTheme: IconThemeData(
              color: primaryColor,
            ),
            elevation: 2,
            iconTheme: IconThemeData(color: Colors.black)),
      ),
      home: const MainPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double position = 0;

  AudioPlayer player = AudioPlayer();

  StreamSubscription<Duration>? _durationSubscription;

  Duration? _duration;

  StreamSubscription<Duration>? _positionSubscription;

  Duration? _position;

  StreamSubscription<void>? _playerCompleteSubscription;

  PlayerState? _playerState;

  String? filePath;

  StreamSubscription<PlayerState>? _playerStateChangeSubscription;

  bool isLoading = false;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  initState() {
    super.initState();

    initStream();
  }

  @override
  dispose() {
    super.dispose();
    _durationSubscription!.cancel();
    _positionSubscription!.cancel();
    _playerCompleteSubscription!.cancel();
    _playerStateChangeSubscription!.cancel();
  }

  initStream() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) {
        setState(() => _position = p);
        // print(_position);
      },
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    if (_playerState != PlayerState.paused) {
      if (filePath != null) {
        print("playing");
        await player.play(DeviceFileSource(filePath!));
      }
    } else {
      final position = _position;
      if (position != null && position.inMilliseconds > 0) {
        await player.seek(position);
      }
      await player.resume();
      setState(() => _playerState = PlayerState.playing);
    }
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.download,
        ),
        onPressed: () async {
          String fileId =
              "CQACAgQAAxkBAAMKZJbbdVQWy4V-EkWCprVERnh4pdQAAiQQAAIJtpFTXam6M-zq1WQvBA";
          await download(fileId, "Audio/File1.mp3");
          if (filePath != null) {
            print("playing");
            await player.play(DeviceFileSource(filePath!));
          }
        },
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 16.0),
            ),
            Slider(
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
              onChanged: (v) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = v * duration.inMilliseconds;
                player.seek(Duration(milliseconds: position.round()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_isPlaying) {
                      _pause();
                    } else {
                      _play();
                    }
                  },
                  icon: _isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () {
                    _stop();
                  },
                  icon: const Icon(Icons.stop),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String?> download(String fileId, String name) async {
    try {
      setState(() {
        isLoading = true;
      });
      Directory? dir = await getExternalStorageDirectory();

      const String botToken = "6152316528:AAH3NEDElz5ApQz_8Qb1Xw9YJXaeTOOCoZ4";
      filePath = "${dir!.path}/$name";
      final dio = Dio();
      final fileUrl =
          'https://api.telegram.org/bot$botToken/getFile?file_id=$fileId';
      final response = await dio.get(fileUrl);
      final fileData = response.data['result'];
      final fileDownloadUrl =
          'https://api.telegram.org/file/bot$botToken/${fileData['file_path']}';
      await dio.download(fileDownloadUrl, filePath);
      isLoading = false;
      return filePath;
    } catch (e) {
      isLoading = false;
      print(e.toString());
      return null;
    }
  }
}


// class _ExampleApp extends StatefulWidget {
//   const _ExampleApp();

//   @override
//   _ExampleAppState createState() => _ExampleAppState();
// }

// class _ExampleAppState extends State<_ExampleApp> {
//   List<AudioPlayer> audioPlayers = List.generate(
//     defaultPlayerCount,
//     (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
//   );
//   int selectedPlayerIdx = 0;

//   AudioPlayer get selectedAudioPlayer => audioPlayers[selectedPlayerIdx];
//   List<StreamSubscription> streams = [];

//   @override
//   void initState() {
//     super.initState();
//     audioPlayers.asMap().forEach((index, player) {
//       streams.add(
//         player.onPlayerStateChanged.listen(
//           (it) {
//             switch (it) {
//               case PlayerState.stopped:
//                 toast(
//                   'Player stopped!',
//                   textKey: Key('toast-player-stopped-$index'),
//                 );
//                 break;
//               case PlayerState.completed:
//                 toast(
//                   'Player complete!',
//                   textKey: Key('toast-player-complete-$index'),
//                 );
//                 break;
//               default:
//                 break;
//             }
//           },
//         ),
//       );
//       // streams.add(
//       //   player.onSeekComplete.listen(
//       //     (it) => toast(
//       //       'Seek complete!',
//       //       textKey: Key('toast-seek-complete-$index'),
//       //     ),
//       //   ),
//       // );
//     });
//   }

//   @override
//   void dispose() {
//     streams.forEach((it) => it.cancel());
//     super.dispose();
//   }

//   void _handleAction(PopupAction value) {
//     switch (value) {
//       case PopupAction.add:
//         setState(() {
//           audioPlayers.add(AudioPlayer()..setReleaseMode(ReleaseMode.stop));
//         });
//         break;
//       case PopupAction.remove:
//         setState(() {
//           if (audioPlayers.isNotEmpty) {
//             selectedAudioPlayer.dispose();
//             audioPlayers.removeAt(selectedPlayerIdx);
//           }
//           // Adjust index to be in valid range
//           if (audioPlayers.isEmpty) {
//             selectedPlayerIdx = 0;
//           } else if (selectedPlayerIdx >= audioPlayers.length) {
//             selectedPlayerIdx = audioPlayers.length - 1;
//           }
//         });
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AudioPlayers example'),
//         actions: [
//           PopupMenuButton<PopupAction>(
//             onSelected: _handleAction,
//             itemBuilder: (BuildContext context) {
//               return PopupAction.values.map((PopupAction choice) {
//                 return PopupMenuItem<PopupAction>(
//                   value: choice,
//                   child: Text(
//                     choice == PopupAction.add
//                         ? 'Add player'
//                         : 'Remove selected player',
//                   ),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Tgl(
//                   key: const Key('playerTgl'),
//                   options: [for (var i = 1; i <= audioPlayers.length; i++) i]
//                       .asMap()
//                       .map((key, val) => MapEntry('player-$key', 'P$val')),
//                   selected: selectedPlayerIdx,
//                   onChange: (v) => setState(() => selectedPlayerIdx = v),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: audioPlayers.isEmpty
//                 ? const Text('No AudioPlayer available!')
//                 : IndexedStack(
//                     index: selectedPlayerIdx,
//                     children: audioPlayers
//                         .map(
//                           (player) => Tabs(
//                             key: GlobalObjectKey(player),
//                             tabs: [
//                               TabData(
//                                 key: 'sourcesTab',
//                                 label: 'Src',
//                                 content: SourcesTab(
//                                   player: player,
//                                 ),
//                               ),
//                               TabData(
//                                 key: 'controlsTab',
//                                 label: 'Ctrl',
//                                 content: ControlsTab(
//                                   player: player,
//                                 ),
//                               ),
//                               TabData(
//                                 key: 'streamsTab',
//                                 label: 'Stream',
//                                 content: StreamsTab(
//                                   player: player,
//                                 ),
//                               ),
//                               TabData(
//                                 key: 'audioContextTab',
//                                 label: 'Ctx',
//                                 content: AudioContextTab(
//                                   player: player,
//                                 ),
//                               ),
//                               TabData(
//                                 key: 'loggerTab',
//                                 label: 'Log',
//                                 content: LoggerTab(
//                                   player: player,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                         .toList(),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// enum PopupAction {
//   add,
//   remove,
// }
