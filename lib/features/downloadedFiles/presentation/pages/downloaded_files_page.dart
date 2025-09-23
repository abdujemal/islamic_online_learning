import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/d_audios_page.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/d_pdfs_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../../core/Audio Feature/playlist_helper.dart';

class DownloadedFilesPage extends ConsumerStatefulWidget {
  const DownloadedFilesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DownloadedFilesPageState();
}

class _DownloadedFilesPageState extends ConsumerState<DownloadedFilesPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool showTopAudio = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = PlaylistHelper.audioPlayer;

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
              title: const Text("ዳውንሎድ የተደረጉ"),
              bottom: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  showTopAudio ? 100 : 60,
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: tabController,
                      tabs: const [
                        Tab(
                          child: Text(
                            'ፒዲኡፎች',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'ድምጾች',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                    if (showTopAudio) CurrentAudioView(metaData as MediaItem)
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: const [
                  DPdfsPage(),
                  DAudiosPage(),
                ],
              ),
            ),
          );
        });
  }
}
