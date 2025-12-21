import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';

class ReplyChatCard extends ConsumerStatefulWidget {
  final Chat chat;
  final VoidCallback onRemove;
  const ReplyChatCard({super.key, required this.chat, required this.onRemove});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReplyChatCardState();
}

class _ReplyChatCardState extends ConsumerState<ReplyChatCard> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authNotifierProvider);
    final name = widget.chat.senderId == null
        ? "Admin"
        : authState.user!.group.members!
            .where((e) => e.id == widget.chat.senderId)
            .first
            .name;
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Icon(
          Icons.reply_rounded,
          color: primaryColor,
          size: 35,
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reply to $name",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.chat.message,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
        IconButton(
          onPressed: () {
            widget.onRemove();
          },
          icon: Icon(Icons.close),
        )
      ],
    );
  }
}
