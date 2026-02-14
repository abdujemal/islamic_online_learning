import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/the_end.dart';
import 'package:islamic_online_learning/features/notifications/view/controller/provider.dart';
import 'package:islamic_online_learning/features/notifications/view/widget/notification_card.dart';
import 'package:islamic_online_learning/features/notifications/view/widget/notification_card_shimmer.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(notificationNotifierProvider.notifier)
          .setUnreadNotifications(0, read: true);
      ref.read(notificationNotifierProvider.notifier).getNotifications(context);

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          loadMore();
        }
      });
    });
  }

  Future loadMore() async {
    ref
        .read(notificationNotifierProvider.notifier)
        .getNotifications(context, loadMore: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.read(authNotifierProvider);
    // final today = DateTime.parse(DateTime.now().toString().split(" ")[0]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: SafeArea(
        child: ref.watch(notificationNotifierProvider).map(
              loading: (_) => ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return NotificationCardShimmer();
                },
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  ref
                      .read(notificationNotifierProvider.notifier)
                      .setUnreadNotifications(0, read: true);
                  ref
                      .read(notificationNotifierProvider.notifier)
                      .getNotifications(context);
                },
                child: ListView.builder(
                  // reverse: true,
                  controller: _scrollController,
                  itemCount: _.notifications.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _.notifications.length) {
                      return _.isLoadingMore
                          ? NotificationCardShimmer()
                          : _.hasNoMore
                              ? TheEnd()
                              : SizedBox();
                    }
                    return NotificationCard(
                      title: _.notifications[index].title,
                      body: _.notifications[index].message,
                      time: _.notifications[index].sentAt,
                    );
                    // final notification = _.notifications[index];
                    // final name = chat.senderId == null
                    //     ? "Admin"
                    //     : authState.user!.group.members!
                    //         .where((e) => e.id == chat.senderId)
                    //         .first
                    //         .name;

                    // final chatDate = DateTime.parse(
                    //     chat.createdAt.toString().split(" ")[0]);
                    // final dateBefore = index < _.groupChats.length - 1
                    //     ? DateTime.parse(_.groupChats[index + 1].createdAt
                    //         .toString()
                    //         .split(" ")[0])
                    //     : DateTime(1999);
                    // final showDate = chatDate != dateBefore;
                    // final isToday = chatDate.compareTo(today) == 0;
                    // final isYesterday =
                    //     chatDate.difference(today).inDays == -1;
                    // final isThisYear = chatDate.year == today.year;
                    // final displayingDate = isToday
                    //     ? "Today"
                    //     : isYesterday
                    //         ? "Yesterday"
                    //         : isThisYear
                    //             ? DateFormat("MMMM dd").format(chatDate)
                    //             : DateFormat("dd/MM/yy").format(chatDate);
                    // return Column(
                    //   children: [
                    //     if (showDate) Chip(label: Text(displayingDate)),
                    //     ChatCard(
                    //       senderName: name,
                    //       isAdmin: chat.senderId == null,
                    //       isViewed: chat.viewedBy.isNotEmpty,
                    //       message: chat.message,
                    //       time: chat.createdAt,
                    //       isMine: authState.user!.id == chat.senderId,
                    //       replyTo: chat.replyTo,
                    //       members: authState.user!.group.members!,
                    //       onView: () {
                    //         if (authState.user!.id == chat.senderId) {
                    //         } else if (chat.viewedBy
                    //             .contains(chat.senderId)) {
                    //         } else {
                    //           socketService.readChat(
                    //               chat.groupId!, authState.user!.id, chat.id);
                    //         }
                    //       },
                    //       onEdit: () {
                    //         _chatTc.text = chat.message;
                    //         setState(() {
                    //           editId = chat.id;
                    //           replyToId = null;
                    //         });
                    //       },
                    //       onReply: () {
                    //         setState(() {
                    //           replyToId = chat.id;
                    //           editId = null;
                    //         });
                    //       },
                    //       onDelete: () {
                    //         ref
                    //             .read(groupChatNotifierProvider.notifier)
                    //             .deleteGroupChat(chat.id, context, (chat) {
                    //           ref
                    //               .read(groupChatNotifierProvider.notifier)
                    //               .deleteChatFromTheList(chat);
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // );
                  },
                ),
              ),
              empty: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("ምንም የለም"),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(notificationNotifierProvider.notifier)
                            .getNotifications(context);
                      },
                      icon: Icon(
                        Icons.refresh,
                      ),
                    )
                  ],
                ),
              ),
              error: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _.error ?? "_",
                      style: TextStyle(color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(notificationNotifierProvider.notifier)
                            .getNotifications(context);
                      },
                      icon: Icon(
                        Icons.refresh,
                      ),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
