import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/pages/islamic_streak_page.dart';
import 'package:islamic_online_learning/features/quiz/model/question.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/meeting/model/discussion.dart';
import 'package:islamic_online_learning/features/meeting/service/voice_room_service.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_state.dart';
import 'package:islamic_online_learning/features/meeting/view/widget/discussion_completed_ui.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/pages/question_page.dart';
// import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final participantsProvider = StateProvider<List<dynamic>>((ref) => []);

final remainingSecondsProvider = StateProvider<int>((ref) => 0);
final discussionQuizzesProvider = StateProvider<List<Quiz>?>((ref) => null);
final discussionQuestionsProvider =
    StateProvider<List<Question>?>((ref) => null);
final discussionTopicsProvider = StateProvider<List<String>?>((ref) => null);

final voiceRoomNotifierProvider =
    StateNotifierProvider<VoiceRoomNotifier, VoiceRoomState>((ref) {
  return VoiceRoomNotifier(ref.read(voiceRoomServiceProvider), ref);
});

final qaStateProvider = StateProvider<List<QA>>((ref) => []);
final quizAnsStateProvider = StateProvider<List<QuizAns>>((ref) => []);

final isSubmittingProvider = StateProvider<bool>((ref) => false);

class VoiceRoomNotifier extends StateNotifier<VoiceRoomState> {
  final VoiceRoomService voiceRoomService;
  final Ref ref;
  VoiceRoomNotifier(this.voiceRoomService, this.ref) : super(VoiceRoomState());

