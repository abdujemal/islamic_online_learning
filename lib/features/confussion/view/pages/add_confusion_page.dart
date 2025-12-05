import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddConfusionPage extends ConsumerStatefulWidget {
  final Lesson lesson;
  const AddConfusionPage({super.key, required this.lesson});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddConfusionPageState();
}

class _AddConfusionPageState extends ConsumerState<AddConfusionPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedPath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _player.openPlayer();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openRecorder();
    _isRecorderReady = true;
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady) return;
    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/confusion_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: path);
    setState(() {
      _isRecording = true;
      _recordedPath = path;
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderReady) return;
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (_recordedPath == null || _isPlaying) return;
    await _player.startPlayer(
      fromURI: _recordedPath!,
      whenFinished: () {
        setState(() => _isPlaying = false);
      },
    );
    setState(() => _isPlaying = true);
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: Text(
            "Confusion on ${widget.lesson.title}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: primaryColor.shade600,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    "Explain your confusion clearly.\nTap the mic to start recording.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // 🎤 Mic Button
                  GestureDetector(
                    onTap: _isRecording ? _stopRecording : _startRecording,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isRecording
                              ? [Colors.redAccent, Colors.deepOrange]
                              : [primaryColor.shade600, primaryColor.shade400],
                        ),
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.6),
                                  blurRadius: 25,
                                  spreadRadius: 4,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: primaryColor.shade600.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_recordedPath != null)
                    Column(
                      children: [
                        Text(
                          _isRecording
                              ? "Recording..."
                              : "Recorded audio ready to play",
                          style: TextStyle(
                              color: _isRecording
                                  ? Colors.redAccent
                                  : Colors.green.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              color: primaryColor.shade600,
                              icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed:
                                  _isPlaying ? _stopPlayback : _playRecording,
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              iconSize: 36,
                              color: Colors.redAccent,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setState(() => _recordedPath = null);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              // 🚀 Send Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _recordedPath == null
                    ? null
                    : () async {
                        // TODO: Send to backend or Firebase
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Confusion sent successfully ✅")),
                        );
                      },
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                label: const Text(
                  "Send Confusion",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
