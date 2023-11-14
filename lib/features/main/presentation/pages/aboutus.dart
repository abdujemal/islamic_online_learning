import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';

class AboutUs extends ConsumerStatefulWidget {
  const AboutUs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends ConsumerState<AboutUs> {
  bool showTopAudio = false;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);
    return StreamBuilder(
        stream: myAudioStream(audioPlayer),
        builder: (context, snap) {
          final state = snap.data?.sequenceState;
          final process = snap.data?.processingState;

          if (state?.sequence.isEmpty ?? true) {
            showTopAudio = false;
          }
          MediaItem? metaData = state?.currentSource?.tag;

          if (metaData != null) {
            showTopAudio = true;
          }
          if (process == ProcessingState.idle) {
            showTopAudio = false;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("ስለ እኛ"),
              bottom: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  showTopAudio ? 40 : 0,
                ),
                child: showTopAudio
                    ? CurrentAudioView(metaData as MediaItem)
                    : const SizedBox(),
              ),
            ),
          );
        });
  }
}