  void startTimer(WidgetRef ref, int seconds, Discussion discussionModel) {
    ref.read(remainingSecondsProvider.notifier).state = seconds;
    state.timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final remainingSeconds = ref.read(remainingSecondsProvider);
      if (remainingSeconds == 0) {
        timer.cancel();
        // state.room?.disconnect();
        await disconnect(ref);
        state = state.copyWith(status: VoiceRoomStatus.end);
        Navigator.pushReplacement(
          ref.context,
          MaterialPageRoute(
            builder: (_) => DiscussionCompletedUi(),
          ),
        );
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

  void changeVoiceRoomStatus(VoiceRoomStatus status) {
    state = state.copyWith(status: status);
    // if (status == VoiceRoomStatus.short) {
      
    //   return;
    // }
  }

  void changeStatus(
      int remainingSeconds, WidgetRef ref, Discussion discussionModel) {
    if (state.givenTime == null) return;
    GivenTime givenTime = state.givenTime!;
    int sec = givenTime.totalTime - remainingSeconds;
    int discussion = 0;
    int quiz = discussion + givenTime.segments.discussion;
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
    int quiz = discussion + givenTime.segments.discussion;
    int assignment = givenTime.segments.assignment;
    print(
        "sec: $sec, discussion: $discussion, quiz: $quiz, assignment: $assignment");
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

  Future<Discussion> _createDiscussion(String title, int fromLesson) async {
    final discussion =
        await voiceRoomService.createDiscussion(title, fromLesson);
    return discussion;
  }

  void togglePdfShown() {
    state = state.copyWith(pdfShown: !state.pdfShown);
  }

  void setExamData(ExamData? examData) {
    state = state.copyWith(examData: examData);
  }

  void setAssignedCourse(AssignedCourse? assignedCourse) {
    state = state.copyWith(assignedCourse: assignedCourse);
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

  // Future<String> _fetchToken(String identity, String roomName) async {
  //   final resp = await customPostRequest(
  //     TOKEN_ENDPOINT,
  //     {"identity": identity, "room": roomName},
  //     authorized: true,
  //   );

  //   if (resp.statusCode != 200) {
  //     throw Exception(
  //         'Token request failed (${resp.statusCode}): ${resp.body}');
  //   }
  //   // Accept both JSON { token } and plain string body
  //   try {
  //     final j = json.decode(resp.body);
  //     if (j is Map && j['token'] != null) return j['token'];
  //   } catch (_) {}
  //   return resp.body.trim();
  // }

  Future<void> connect(WidgetRef ref, String title, int fromLesson) async {
    state = state.copyWith(isConnecting: true);
    try {
      await _ensureMicPermission();

      final authState = ref.read(authNotifierProvider);

      if (authState.user == null) {
        toast("መለያዎ አይታወቅም!", ToastType.error, ref.context);
        return;
      }

      final discussion = await _createDiscussion(title, fromLesson);

      state = state.copyWith(
        roomName: discussion.id,
        identity: authState.user!.name,
        givenTime: discussion.givenTime,
        discussionSec: discussion.discussionSecond,
      );

      initStatus(discussion.discussionSecond ?? 0, ref, discussion);

      initAnswer(ref);

      // final token = await _fetchToken(state.identity, state.roomName);

      // Connect to LiveKit. In typical LiveKit Cloud flow you pass the WSS URL
      // and the server-generated token (JWT).
      // final roomOptions = RoomOptions(
      //   adaptiveStream: true,
      //   dynacast: true,

      //   // ... your room options
      // );

      // final room = Room(roomOptions: roomOptions);

      // await room.connect(discussion.url!, token);

      startTimer(ref, discussion.discussionSecond ?? 0, discussion);

      // await room.localParticipant?.setMicrophoneEnabled(true);

      // void updateParticipants() {
      //   final remote = room.remoteParticipants;
      //   // convert to RemoteParticipant list snapshot:
      //   print("remote participants: ${remote.length}");
      //   final list = remote.values.whereType<RemoteParticipant>().toList();

      //   List<dynamic> _participants = [
      //     ...list,
      //   ];
      //   if (room.localParticipant != null) {
      //     _participants = [..._participants, room.localParticipant];
      //   }
      //   if (_participants.isNotEmpty) {
      //     _participants.sort((dynamic a, dynamic b) {
      //       final aSpeaking = a.isSpeaking ? 1 : 0;
      //       final bSpeaking = b.isSpeaking ? 1 : 0;
      //       return bSpeaking - aSpeaking;
      //     });
      //   }

      //   // state = state.copyWith(participants: _participants);
      //   ref.read(participantsProvider.notifier).state = _participants;
      // }

      // state = state.copyWith(listener: room.createListener());
      // state.listener!
      //   ..on<RoomDisconnectedEvent>((_) {
      //     // handle disconnect
      //     print('Disconnected: ${_.reason}');
      //     // _stopSpeakerPoll();
      //     // setState(() {
      //     //   _participants = [];
      //     // });
      //     ref.read(participantsProvider.notifier).state = [];
      //   })
      //   ..on<ParticipantConnectedEvent>((e) {
      //     updateParticipants();
      //     print("participant joined: ${e.participant.identity}");
      //   })
      //   ..on<ParticipantDisconnectedEvent>((e) {
      //     updateParticipants();
      //     print("participant left: ${e.participant.identity}");
      //   })
      //   ..on<ParticipantEvent>((e) {
      //     updateParticipants();
      //     print("participant Event changed");
      //   })
      //   ..on<ActiveSpeakersChangedEvent>((e) {
      //     updateParticipants();
      //     print("participant speaking changed");
      //   });
      // // ..on<Participant>((e) {
      // //    print("participant data changed: ${e.identity}");
      // //   updateParticipants();
      // // });

      // // Keep participants in local state

      // // initial snapshot
      // updateParticipants();

      // subscribe to participant events (SDK exposes participant events; this uses a simple poll)
      // _speakerPollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      //   updateParticipants();
      // });

      // Automatically enable mic (local publish)
      // try {
      //   await state.room!.localParticipant
      //       ?.setMicrophoneEnabled(!state.isMuted);
      // } catch (e) {
      //   print('Could not enable mic: $e');
      // }

      // setState(() {
      //   _room = room;
      //   _isConnecting = false;
      // });
      state = state.copyWith(
        // room: room,
        isConnecting: false,
      );
    } catch (e) {
      // setState(() => _isConnecting = false);
      state = state.copyWith(isConnecting: false);
      if (e.toString().contains("Meeting already done")) {
        toast('ጥያቄዎቹ አልቋል!', ToastType.error, ref.context);
        return;
      }
      handleError(e.toString(), ref.context, this.ref, () {});
      print(e.toString());
      toast(
        getErrorMsg(e.toString(), 'Connection failed: $e'),
        ToastType.error,
        ref.context,
      );
    }
  }

  Future<void> disconnect(WidgetRef ref) async {
    // _stopSpeakerPoll();
    try {
      // await state.room?.disconnect();
      // await state.listener?.dispose();
      ref.read(participantsProvider.notifier).state = [];
      state.timer?.cancel();
    } catch (_) {}
    // state = state.copyWith(
    //   room: null,
    //   participants: [],
    // );
    state = VoiceRoomState(
        examData: state.examData, assignedCourse: state.assignedCourse);
    // print('Disconnected from room ${state.room == null}');
    // setState(() {
    //   _room = null;
    //   _participants = [];
    // });
  }

  // Future<void> toggleMute(WidgetRef ref) async {
  //   try {
  //     final newMuted = !state.isMuted;
  //     await state.room?.localParticipant?.setMicrophoneEnabled(!newMuted);
  //     // setState(() {
  //     //   _isMuted = newMuted;
  //     // });
  //     state = state.copyWith(isMuted: newMuted);
  //   } catch (e) {
  //     toast('Failed to toggle mic: $e', ToastType.error, ref.context);
  //   }
  // }

  Future<void> getDiscussionQuizzes(WidgetRef ref) async {
    try {
      final quizzes = await voiceRoomService.getQuizzesForDiscussion();
      ref.read(discussionQuizzesProvider.notifier).state = quizzes;
    } catch (e) {
      handleError(e.toString(), ref.context, this.ref, () {
        toast(getErrorMsg(e.toString(), e.toString()), ToastType.error,
            ref.context);
        print("Error fetching discussion quizzes: $e");
        ref.read(discussionQuizzesProvider.notifier).state = [];
      });
    }
  }

  Future<void> getDiscussionShortAnswers(WidgetRef ref) async {
    try {
      final shortAnswers = await voiceRoomService.getQuestionsForDiscussion();
      ref.read(discussionQuestionsProvider.notifier).state = shortAnswers;
    } catch (e) {
      handleError(e.toString(), ref.context, this.ref, () {
        toast(getErrorMsg(e.toString(), e.toString()), ToastType.error,
            ref.context);
        print("Error fetching discussion short answer: $e");
        ref.read(discussionQuestionsProvider.notifier).state = [];
      });
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

  Future<void> initAnswer(WidgetRef ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<dynamic> res1 =
        json.decode(pref.getString(PrefConsts.discussionQuestions) ?? "[]");
    List<QA> qas = res1.map((e) => QA.fromMap(e)).toList();

    List<dynamic> res2 =
        json.decode(pref.getString(PrefConsts.discussionQuizzes) ?? "[]");
    List<QuizAns> quizAnses = res2.map((e) => QuizAns.fromMap(e)).toList();

    ref.read(qaStateProvider.notifier).state = qas;
    ref.read(quizAnsStateProvider.notifier).state = quizAnses;
  }

  Future<void> submitAnswerForQuestion(WidgetRef ref, QA qa) async {
    final qas = ref.read(qaStateProvider);
    final cond = qas.where((e) => e.questionId == qa.questionId).isNotEmpty;
    if (cond) {
      final newList =
          qas.map((e) => e.questionId == qa.questionId ? qa : e).toList();
      ref.read(qaStateProvider.notifier).state = newList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lst = newList
          .map(
            (e) => e.toJson(),
          )
          .toList()
          .toString();
      print({"lst": lst});
      pref.setString(
        PrefConsts.discussionQuestions,
        lst,
      );
    } else {
      final newList = [...qas, qa];
      ref.read(qaStateProvider.notifier).state = newList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lst = newList
          .map(
            (e) => e.toJson(),
          )
          .toList()
          .toString();
      print({"lst": lst});
      pref.setString(
        PrefConsts.discussionQuestions,
        lst,
      );
    }
  }

  Future<void> submitAnswerForQuiz(WidgetRef ref, QuizAns qa) async {
    final qas = ref.read(quizAnsStateProvider);
    final cond = qas.where((e) => e.quizId == qa.quizId).isNotEmpty;
    if (cond) {
      final newList = qas.map((e) => e.quizId == qa.quizId ? qa : e).toList();
      ref.read(quizAnsStateProvider.notifier).state = newList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lst = newList
          .map(
            (e) => e.toJson(),
          )
          .toList()
          .toString();
      print({"lst": lst});
      pref.setString(
        PrefConsts.discussionQuizzes,
        lst,
      );
    } else {
      final newList = [...qas, qa];
      ref.read(quizAnsStateProvider.notifier).state = newList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lst = newList
          .map(
            (e) => e.toJson(),
          )
          .toList()
          .toString();
      print({"lst": lst});
      pref.setString(
        PrefConsts.discussionQuizzes,
        lst,
      );
    }
  }

  Future<void> submitDiscussionTask(WidgetRef ref) async {
    final qas = ref.read(qaStateProvider);
    final quizAns = ref.read(quizAnsStateProvider);
    try {
      ref.read(isSubmittingProvider.notifier).state = true;
      final streakWithNo =
          await voiceRoomService.submitDiscussionTasks(qas, quizAns);

      ref.read(currentStreakProvider.notifier).setStreak(streakWithNo);
      ref.read(isSubmittingProvider.notifier).state = false;

      if (ref.context.mounted) {
        if (state.examData != null) {
          Navigator.push(
            ref.context,
            MaterialPageRoute(
              builder: (_) => QuestionPage(state.examData!.title),
            ),
          );
        } else {
          Navigator.pushReplacement(
            ref.context,
            MaterialPageRoute(
              builder: (_) => IslamicStreakPage(type: "Discussion"),
            ),
          );
        }
      }
    } catch (e) {
      ref.read(isSubmittingProvider.notifier).state = false;
      handleError(e.toString(), ref.context, this.ref, () {
        toast(getErrorMsg(e.toString(), e.toString()), ToastType.error,
            ref.context);
        print(e);
      });
    }
  }

  Future<void> callAdmins(BuildContext context) async {
    try {
      toast("calling...", ToastType.normal, context);
      await voiceRoomService.callAdmin();
      toast(
        "Admin will join your call soon.",
        ToastType.success,
        context,
        isLong: true,
      );
    } catch (err) {
      handleError(err.toString(), context, this.ref, () {
        toast(getErrorMsg(err.toString(), err.toString()), ToastType.error,
            context);
        print(err);
      });
    }
  }

  @override
  void dispose() {
    // state.room?.disconnect();
    // state.room?.dispose();
    // state.listener?.dispose();
    state.timer?.cancel();
    state = VoiceRoomState(
        examData: state.examData, assignedCourse: state.assignedCourse);
    super.dispose();
  }
}
