import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_notifier.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_state.dart';
import 'package:islamic_online_learning/features/meeting/view/widget/discussion_task_ui.dart';
import 'package:islamic_online_learning/utils.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pdfx/pdfx.dart';

class VoiceRoomPage extends ConsumerStatefulWidget {
  final String title;
  final int afterLessonNo;
  final int fromLesson;
  final Lesson currentLesson;
  final AssignedCourse currentCourse;
  const VoiceRoomPage({
    super.key,
    required this.title,
    required this.afterLessonNo,
    required this.fromLesson,
    required this.currentCourse,
    required this.currentLesson,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoiceRoomPageState();
}

class _VoiceRoomPageState extends ConsumerState<VoiceRoomPage>
    with WidgetsBindingObserver {
  bool canPop = false;

  PdfController? _pdfController;

  // Room? room;
  // EventsListener<RoomEvent>? listener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      final voiceRoomNotifier = ref.read(voiceRoomNotifierProvider.notifier);
      // final voiceRoomState = ref.read(voiceRoomNotifierProvider);
      voiceRoomNotifier.connect(
        ref,
        widget.title,
        widget.fromLesson,
      );
    });
  }

  @override
  void dispose() {
    // ref.read(voiceRoomNotifierProvider.notifier).disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      ref.read(voiceRoomNotifierProvider.notifier).disconnect(ref);
    }
  }

  Widget _buildParticipantTile(Participant p, bool isLarge) {
    final identity = p.identity;
    final isMe = p.runtimeType != RemoteParticipant;
    final isSpeaking = p.isSpeaking;
    // final isRest = p.isDisposed;
    final initials = identity.isEmpty ? 'U' : identity[0].toUpperCase();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: EdgeInsets.all(isSpeaking ? 5 : 0),
                margin: EdgeInsets.all(isSpeaking ? 0 : 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSpeaking ? Colors.tealAccent : Colors.transparent,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: userIdToColor(identity),
                        // borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSpeaking
                              ? Colors.tealAccent
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: isLarge ? 28 : 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(p.isMuted ? 2 : 0),
                        decoration: BoxDecoration(
                          color: Colors.black45,
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
                                    Icons
                                        .signal_cellular_connected_no_internet_0_bar,
                                    size: 12,
                                    color: Colors.redAccent,
                                  )
                                : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "$identity ${isMe ? "(እርሶ)" : ""}",
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
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Consumer(builder: (context, ref, _) {
        final participants = ref.watch(participantsProvider);
        return Row(
          children: List.generate(
            participants.length,
            (index) => _buildParticipantTile(
              participants[index],
              false,
            ),
          ),
        );
      }),
    );
  }

  void _showOptionMenu(BuildContext context, Offset position) async {
    final selected = await showMenu<String>(
      context: context,
      color: Theme.of(context).cardColor,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, 0),
      items: [
        "Call Admins",
      ]
          .map((val) => PopupMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  // style: TextStyle(
                  //   fontWeight: speed == currentSpeed
                  //       ? FontWeight.bold
                  //       : FontWeight.normal,
                  //   color: speed == currentSpeed ? primaryColor : null,
                  // ),
                ),
              ))
          .toList(),
    );
    print("selected:$selected");

    if (selected == "Call Admins") {
      ref.read(voiceRoomNotifierProvider.notifier).callAdmins(context);
    } else {
      print("non");
    }
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
              backgroundColor: state.isMuted
                  ? Colors.redAccent
                  : Theme.of(context).cardColor,
              onPressed: () {
                if (connected) {
                  ref.read(voiceRoomNotifierProvider.notifier).toggleMute(ref);
                }
              },
              // connected ? ref.read(voiceRoomNotifierProvider.notifier).toggleMute : null,
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              child: Icon(state.isMuted ? Icons.mic_off : Icons.mic,
                  color: state.isMuted ? Colors.white : null),
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
                              .disconnect(ref);
                        } else {
                          await ref
                              .read(voiceRoomNotifierProvider.notifier)
                              .connect(ref, widget.title, widget.fromLesson);
                        }
                      },
                child: Text(
                  state.isConnecting
                      ? 'በመገናኘት ላይ...'
                      : (connected ? 'ጥሪውን ዝጋው' : 'ጥሪውን ጀምር'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // More (raise hand / settings) placeholder
            GestureDetector(
              onTapDown: (td) {
                final x = td.globalPosition.dx - 50;
                final y = td.globalPosition.dy - 100;

                _showOptionMenu(context, Offset(x, y));
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                // heroTag: 'more',
                // foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
                // backgroundColor: Theme.of(context).cardColor,
                // // backgroundColor: Colors.white12,
                // onPressed: () {
                //   // future actions
                // },
                child: const Icon(Icons.more_vert, color: null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(VoiceRoomState state) {
    return SafeArea(
      child: Column(
        children: [
          if (state.examData != null)
            Container(
              width: double.infinity,
              color: Colors.amberAccent,
              child: Text(
                "ከዚህ ውይይት ቡሃላ ፈተና ይኖራል።",
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
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
                          // color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer(builder: (context, ref, _) {
                  final isPdfShown =
                      ref.watch(voiceRoomNotifierProvider).pdfShown;
                  return isPdfShown
                      ? SizedBox()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_pdfController != null) {
                              ref
                                  .read(voiceRoomNotifierProvider.notifier)
                                  .togglePdfShown();
                              return;
                            }
                            toast("Loading...", ToastType.normal, context,
                                isLong: true);
                            final pdfId = widget.currentCourse.course?.pdfId;
                            // final courseModel = state.currentCourse?.course;
                            print("mmmmmmm pdfId: $pdfId");
                            if (pdfId == null) return;
                            final courseModel = await DatabaseHelper()
                                .getSingleCourse(
                                    widget.currentCourse.course!.courseId);
                            print("mmmmmmm courseModel: $courseModel");
                            if (courseModel == null) return;
                            String? pdfPath = await ref
                                .read(lessonNotifierProvider.notifier)
                                .getPdfPath(
                                  ref,
                                  courseModel,
                                  widget.currentCourse.title,
                                  widget.currentLesson.volume,
                                  widget.currentCourse.course!
                                      .pdfSize[widget.currentLesson.volume],
                                );
                            if (pdfPath == null) {
                              toast("ማሳየት አልተቻለም!", ToastType.error, context);
                              return;
                            }
                            print(
                                "Page num: ${widget.currentLesson.startPage}");
                            _pdfController = PdfController(
                              initialPage: widget.currentLesson.startPage,
                              document: PdfDocument.openFile(pdfPath),
                            );
                            setState(() {});
                            ref
                                .read(voiceRoomNotifierProvider.notifier)
                                .togglePdfShown();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("ኪታቡን አሳይ"),
                        );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(VoiceRoomState voiceRoomState) {
    return Consumer(builder: (context, ref, _) {
      final remainingSeconds = ref.watch(remainingSecondsProvider);
      if (remainingSeconds == 0 || voiceRoomState.timer == null) {
        return Container();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: remainingSeconds / voiceRoomState.givenTime!.totalTime,
            backgroundColor: Colors.white12,
            color: Colors.tealAccent,
          ),
          Text(
            'ቀሪ ጊዜ: ${formatTime(remainingSeconds)}',
            // style: TextStyle(
            //   color: Colors.white70,
            // ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceRoomState = ref.watch(voiceRoomNotifierProvider);
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (canPop == false) {
          if (voiceRoomState.room == null) {
            toast("please press it again.", ToastType.normal, context);
          } else {
            ref.read(voiceRoomNotifierProvider.notifier).disconnect(ref);
          }
          setState(() {
            canPop = true;
          });
        }

        // return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(voiceRoomState),
              _buildProgressBar(voiceRoomState),
              Expanded(
                child: Column(
                  children: [
                    _buildMainArea(voiceRoomState),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final isPdfShown =
                              ref.watch(voiceRoomNotifierProvider).pdfShown;

                          //   // PdfPage(
                          //   //   path: "https://b2.ilmfelagi.com/file/ilm-Felagi2/%E1%8A%90%E1%88%B2%E1%88%90%E1%89%B2%20%E1%88%8A%E1%8A%A0%E1%88%85%E1%88%8A%20%E1%88%B1%E1%8A%93%20%E1%89%A0%E1%8A%A0%E1%89%A1%20%E1%88%99%E1%88%B5%E1%88%8A%E1%88%9D/%D9%86%D8%B5%D9%8A%D8%AD%D8%AA%D9%8A_%D9%84%D8%A3%D9%87%D9%84_%D8%A7%D9%84%D8%B3%D9%86%D8%A9.pdf",
                          //   //   volume: 1,
                          //   //   courseModel: voiceRoomState.assignedCourse,
                          //   // );
                          // }

                          return Stack(
                            children: [
                              DiscussionTaskUi(
                                status: voiceRoomState.status,
                              ),
                              if (isPdfShown)
                                Stack(
                                  children: [
                                    if (_pdfController != null)
                                      PdfView(
                                        controller: _pdfController!,
                                        pageSnapping: false,
                                        scrollDirection: Axis.vertical,
                                      ),
                                    Positioned(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: IconButton(
                                          onPressed: () {
                                            ref
                                                .read(voiceRoomNotifierProvider
                                                    .notifier)
                                                .togglePdfShown();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    _buildBottomControls(voiceRoomState),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
