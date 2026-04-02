// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:islamic_online_learning/core/constants.dart';
// import 'package:islamic_online_learning/core/lib/api_handler.dart';
// import 'package:islamic_online_learning/core/lib/pref_consts.dart';
// import 'package:islamic_online_learning/features/Questionaire/model/questionnaire.dart';
// import 'package:islamic_online_learning/features/Questionaire/view/pages/questionnaire_screen.dart';
// import 'package:islamic_online_learning/features/auth/model/city.dart';
// import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';
// // import 'package:islamic_online_learning/features/auth/model/subscription.dart';
// // import 'package:islamic_online_learning/features/auth/model/user.dart';
// import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
// import 'package:islamic_online_learning/features/auth/view/controller/auth_state.dart';
// import 'package:islamic_online_learning/features/auth/view/pages/register_page.dart';
// import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_state.dart';
// import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
// import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
// import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthNotifier extends StateNotifier<AuthState> {
//   final AuthService authService;
//   final Ref ref;
//   AuthNotifier(this.authService, this.ref) : super(AuthState());

//   Future<void> getMyInfo(BuildContext context) async {
//     try {
//       state = state.copyWith(isLoading: true);
//       final user = await authService.getMyInfo();
//       final pref = await ref.read(sharedPrefProvider);
//       await pref.setString(PrefConsts.userId, user.id);
//       FirebaseMessaging.instance.subscribeToTopic(user.id);
//       await getScores(context);
//       _checkIfTheCourseStarted(context);
//       checkQuestionnaireAndDisplay(context);
//       showScoringRulesDialog(context);
//       state = state.copyWith(isLoading: false, user: user);
//     } on ConnectivityException catch (err) {
//       state = state.copyWith(isLoading: false, error: err.toString());
//       // toast(err.message, ToastType.error, context);
//     } catch (err) {
//       // toast("የእርስዎን መለያ ማግኘት አልተቻለም።", ToastType.error, context);
//       handleError(
//         err.toString(),
//         context,
//         ref,
//         () async {
//           print("Error: $err");
//           final token = await getAccessToken();
//           state = state.copyWith(
//             isLoading: false,
//             error: getErrorMsg(err.toString(), "የእርስዎን መለያ ማግኘት አልተቻለም።"),
//             tokenIsNull: token == null,
//           );
//         },
//       );
//     }
//   }

//   Future<void> checkQuestionnaireAndDisplay(BuildContext context) async {
//     final List<Questionnaire> questionnaires =
//         await authService.getActiveQuestionnaire();

//     if (questionnaires.isNotEmpty) {
//       final bool? accepted = await showSurveyPermissionDialog(context);
//       if (accepted == true) {
//         final questions =
//             questionnaires.map((e) => e.questions).expand((i) => i).toList();
//         if (context.mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => QuestionnaireScreen(
//                 questions: questions,
//               ),
//             ),
//           );
//         }
//       }
//     }
//   }

//   Future<bool?> showSurveyPermissionDialog(BuildContext context) {
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: false, // user must explicitly choose
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.feedback_rounded,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               const SizedBox(width: 8),
//               Expanded(child: const Text('የዳሰሳ ጥናት')),
//             ],
//           ),
//           content: const Text(
//             'የእርስዎ ልምድ ለእኛ አስፈላጊ ነው።\n\n'
//             'አገልግሎታችንን ለማሻሻል እንዲረዳን አጭር የዳሰሳ ጥናት ለማድረግ ፈቃደኛ ይሆናሉ? '
//             'ጥቂት ደቂቃዎችን ብቻ ነው የሚወስደው፣ እና የእርስዎ ምላሾች ሚስጥራዊ ሆነው ይቆያሉ።',
//           ),
//           actionsPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('ሌላ ጊዜ'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: whiteColor,
//               ),
//               child: const Text('እሺ, ለማገዝ እፈልጋለሁ'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> updateMyInfo(
//     BuildContext context,
//     String name,
//   ) async {
//     try {
//       state = state.copyWith(isUpdating: true);
//       final user = await authService.updateMyInfo(name);
//       // await getScores(context);
//       // await _checkIfTheCourseStarted(context);
//       state = state.copyWith(isUpdating: false, user: user);
//       Navigator.pop(context);
//     } on ConnectivityException catch (err) {
//       state = state.copyWith(isUpdating: false, error: err.toString());
//       // toast(err.message, ToastType.error, context);
//     } catch (err) {
//       // toast("የእርስዎን መለያ ማግኘት አልተቻለም።", ToastType.error, context);
//       handleError(
//         err.toString(),
//         context,
//         ref,
//         () async {
//           print("Error: $err");
//           final token = await getAccessToken();
//           toast(
//             getErrorMsg(err.toString(), "መለያዎን ማደስ አልተቻለም!"),
//             ToastType.error,
//             context,
//           );
//           state = state.copyWith(
//             isUpdating: false,
//             // error: getErrorMsg(err.toString(), "የእርስዎን መለያ ማግኘት አልተቻለም።"),
//             tokenIsNull: token == null,
//           );
//         },
//       );
//     }
//   }

