import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';

class CurrentAudioView extends ConsumerStatefulWidget {
  final AudioModel audioModel;
  const CurrentAudioView(this.audioModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentAudioViewState();
}

class _CurrentAudioViewState extends ConsumerState<CurrentAudioView> {
  @override
  Widget build(BuildContext context) {
    final currentAudio = widget.audioModel;
    return Container(
      color: primaryColor,
      child: ListTile(
        title: Text(
          currentAudio.title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          currentAudio.ustaz,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () {
            ref.read(audioProvider).stop();
            ref.read(currentAudioProvider.notifier).update((state) => null);
          },
          icon: const Icon(Icons.close),
        ),
        leading: IconButton(
          icon: currentAudio.audioState.isPlaused()
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          onPressed: () {
            ref.read(currentAudioProvider.notifier).update(
                  (state) => state!.copyWith(
                    audioState: currentAudio.audioState.isPlaused()
                        ? AudioState.playing
                        : AudioState.paused,
                  ),
                );
            if (currentAudio.audioState.isPlaused()) {
              ref.read(audioProvider).resume();
            } else {
              ref.read(audioProvider).pause();
            }
          },
        ),
      ),
    );
  }
}
