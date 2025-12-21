import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/provider.dart';
import 'package:islamic_online_learning/features/groupChat/view/widget/chat_card.dart';
import 'package:islamic_online_learning/features/groupChat/view/widget/chat_card_shimmer.dart';
import 'package:islamic_online_learning/features/groupChat/view/widget/chat_text_area.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/the_end.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  const GroupChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends ConsumerState<GroupChatPage> {
  final ScrollController _scrollController = ScrollController();
  String? replyToId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(groupChatNotifierProvider.notifier)
          .getGroupChat(context)
          .then((v) {
        // Future.delayed(Duration(milliseconds: 500), () {
        //   _scrollController.animateTo(
        //     _scrollController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 500),
        //     curve: Curves.easeInOut,
        //   );
        // });
      });
      // Future.delayed(Duration(seconds: 1), () {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          loadMore();
        }
      });
      // });
    });
  }

  Future loadMore() async {
    ref
        .read(groupChatNotifierProvider.notifier)
        .getGroupChat(context, loadMore: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authNotifierProvider);
    final today = DateTime.parse(DateTime.now().toString().split(" ")[0]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ref.watch(groupChatNotifierProvider).map(
                  loading: (_) => ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ChatCardShimmer(
                        isMine: index % 2 == 0,
                      );
                    },
                  ),
                  loaded: (_) => ListView.builder(
                    padding: EdgeInsets.only(bottom: replyToId != null ? 77 + 48 : 77),
                    reverse: true,
                    controller: _scrollController,
                    itemCount: _.groupChats.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _.groupChats.length) {
                        return _.isLoadingMore
                            ? ChatCardShimmer()
                            : _.hasNoMore
                                ? TheEnd()
                                : SizedBox();
                      }
                      final chat = _.groupChats[index];
                      final name = chat.senderId == null
                          ? "Admin"
                          : authState.user!.group.members!
                              .where((e) => e.id == chat.senderId)
                              .first
                              .name;

                      final chatDate = DateTime.parse(
                          chat.createdAt.toString().split(" ")[0]);
                      final dateBefore = index < _.groupChats.length - 1
                          ? DateTime.parse(_.groupChats[index + 1].createdAt
                              .toString()
                              .split(" ")[0])
                          : DateTime(1999);
                      final showDate = chatDate != dateBefore;
                      final isToday = chatDate.compareTo(today) == 0;
                      final isYesterday =
                          chatDate.difference(today).inDays == -1;
                      final displayingDate = isToday
                          ? "Today"
                          : isYesterday
                              ? "Yesterday"
                              : DateFormat("dd/MM/yy").format(chatDate);
                      return Column(
                        children: [
                          if (showDate) Chip(label: Text(displayingDate)),
                          ChatCard(
                            senderName: name,
                            isAdmin: chat.senderId == null,
                            message: chat.message,
                            time: chat.createdAt,
                            isMine: authState.user!.id == chat.senderId,
                            replyTo: chat.replyTo,
                            members: authState.user!.group.members!,
                            onReply: () {
                              setState(() {
                                replyToId = chat.id;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  empty: (_) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No data"),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(groupChatNotifierProvider.notifier)
                                .getGroupChat(context);
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
                                .read(groupChatNotifierProvider.notifier)
                                .getGroupChat(context);
                          },
                          icon: Icon(
                            Icons.refresh,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatTextArea(
                replyToId: replyToId,
                onRemove: () {
                  setState(() {
                    replyToId = null;
                  });
                },
                onSend: (val) async {
                  return await ref
                      .read(groupChatNotifierProvider.notifier)
                      .sendGroupChat(
                        val,
                        replyToId,
                        context,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