//   Future<void> getScores(BuildContext context) async {
//     final scores = await authService.getScores();
//     state = state.copyWith(scores: scores);
//   }

//   void setCourseRelatedData(CourseRelatedData data) async {
//     // print("Setting course related data: $data");
//     state = state.copyWith(courseRelatedData: data);
//   }

//   Future<bool?> hasCourseStarted() async {
//     // try {
//     final yes = await authService.hasCourseStarted();
//     return yes;
//     // } catch (err) {
//     //   print("Could not get course data");
//     //   print("err: ${err.toString()}");
//     //   throw Exception("Could not get course data");
//     // }
//   }

//   Future<void> logout() async {
//     await deleteTokens();
//     // await AuthService.googleSignIn.signOut();
//     ref.read(curriculumNotifierProvider.notifier).getCurriculums();
//     final pref = await ref.read(sharedPrefProvider);
//     final userId = pref.getString(PrefConsts.userId);
//     state = AuthState();
//     if (userId != null) {
//       FirebaseMessaging.instance.unsubscribeFromTopic(userId);
//       await pref.remove(PrefConsts.userId);
//       await ref.read(bootstrapCacheProvider).clear();
//     }

//     setUserNull();
//     ref.read(assignedCoursesNotifierProvider.notifier).state =
//         AssignedCoursesState();
//   }

//   void setIsDue(bool val) {
//     state = state.copyWith(isDue: val);
//   }

//   // void setSubscription(Subscription subscription) async {
//   //   state =
//   //       state.copyWith(user: state.user?.copyWith(subscription: subscription));
//   // }

//   void setUserNull() {
//     state = state.copyWith(user: null, tokenIsNull: true);
//   }

//   Future<bool> _checkIfTheCourseStarted(BuildContext context) async {
//     // getMyInfo(ref.context);
//     try {
//       state = state.copyWith(courseStarted: CourseStarted.LOADING);
//       final started = await hasCourseStarted();
//       if (started == true) {
//         state = state.copyWith(courseStarted: CourseStarted.STARTED);
//         ref
//             .read(assignedCoursesNotifierProvider.notifier)
//             .getCurriculum(context);
//         return true;
//       } else {
//         state = state.copyWith(courseStarted: CourseStarted.NOTSTARTED);
//         return false;
//       }
//     } catch (err) {
//       state = state.copyWith(courseStarted: CourseStarted.NOTSTARTED);
//       return false;
//     }
//   }

//   Future<List<DateTime>> getStreakFor(
//       int year, int month, BuildContext context) async {
//     try {
//       final streaks = await authService.getStreakFor(month, year);
//       return streaks;
//     } catch (err) {
//       handleError(err.toString(), context, ref, () {
//         toast(getErrorMsg(err.toString(), "ማግኘት አልተቻለም!"), ToastType.error,
//             context);
//       });
//       return [];
//     }
//   }

//   void setCourseStarted(CourseStarted v) {
//     state = state.copyWith(courseStarted: v);
//   }

//   void unfinishedRegistration(
//     String otpId,
//     BuildContext context,
//   ) {
//     if (context.mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (_) => RegisterPage(
//             otpId: otpId,
//           ),
//         ),
//         (v) => false,
//       );
//     }
//   }

//   Future<int?> getUsersStreakNum() async {
//     try {
//       final streakNum = await authService.getUsersStreakNum();
//       state =
//           state.copyWith(user: state.user?.copyWith(numOfStreaks: streakNum));
//       return streakNum;
//     } catch (err) {
//       print("Error getting streak num: $err");
//       return 0;
//     }
//   }

//   Future<List<City>> searchCities(String q, BuildContext context) async {
//     try {
//       return await authService.searchCities(q);
//     } catch (err) {
//       print(err);
//       toast("Error happened. please try again!:$err", ToastType.error, context);
//       return [];
//     }
//   }

