import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/auth/view/widget/confusion_card.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/the_end.dart';

class ConfusionsPage extends ConsumerStatefulWidget {
  const ConfusionsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfusionsPageState();
}

class _ConfusionsPageState extends ConsumerState<ConfusionsPage> {
  final ScrollController _scrollController = ScrollController();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  String? _playingIndex;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
    Future.microtask(() {
      ref.read(confusionsNotifierProvider.notifier).getConfusions(context);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          loadMore();
        }
      });
    });
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

  Future loadMore() async {
    ref
        .read(confusionsNotifierProvider.notifier)
        .getConfusions(context, loadMore: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Confusion Message"),
          centerTitle: true,
          elevation: 0,
        ),
        body: ref.watch(confusionsNotifierProvider).map(
              loading: (_) => Center(
                child: CircularProgressIndicator(),
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(confusionsNotifierProvider.notifier)
                      .getConfusions(context);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: _.confusions.length + 1,
                  itemBuilder: (context, i) {
                    if (i == _.confusions.length) {
                      return _.isLoadingMore
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _.hasNoMore
                              ? TheEnd()
                              : SizedBox();
                    }
                    return ConfusionCard(
                      confusion: _.confusions[i],
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
                        _playRecording(_.confusions[i].response!);
                      },
                      playQuestion: () {
                        if (_playingIndex == "${i}q") {
                          _stopPlayback();
                          return;
                        }
                        setState(() {
                          _playingIndex = "${i}q";
                        });
                        _playRecording(_.confusions[i].audioUrl);
                      },
                    );
                  },
                ),
              ),
              empty: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No more data"),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(confusionsNotifierProvider.notifier)
                            .getConfusions(context);
                      },
                      icon: Icon(
                        Icons.refresh,
                      ),
                    )
                  ],
                ),
              ),
              error: (_) => Center(
                child: Text(
                  _.error ?? "_",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
      ),
    );
  }
}
