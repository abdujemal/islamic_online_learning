import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/template/view/controller/voice_room/voice_room_notifier.dart';
import 'package:islamic_online_learning/features/template/view/controller/voice_room/voice_room_state.dart';
import 'package:islamic_online_learning/utils.dart';
import 'package:livekit_client/livekit_client.dart';

class VoiceRoomPage extends ConsumerStatefulWidget {
  final String title;
  final int afterLessonNo;
  const VoiceRoomPage({
    super.key,
    required this.title,
    required this.afterLessonNo,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoiceRoomPageState();
}

class _VoiceRoomPageState extends ConsumerState<VoiceRoomPage> {
  // Room? room;
  // EventsListener<RoomEvent>? listener;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final voiceRoomNotifier = ref.read(voiceRoomNotifierProvider.notifier);
      voiceRoomNotifier.connect(ref, widget.title);
    });
  }

  // @override
  // void dispose() {
  //   ref.read(voiceRoomNotifierProvider.notifier).disconnect();
  //   super.dispose();
  // }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildParticipantTile(Participant p, bool isLarge) {
    final identity = p.identity;
    final isSpeaking = p.isSpeaking;
    final initials = identity.isEmpty ? 'U' : identity[0].toUpperCase();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(left: 8),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color:
            isSpeaking ? Colors.tealAccent.withOpacity(0.15) : Colors.white12,
        borderRadius: BorderRadius.circular(isLarge ? 16 : 12),
        border: Border.all(
          color: isSpeaking ? Colors.tealAccent : Colors.transparent,
          width: 3,
        ),
      ),
      width: 110,
      // height: isLarge ? 220 : 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: isLarge ? 40 : 28,
                backgroundColor: userIdToColor(identity),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: isLarge ? 28 : 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: p.isMuted
                      ? Icon(
                          Icons.mic_off,
                          size: 12,
                          color: Colors.white,
                        )
                      : p.connectionQuality == ConnectionQuality.poor
                          ? Icon(
                              Icons.signal_cellular_connected_no_internet_0_bar,
                              size: 12,
                              color: Colors.redAccent,
                            )
                          : Container(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            identity,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildMainArea(VoiceRoomState state) {
    return Column(
      children: [
        const SizedBox(height: 14),
        Row(
          children: List.generate(
            state.participants.length,
            (index) => _buildParticipantTile(
              state.participants[index],
              false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(VoiceRoomState state) {
    final connected = state.room != null;
    print('VoiceRoomPage: connected=$connected, isMuted=${state.isMuted}');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            // Mute/unmute
            FloatingActionButton(
              heroTag: 'mute',
              backgroundColor: state.isMuted ? Colors.redAccent : Colors.white,
              onPressed: () {
                if (connected) {
                  ref.read(voiceRoomNotifierProvider.notifier).toggleMute(ref);
                }
              },
              // connected ? ref.read(voiceRoomNotifierProvider.notifier).toggleMute : null,
              child: Icon(state.isMuted ? Icons.mic_off : Icons.mic,
                  color: state.isMuted ? Colors.white : Colors.black),
            ),
            const SizedBox(width: 12),
            // Leave / Join
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      connected ? Colors.redAccent : Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: state.isConnecting
                    ? null
                    : () async {
                        if (connected) {
                          await ref
                              .read(voiceRoomNotifierProvider.notifier)
                              .disconnect();
                        } else {
                          await ref
                              .read(voiceRoomNotifierProvider.notifier)
                              .connect(ref, widget.title);
                        }
                      },
                child: Text(
                  state.isConnecting
                      ? 'በመገናኘት ላይ...'
                      : (connected ? 'ጥሪውን ዝጋው' : 'ጥሪውን ጀምር'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // More (raise hand / settings) placeholder
            FloatingActionButton(
              heroTag: 'more',
              backgroundColor: Colors.white12,
              onPressed: () {
                // future actions
                _showError('Not implemented yet — settings');
              },
              child: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(VoiceRoomState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.tealAccent,
              child: const Icon(Icons.mic, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'የውይይት መድረክ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (state.room != null)
                        ? 'በ${state.identity} ስም አየር ላይ ኖት'
                        : 'አልተገናኘም',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final voiceRoomState = ref.watch(voiceRoomNotifierProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(voiceRoomNotifierProvider.notifier).disconnect();
        // return Future.value(true);
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildTopBar(voiceRoomState),
            Consumer(builder: (context, ref, _) {
              final remainingSeconds = ref.watch(remainingSecondsProvider);
              if (remainingSeconds == 0 || voiceRoomState.timer == null) {
                return Container();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    value: remainingSeconds /
                            voiceRoomState.totalSeconds,
                    backgroundColor: Colors.white12,
                    color: Colors.tealAccent,
                  ),
                  Text(
                      "${remainingSeconds /
                            voiceRoomState.totalSeconds}"),
                  Text(
                    'ቀሪ ጊዜ: ${formatTime(remainingSeconds)}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            }),
            Expanded(child: _buildMainArea(voiceRoomState)),
            _buildBottomControls(voiceRoomState),
          ],
        ),
      ),
    );
  }
}
