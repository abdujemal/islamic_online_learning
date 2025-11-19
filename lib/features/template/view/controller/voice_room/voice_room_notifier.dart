import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/model/question.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';
import 'package:islamic_online_learning/features/template/model/discussion.dart';
import 'package:islamic_online_learning/features/template/service/voice_room_service.dart';
import 'package:islamic_online_learning/features/template/view/controller/voice_room/voice_room_state.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

final remainingSecondsProvider = StateProvider<int>((ref) => 0);
final discussionQuizzesProvider = StateProvider<List<Quiz>?>((ref) => null);
final discussionQuestionsProvider =
    StateProvider<List<Question>?>((ref) => null);
final discussionTopicsProvider = StateProvider<List<String>?>((ref) => null);

final voiceRoomNotifierProvider =
    StateNotifierProvider<VoiceRoomNotifier, VoiceRoomState>((ref) {
  return VoiceRoomNotifier(ref.read(voiceRoomServiceProvider));
});

class VoiceRoomNotifier extends StateNotifier<VoiceRoomState> {
  final VoiceRoomService voiceRoomService;
  VoiceRoomNotifier(this.voiceRoomService) : super(VoiceRoomState());

  void startTimer(WidgetRef ref, int seconds, Discussion discussionModel) {
    ref.read(remainingSecondsProvider.notifier).state = seconds;
    state.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingSeconds = ref.read(remainingSecondsProvider);
      if (remainingSeconds == 0) {
        timer.cancel();
        state.room?.disconnect();
        state = state.copyWith(
            room: null, participants: [], status: VoiceRoomStatus.end);
        // _showTimeUpDialog();
      } else {
        changeStatus(remainingSeconds - 1, ref, discussionModel);
        ref.read(remainingSecondsProvider.notifier).state =
            remainingSeconds - 1;
        // setState(() {
        //   _remainingSeconds--;
        // });
      }
    });
  }

  void changeStatus(
      int remainingSeconds, WidgetRef ref, Discussion discussionModel) {
    if (state.givenTime == null) return;
    GivenTime givenTime = state.givenTime!;
    int sec = givenTime.totalTime - remainingSeconds;
    int discussion = 0;
    int quiz = discussion + givenTime.segments.quiz;
    int assignment = givenTime.segments.assignment;
    print("$sec $discussion $quiz $assignment");

    if (sec == discussion) {
      getTopicsOfDiscussion(
        ref,
        discussionModel.fromLesson,
        discussionModel.toLesson,
      );
      state = state.copyWith(status: VoiceRoomStatus.discussing);
      return;
    } else if (sec == quiz) {
      state = state.copyWith(status: VoiceRoomStatus.choice);
      getDiscussionQuizzes(ref);
      return;
    } else if (sec == assignment) {
      getDiscussionShortAnswers(ref);
      state = state.copyWith(status: VoiceRoomStatus.short);
      return;
    }
  }

  void initStatus(int seconds, WidgetRef ref, Discussion discussionModel) {
    GivenTime givenTime = state.givenTime!;
    int sec = givenTime.totalTime - seconds;
    int discussion = 0;
    int quiz = discussion + givenTime.segments.quiz;
    int assignment = givenTime.segments.assignment;
    if (sec > assignment) {
      getDiscussionShortAnswers(ref);
      state = state.copyWith(status: VoiceRoomStatus.short);
      return;
    } else if (sec > quiz) {
      getDiscussionQuizzes(ref);
      state = state.copyWith(status: VoiceRoomStatus.choice);
      return;
    } else if (sec >= discussion) {
      getTopicsOfDiscussion(
        ref,
        discussionModel.fromLesson,
        discussionModel.toLesson,
      );
      state = state.copyWith(status: VoiceRoomStatus.discussing);
      return;
    }
  }

  Future<Discussion> _createDiscussion(String title) async {
    final discussion = await voiceRoomService.createDiscussion(title);
    return discussion;
  }

  Future<void> _ensureMicPermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        throw Exception('Microphone permission not granted');
      }
    }
  }

  Future<String> _fetchToken(String identity, String roomName) async {
    final resp = await customPostRequest(
      TOKEN_ENDPOINT,
      {"identity": identity, "room": roomName},
      authorized: true,
    );

    if (resp.statusCode != 200) {
      throw Exception(
          'Token request failed (${resp.statusCode}): ${resp.body}');
    }
    // Accept both JSON { token } and plain string body
    try {
      final j = json.decode(resp.body);
      if (j is Map && j['token'] != null) return j['token'];
    } catch (_) {}
    return resp.body.trim();
  }

  Future<void> connect(WidgetRef ref, String title) async {
    state = state.copyWith(isConnecting: true);
    try {
      await _ensureMicPermission();

      final authState = ref.read(authNotifierProvider);

      if (authState.user == null) {
        toast("መለያዎ አይታወቅም!", ToastType.error, ref.context);
        return;
      }

      final discussion = await _createDiscussion(title);

      state = state.copyWith(
        roomName: discussion.id,
        identity: authState.user!.name,
        givenTime: discussion.givenTime,
      );
      initStatus(discussion.discussionSecond, ref, discussion);

      final token = await _fetchToken(state.identity, state.roomName);

      // Connect to LiveKit. In typical LiveKit Cloud flow you pass the WSS URL
      // and the server-generated token (JWT).
      final roomOptions = RoomOptions(
        adaptiveStream: true,
        dynacast: true,

        // ... your room options
      );

      final room = Room(roomOptions: roomOptions);

      await room.connect(LIVEKIT_URL, token);

      startTimer(ref, discussion.discussionSecond, discussion);

      await room.localParticipant?.setMicrophoneEnabled(true);

      void updateParticipants() {
        final remote = room.remoteParticipants;
        // convert to RemoteParticipant list snapshot:
        print("remote participants: ${remote.length}");
        final list = remote.values.whereType<RemoteParticipant>().toList();

        List<dynamic> _participants = [
          ...list,
        ];
        if (room.localParticipant != null) {
          _participants = [..._participants, room.localParticipant];
        }
        if (_participants.isNotEmpty) {
          _participants.sort((dynamic a, dynamic b) {
            final aSpeaking = a.isSpeaking ? 1 : 0;
            final bSpeaking = b.isSpeaking ? 1 : 0;
            return bSpeaking - aSpeaking;
          });
        }

        state = state.copyWith(participants: _participants);
      }

      state = state.copyWith(listener: room.createListener());
      state.listener!
        ..on<RoomDisconnectedEvent>((_) {
          // handle disconnect
          print('Disconnected: ${_.reason}');
          // _stopSpeakerPoll();
          // setState(() {
          //   _participants = [];
          // });
          state = state.copyWith(participants: []);
        })
        ..on<ParticipantConnectedEvent>((e) {
          updateParticipants();
          print("participant joined: ${e.participant.identity}");
        })
        ..on<ParticipantDisconnectedEvent>((e) {
          updateParticipants();
          print("participant left: ${e.participant.identity}");
        })
        ..on<ParticipantEvent>((e) {
          updateParticipants();
          print("participant Event changed");
        })
        ..on<ActiveSpeakersChangedEvent>((e) {
          updateParticipants();
          print("participant speaking changed");
        });
      // ..on<Participant>((e) {
      //    print("participant data changed: ${e.identity}");
      //   updateParticipants();
      // });

      // Keep participants in local state

      // initial snapshot
      updateParticipants();

      // subscribe to participant events (SDK exposes participant events; this uses a simple poll)
      // _speakerPollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      //   updateParticipants();
      // });

      // Automatically enable mic (local publish)
      try {
        await state.room!.localParticipant
            ?.setMicrophoneEnabled(!state.isMuted);
      } catch (e) {
        print('Could not enable mic: $e');
      }

      // setState(() {
      //   _room = room;
      //   _isConnecting = false;
      // });
      state = state.copyWith(
        room: room,
        isConnecting: false,
      );
    } catch (e) {
      // setState(() => _isConnecting = false);
      state = state.copyWith(isConnecting: false);
      if (e.toString().contains("Meeting already done")) {
        toast('ውይይቱ አልቋል!', ToastType.error, ref.context);
        return;
      }
      print(e.toString());
      toast('Connection failed: $e', ToastType.error, ref.context);
    }
  }

  Future<void> disconnect() async {
    // _stopSpeakerPoll();
    try {
      await state.room?.disconnect();
      await state.listener?.dispose();

      state.timer?.cancel();
    } catch (_) {}
    // state = state.copyWith(
    //   room: null,
    //   participants: [],
    // );
    state = VoiceRoomState();
    print('Disconnected from room ${state.room == null}');
    // setState(() {
    //   _room = null;
    //   _participants = [];
    // });
  }

  Future<void> toggleMute(WidgetRef ref) async {
    try {
      final newMuted = !state.isMuted;
      await state.room?.localParticipant?.setMicrophoneEnabled(!newMuted);
      // setState(() {
      //   _isMuted = newMuted;
      // });
      state = state.copyWith(isMuted: newMuted);
    } catch (e) {
      toast('Failed to toggle mic: $e', ToastType.error, ref.context);
    }
  }

  Future<void> getDiscussionQuizzes(WidgetRef ref) async {
    try {
      final quizzes = await voiceRoomService.getQuizzesForDiscussion();
      ref.read(discussionQuizzesProvider.notifier).state = quizzes;
    } catch (e) {
      toast(e.toString(), ToastType.error, ref.context);
      print("Error fetching discussion quizzes: $e");
      ref.read(discussionQuizzesProvider.notifier).state = [];
    }
  }

  Future<void> getDiscussionShortAnswers(WidgetRef ref) async {
    try {
      final shortAnswers = await voiceRoomService.getQuestionsForDiscussion();
      ref.read(discussionQuestionsProvider.notifier).state = shortAnswers;
    } catch (e) {
      toast(e.toString(), ToastType.error, ref.context);
      print("Error fetching discussion short answer: $e");
      ref.read(discussionQuestionsProvider.notifier).state = [];
    }
  }

  void getTopicsOfDiscussion(WidgetRef ref, int fromLesson, int toLesson) {
    final lessons =
        ref.read(assignedCoursesNotifierProvider).curriculum?.lessons;
    if (lessons == null) return;
    final selectedLessons = lessons
        .where(
            (lesson) => lesson.order >= fromLesson && lesson.order <= toLesson)
        .toList();

    final topics = selectedLessons.map((e) => e.title).toList();
    ref.read(discussionTopicsProvider.notifier).state = topics;
  }

  @override
  void dispose() {
    state.listener?.dispose();
    state.room?.dispose();
    state.timer?.cancel();
    state = VoiceRoomState();
    super.dispose();
  }
}