//   Future<void> showScoringRulesDialog(BuildContext context,
//       {bool byForce = false}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final accepted = prefs.getBool(PrefConsts.scoringRulesAcceptedKey) ?? false;
//     if (accepted && !byForce) return;
//     return showDialog(
//       context: context,
//       barrierDismissible: false, // user must acknowledge
//       builder: (context) {
//         return AlertDialog(
//           title: const Text(
//             'የእርስዎ ነጥብ እንዴት እንደሚሰላ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ...state.scores?.map((score) {
//                       final attendancePoints = score.scoreSegments.where(
//                         (segment) => segment.name == "attendance",
//                       );
//                       final quizPoints = score.scoreSegments.where(
//                         (segment) => segment.name == "quiz",
//                       );
//                       final shortAnswerPoints = score.scoreSegments.where(
//                         (segment) => segment.name == "assignment",
//                       );
//                       final hasSegments = attendancePoints.isNotEmpty ||
//                           quizPoints.isNotEmpty ||
//                           shortAnswerPoints.isNotEmpty;
//                       final isDiscussion = score.type == "Discussion";
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           _SectionTitle(getScoreTitle(score.type)),
//                           if (attendancePoints.isNotEmpty)
//                             Text(
//                                 '• ${attendancePoints.first.score} ነጥብ በ${isDiscussion ? "ሳምንታዊ ጥያቄዎች" : "ትምህርቱ"} ላይ ለመሳተፍዎ'),
//                           if (quizPoints.isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     '• እስከ ${quizPoints.first.score} ነጥብ ${isDiscussion ? "በሳምንቱ ውስጥ ለሳቱት ጥያቄዎች" : "ትምህርቱ ሲያልቅ ያሉ ጥያቄዎች"}'),
//                                 Text(
//                                     '• የጥያቄዎቹ ነጥብ = (ትክክለኛው ጥያቄ ÷ ድምር) × ${quizPoints.first.score}'),
//                               ],
//                             ),

//                           if (shortAnswerPoints.isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     '• እስከ ${shortAnswerPoints.first.score} ነጥብ ለደረቅ ጥያቄዎች'),
//                                 Text(
//                                     '• የደረቅ ጥያቄ ነጥብ = (ትክክለኛው ጥያቄ ÷ ድምር) × ${shortAnswerPoints.first.score}'),
//                               ],
//                             ),
//                           if (hasSegments)
//                             Text("• የአጠቃላይ ነጥብ = ${score.totalScore} ነጥብ"),
//                           if (!hasSegments)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text("• እስከ ${score.totalScore} ነጥብ ለወርሃዊ ፈተና"),
//                                 Text('• በአብዛኛው 16 ጥያቄዎች'),
//                                 Text('• የመጨረሻ ፈተና እስከ 30 ጥያቄዎች'),
//                                 Text(
//                                     '• ፈተና ነጥብ = (ትክክለኛው ጥያቄ ÷ ድምር) × ${score.totalScore}'),
//                               ],
//                             ),
//                           // Text('  Rounded to the nearest whole number'),
//                           SizedBox(height: 10),
//                         ],
//                       );
//                     }) ??
//                     [],
//                 // _SectionTitle('📆 Friday – Sunday (Weekly Score)'),
//                 // Text('• 5 points for attending the weekly session'),
//                 // Text('• 5 points for answering missed questions'),
//                 // Text('• Up to 10 points for short-answer questions'),
//                 // SizedBox(height: 12),
//                 // _SectionTitle('🗓 Monthly Score (After 4 Weeks)'),
//                 // Text('• Up to 40 points from the monthly exam'),
//                 // Text('• Usually 16 questions'),
//                 // Text('• Final exam may have up to 30 questions'),
//                 // SizedBox(height: 12),
//                 Text(
//                   'ማሳሳብያ፡ ሙሉ ደርሱን ሲጨርሱ ከግማሽ በታች ካመጡ ደርሱን ድጋሚ ለመማር ይገደዳሉ!',
//                   style: TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),
//                 Divider(),
//                 Text(
//                   '• ምንም የተደበቁ ቅጣቶች የሉም።\n'
//                   '• ደንቦች ቋሚ እና ለሁሉም ተጠቃሚዎች የሚታዩ ናቸው።',
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 await prefs.setBool(PrefConsts.scoringRulesAcceptedKey, true);
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: whiteColor,
//               ),
//               child: const Text('ተረድቻለሁ!'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String getScoreTitle(String type) {
//     switch (type) {
//       case "Lesson":
//         return '📆 ከሰኞ - ሃሙስ (የቀኑ ነጥብ)';
//       case "Discussion":
//         return "📆 አርብ - እሁድ (ሳምንታዊ ነጥብ)";
//       case "IndividualAssignment":
//         return "🗓 ወርሃዊ ነጥብ (ከ4 ሳምንት በኋላ)";
//       default:
//         return "";
//     }
//   }

//   Future<void> deleteProfile(BuildContext context) async {
//     try {
//       if (state.isDeleting) return;
//       state = state.copyWith(isDeleting: true);
//       await authService.deleteMyProfile();
//       ref.read(menuIndexProvider.notifier).update((state) => 0);
//       logout();
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const MainPage(),
//         ),
//         (v) => false,
//       );
//       state = state.copyWith(isDeleting: false);
//     } catch (err) {
//       print("Error deleting profile: $err");
//       toast("Error deleting profile: $err", ToastType.error, context);
//       state = state.copyWith(isDeleting: false);
//     }
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String text;

//   const _SectionTitle(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }
