import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';

class AboutUs extends ConsumerStatefulWidget {
  const AboutUs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends ConsumerState<AboutUs> {
  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ስለ እኛ"),
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            currentAudio != null ? 40 : 0,
          ),
          child: currentAudio != null
              ? CurrentAudioView(currentAudio)
              : const SizedBox(),
        ),
      ),
    );
  }
}
