// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:text_scroll/text_scroll.dart';

// class CDAppBar extends ConsumerStatefulWidget {
//   const CDAppBar({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _CDAppBarState();
// }

// class _CDAppBarState extends ConsumerState<CDAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: MediaQuery.of(context).size.height * 0.40,
//       collapsedHeight: 60,
//       title: TextScroll(
//         pauseBetween: const Duration(seconds: 1),
//         velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
//         courseModel.title,
//       ),
//       floating: false,
//       pinned: true,
//       snap: false,
//       actions: [
//         IconButton(
//           onPressed: () {
//             ref.read(mainNotifierProvider.notifier).saveCourse(
//                   courseModel,
//                   courseModel.isFav == 1 ? 0 : 1,
//                   context,
//                   keey: widget.keey,
//                   val: widget.val,
//                 );
//             courseModel = courseModel.copyWith(
//               isFav: courseModel.isFav == 1 ? 0 : 1,
//             );
//             setState(() {});
//           },
//           icon: courseModel.isFav == 1
//               ? const Icon(
//                   Icons.bookmark_rounded,
//                   size: 30,
//                   color: primaryColor,
//                 )
//               : const Icon(
//                   Icons.bookmark_border_outlined,
//                   size: 30,
//                 ),
//         ),
//         IconButton(
//           key: _downloadKey,
//           onPressed: () {
//             ref.read(mainNotifierProvider.notifier).saveCourse(
//                   courseModel.copyWith(
//                     isStarted: 1,
//                   ),
//                   null,
//                   context,
//                   showMsg: false,
//                   keey: widget.keey,
//                   val: widget.val,
//                 );
//             courseModel = courseModel.copyWith(
//               isStarted: 1,
//             );
//             setState(() {});

//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) => DownloadAllFiles(
//                 courseModel: courseModel,
//                 onSingleDownloadDone: (filePath) async {
//                   if (kDebugMode) {
//                     print("Dwonload done $filePath");
//                   }
//                   int index = int.parse(
//                       filePath.replaceAll(".mp3", "").split(" ").last);

//                   playListIndexes.add(index);
//                   playListIndexes.sort((a, b) => a.compareTo(b));
//                   if (mounted) {
//                     ref
//                         .read(loadAudiosProvider.notifier)
//                         .update((state) => playListIndexes.length);
//                   }
//                   print("indexes: ${playListIndexes}");
//                   print("index : $index");
//                   if (isPlayingCourseThisCourse(courseModel.courseId, ref)) {
//                     PlaylistHelper.mainPlayListIndexes = playListIndexes;
//                   }

//                   int insertableIndex = playListIndexes.indexOf(index);

//                   print("inserting at $insertableIndex");
//                   print('playlistNum: ${PlaylistHelper().playList.length}');

//                   final audioSrc = AudioSource.file(
//                     filePath,
//                     tag: MediaItem(
//                       id: audios[index - 1],
//                       title: "${courseModel.title} $index",
//                       artist: courseModel.ustaz,
//                       album: courseModel.category,
//                       artUri: Uri.parse(courseModel.image),
//                       extras: courseModel.toMap(),
//                     ),
//                   );
//                   if (insertableIndex >= PlaylistHelper().playList.length) {
//                     print("adding at $insertableIndex");
//                     if (isPlayingCourseThisCourse(courseModel.courseId, ref)) {
//                       PlaylistHelper().playList.add(audioSrc);
//                       PlaylistHelper.audioPlayer.addAudioSource(audioSrc);
//                     } else {
//                       lst.add(audioSrc);
//                     }
//                   } else {
//                     print("inserting at $insertableIndex");

//                     if (isPlayingCourseThisCourse(courseModel.courseId, ref)) {
//                       PlaylistHelper().playList.insert(
//                             insertableIndex,
//                             audioSrc,
//                           );
//                       PlaylistHelper.audioPlayer.insertAudioSource(
//                         insertableIndex,
//                         audioSrc,
//                       );
//                     } else {
//                       lst.insert(
//                         insertableIndex,
//                         audioSrc,
//                       );
//                     }
//                   }
//                   print("num of index: ${PlaylistHelper().playList.length}");
//                 },
//               ),
//             );
//           },
//           icon: const Icon(Icons.download_rounded),
//         ),
//         IconButton(
//           key: _shareKey,
//           onPressed: () async {
//             final url =
//                 "https://www.ilmfelagi.com/api/course/${courseModel.courseId}";

