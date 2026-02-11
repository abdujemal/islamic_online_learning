// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
// import 'package:islamic_online_learning/features/groupChat/model/chat.dart';
// import 'package:islamic_online_learning/features/groupChat/service/socket_service.dart';
// import 'package:islamic_online_learning/features/groupChat/view/controller/provider.dart';
// import 'package:islamic_online_learning/features/groupChat/view/widget/chat_card.dart';
// import 'package:islamic_online_learning/features/groupChat/view/widget/chat_card_shimmer.dart';
// import 'package:islamic_online_learning/features/groupChat/view/widget/chat_text_area.dart';
// import 'package:islamic_online_learning/features/main/presentation/widgets/the_end.dart';

// class GroupChatPage extends ConsumerStatefulWidget {
//   const GroupChatPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _GroupChatPageState();
// }

// class _GroupChatPageState extends ConsumerState<GroupChatPage> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _chatTc = TextEditingController();
//   String? replyToId;
//   String? editId;

//   final SocketService socketService = SocketService();

//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() {
//       ref.read(groupChatNotifierProvider.notifier).setUnreadChats(0);
//       ref.read(groupChatNotifierProvider.notifier).getGroupChat(context);
//       initSocket();

//       _scrollController.addListener(() {
//         if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200) {
//           loadMore();
//         }
//       });
//     });
//   }

//   void initSocket() {
//     final authState = ref.read(authNotifierProvider);

//     socketService.connect();

//     socketService.joinChat(authState.user!.group.id);

//     socketService.onNewMessage((msg) {
//       final chat = Chat.fromMap(msg);
//       final authState = ref.read(authNotifierProvider);
//       ref.read(groupChatNotifierProvider.notifier).addNewChatToTheList(chat);
//       if (chat.senderId == authState.user!.id) {
//         socketService.readChat(
//           chat.groupId!,
//           chat.senderId!,
//           chat.id,
//         );
//       }
//     });

//     socketService.onEditMessage((msg) {
//       ref
//           .read(groupChatNotifierProvider.notifier)
//           .editChatFromTheList(Chat.fromMap(msg));
//     });

//     socketService.onChatRead((data) {
//       ref.read(groupChatNotifierProvider.notifier).editChatViewFromTheList(
//             data["groupId"],
//             data["userId"],
//             data["chatId"],
//           );
//     });

//     socketService.onDeleteMessage((msg) {
//       ref
//           .read(groupChatNotifierProvider.notifier)
//           .deleteChatFromTheList(Chat.fromMap(msg));
//     });
//   }

//   Future loadMore() async {
//     ref
//         .read(groupChatNotifierProvider.notifier)
//         .getGroupChat(context, loadMore: true);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _chatTc.dispose();
//     socketService.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.read(authNotifierProvider);
//     final today = DateTime.parse(DateTime.now().toString().split(" ")[0]);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Group Chat"),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             ref.watch(groupChatNotifierProvider).map(
//                   loading: (_) => ListView.builder(
//                     itemCount: 20,
//                     itemBuilder: (context, index) {
//                       return ChatCardShimmer(
//                         isMine: index % 2 == 0,
//                       );
//                     },
//                   ),
//                   loaded: (_) => ListView.builder(
//                     padding: EdgeInsets.only(
//                         bottom:
//                             replyToId != null || editId != null ? 77 + 48 : 77),
//                     reverse: true,
//                     controller: _scrollController,
//                     itemCount: _.groupChats.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index == _.groupChats.length) {
//                         return _.isLoadingMore
//                             ? ChatCardShimmer()
//                             : _.hasNoMore
//                                 ? TheEnd()
//                                 : SizedBox();
//                       }
//                       final chat = _.groupChats[index];
//                       final name = chat.senderId == null
//                           ? "Admin"
//                           : authState.user!.group.members!
//                               .where((e) => e.id == chat.senderId)
//                               .first
//                               .name;

//                       final chatDate = DateTime.parse(
//                           chat.createdAt.toString().split(" ")[0]);
//                       final dateBefore = index < _.groupChats.length - 1
//                           ? DateTime.parse(_.groupChats[index + 1].createdAt
//                               .toString()
//                               .split(" ")[0])
//                           : DateTime(1999);
//                       final showDate = chatDate != dateBefore;
//                       final isToday = chatDate.compareTo(today) == 0;
//                       final isYesterday =
//                           chatDate.difference(today).inDays == -1;
//                       final isThisYear = chatDate.year == today.year;
//                       final displayingDate = isToday
//                           ? "Today"
//                           : isYesterday
//                               ? "Yesterday"
//                               : isThisYear
//                                   ? DateFormat("MMMM dd").format(chatDate)
//                                   : DateFormat("dd/MM/yy").format(chatDate);
//                       return Column(
//                         children: [
//                           if (showDate) Chip(label: Text(displayingDate)),
//                           ChatCard(
//                             senderName: name,
//                             isAdmin: chat.senderId == null,
//                             isViewed: chat.viewedBy.isNotEmpty,
//                             message: chat.message,
//                             time: chat.createdAt,
//                             isMine: authState.user!.id == chat.senderId,
//                             replyTo: chat.replyTo,
//                             members: authState.user!.group.members!,
//                             onView: () {
//                               if (authState.user!.id == chat.senderId) {
//                               } else if (chat.viewedBy
//                                   .contains(chat.senderId)) {
//                               } else {
//                                 socketService.readChat(
//                                     chat.groupId!, authState.user!.id, chat.id);
//                               }
//                             },
//                             onEdit: () {
//                               _chatTc.text = chat.message;
//                               setState(() {
//                                 editId = chat.id;
//                                 replyToId = null;
//                               });
//                             },
//                             onReply: () {
//                               setState(() {
//                                 replyToId = chat.id;
//                                 editId = null;
//                               });
//                             },
//                             onDelete: () {
//                               ref
//                                   .read(groupChatNotifierProvider.notifier)
//                                   .deleteGroupChat(chat.id, context, (chat) {
//                                 ref
//                                     .read(groupChatNotifierProvider.notifier)
//                                     .deleteChatFromTheList(chat);
//                               });
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   empty: (_) => Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text("No data"),
//                         IconButton(
//                           onPressed: () {
//                             ref
//                                 .read(groupChatNotifierProvider.notifier)
//                                 .getGroupChat(context);
//                           },
//                           icon: Icon(
//                             Icons.refresh,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   error: (_) => Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           _.error ?? "_",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             ref
//                                 .read(groupChatNotifierProvider.notifier)
//                                 .getGroupChat(context);
//                           },
//                           icon: Icon(
//                             Icons.refresh,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: ChatTextArea(
//                 controller: _chatTc,
//                 replyToId: replyToId,
//                 editId: editId,
//                 onRemove: () {
//                   if (editId != null) {
//                     _chatTc.text = "";
//                   }
//                   setState(() {
//                     replyToId = null;
//                     editId = null;
//                   });
//                 },
//                 onSend: (val) async {
//                   if (editId != null) {
//                     return await ref
//                         .read(groupChatNotifierProvider.notifier)
//                         .editGroupChat(val, editId!, context, (chat) {
//                       socketService.editMessage(chat.toMap());
//                     });
//                   } else {
//                     return await ref
//                         .read(groupChatNotifierProvider.notifier)
//                         .sendGroupChat(val, replyToId, context, (chat) {
//                       socketService.sendMessage(chat.toMap());
//                     });
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
