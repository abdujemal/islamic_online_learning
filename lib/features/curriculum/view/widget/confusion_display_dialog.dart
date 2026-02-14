import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:islamic_online_learning/features/auth/view/widget/confusion_card.dart';

class ConfusionDisplayDialog extends ConsumerStatefulWidget {
  final Confusion confusion;
  const ConfusionDisplayDialog({
    super.key,
    required this.confusion,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfusionDisplayDialogState();
}

class _ConfusionDisplayDialogState
    extends ConsumerState<ConfusionDisplayDialog> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  String? _playingIndex;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
  }

  Future<void> _playRecording(String url) async {
    await _player.startPlayer(
      fromURI: url,
      whenFinished: () {
        setState(() => _playingIndex = null);
      },
    );
    // setState(() => _playingIndex = null);
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    setState(() => _playingIndex = null);
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i = widget.confusion.id;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: primaryColor.withAlpha(60), spreadRadius: 3, blurRadius: 6)
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ጥያቄ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ConfusionCard(
                confusion: widget.confusion,
                isAnswerPlaying: _playingIndex == "${i}a",
                isQuestionPlaying: _playingIndex == "${i}q",
                playAnswer: () {
                  if (_playingIndex == "${i}a") {
                    _stopPlayback();
                    return;
                  }
                  setState(() {
                    _playingIndex = "${i}a";
                  });
                  _playRecording(widget.confusion.response!);
                },
                playQuestion: () {
                  if (_playingIndex == "${i}q") {
                    _stopPlayback();
                    return;
                  }
                  setState(() {
                    _playingIndex = "${i}q";
                  });
                  _playRecording(widget.confusion.audioUrl);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