//             if (url.isNotEmpty) {
//               await SharePlus.instance.share(
//                   ShareParams(text: "ይህንን ደርስ ይመልከቱ \n ${Uri.parse(url)}"));
//             }
//           },
//           icon: const Icon(Icons.share),
//         )
//       ],
//       bottom: PreferredSize(
//         preferredSize: Size(
//           MediaQuery.of(context).size.width,
//           showTopAudio ? 40 : 0,
//         ),
//         child: showTopAudio
//             ? CurrentAudioView(metaData as MediaItem)
//             : const SizedBox(),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         stretchModes: const [StretchMode.zoomBackground],
//         collapseMode: CollapseMode.parallax,
//         centerTitle: true,
//         background: Stack(
//           children: [
//             SizedBox(
//               child: Hero(
//                 tag: courseModel.id!,
//                 child: CachedNetworkImage(
//                   imageUrl: courseModel.image,
//                   height: MediaQuery.of(context).size.height * 0.40,
//                   width: MediaQuery.of(context).size.width,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.40,
//               width: MediaQuery.of(context).size.width,
//               color:
//                   Theme.of(context).chipTheme.backgroundColor!.withOpacity(0.3),
//             ),
//             Positioned(
//               bottom: 8,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     MainBtn(
//                       key: _alarmKey,
//                       title: courseModel.scheduleDates.isNotEmpty
//                           ? "ማስታወሻውን አስተካክል"
//                           : "አስታዋሽ መዝግብ",
//                       icon: courseModel.scheduleDates.isNotEmpty
//                           ? Icons.access_alarms
//                           : Icons.alarm_add_rounded,
//                       onTap: () async {
//                         setState(() {});
//                         if (mounted) {
//                           showDialog(
//                             context: context,
//                             builder: (ctx) => ScheduleView(
//                               courseModel: courseModel,
//                               onSave: (scheduleDates, scheduleTime,
//                                   isScheduleOn) async {
//                                 await ref
//                                     .read(mainNotifierProvider.notifier)
//                                     .saveCourse(
//                                       courseModel.copyWith(
//                                         isStarted: 1,
//                                         scheduleDates: scheduleDates,
//                                         scheduleTime: scheduleTime,
//                                         isScheduleOn: isScheduleOn,
//                                       ),
//                                       null,
//                                       context,
//                                       showMsg: false,
//                                       keey: widget.keey,
//                                       val: widget.val,
//                                     );
//                                 courseModel = courseModel.copyWith(
//                                   isStarted: 1,
//                                   scheduleDates: scheduleDates,
//                                   scheduleTime: scheduleTime,
//                                   isScheduleOn: isScheduleOn,
//                                 );

//                                 if (mounted) {
//                                   final res = await ref
//                                       .read(mainNotifierProvider.notifier)
//                                       .getSingleCourse(
//                                           widget.cm.courseId, context);
//                                   return res?.id;
//                                 }
//                                 return null;
//                               },
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     if (courseModel.isStarted == 1 &&
//                         courseModel.isFinished == 0)
//                       MainBtn(
//                         title: "ካቆምኩበት ቀጥል",
//                         icon: Icons.play_arrow_rounded,
//                         onTap: () async {
//                           // await createPlayList();
//                           if (!playListIndexes
//                               .contains(courseModel.pausedAtAudioNum + 1)) {
//                             if (mounted) {
//                               toast(
//                                 "${courseModel.title} ${courseModel.pausedAtAudioNum + 1} ዳውንሎድ አልተደረገም.",
//                                 ToastType.normal,
//                                 context,
//                               );
//                             }
//                             return;
//                           }

//                           if (!isPlayingCourseThisCourse(
//                               courseModel.courseId, ref)) {
//                             PlaylistHelper().playList.clear();
//                             PlaylistHelper().playList.addAll(lst);
//                             PlaylistHelper.mainPlayListIndexes =
//                                 playListIndexes;
//                           }
//                           if (PlaylistHelper().playList.isNotEmpty) {
//                             int playableIndex = PlaylistHelper
//                                 .mainPlayListIndexes
//                                 .indexOf(courseModel.pausedAtAudioNum + 1);
//                             print("playListIndexes: $playListIndexes");
//                             print("playingIndex: $playableIndex");
//                             await PlaylistHelper.audioPlayer.setAudioSources(
//                               PlaylistHelper().playList,
//                               initialIndex: courseModel.pausedAtAudioNum < 0
//                                   ? 0
//                                   : playableIndex,
//                               initialPosition: Duration(
//                                 seconds: courseModel.pausedAtAudioSec,
//                               ),
//                               preload: false,
//                             );
//                             PlaylistHelper.audioPlayer.play();

//                             if (mounted) {
//                               bool isPDFDownloded = await ref
//                                   .read(cdNotifierProvider.notifier)
//                                   .isDownloaded(
//                                     courseModel.pdfId.contains(",")
//                                         ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
//                                         : "${courseModel.title}.pdf",
//                                     "PDF",
//                                     context,
//                                   );
//                               print("isPDFDownloded:- $isPDFDownloded");
//                               print(courseModel.pdfId.contains(",")
//                                   ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
//                                   : "${courseModel.title}.pdf");
//                               if (courseModel.pdfId.trim().isNotEmpty &&
//                                   isPDFDownloded) {
//                                 String path = await getPath(
//                                   'PDF',
//                                   courseModel.pdfId.contains(",")
//                                       ? "${courseModel.title} ${courseModel.pdfNum.toInt()}.pdf"
//                                       : "${courseModel.title}.pdf",
//                                 );
//                                 if (mounted) {
//                                   await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => PdfPage(
//                                         volume: courseModel.pdfNum,
//                                         path: path,
//                                         courseModel: courseModel,
//                                       ),
//                                     ),
//                                   );
//                                   refresh();
//                                 }
//                               }
//                             }
//                           }
//                         },
//                       ),
//                     if (courseModel.isFinished == 1)
//                       MainBtn(
//                         title: "ደጋሚ ጀምር",
//                         icon: Icons.refresh,
//                         onTap: () {
//                           ref.read(mainNotifierProvider.notifier).saveCourse(
//                                 courseModel.copyWith(
//                                   isFinished: 0,
//                                   pdfPage: 0,
//                                   pausedAtAudioNum: 0,
//                                   pausedAtAudioSec: 0,
//                                   lastViewed: DateTime.now().toString(),
//                                 ),
//                                 null,
//                                 context,
//                                 showMsg: false,
//                                 keey: widget.keey,
//                                 val: widget.val,
//                               );
//                           courseModel = courseModel.copyWith(
//                             isFinished: 0,
//                             pdfPage: 0,
//                             pausedAtAudioNum: 0,
//                             pausedAtAudioSec: 0,
//                           );
//                           setState(() {});
//                           // createPlayList();
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
  
//   }
// }
