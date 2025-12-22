import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';

class EditChatCard extends ConsumerStatefulWidget {
  final Chat chat;
  final VoidCallback onRemove;
  const EditChatCard({super.key, required this.chat, required this.onRemove});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditChatCardState();
}

class _EditChatCardState extends ConsumerState<EditChatCard> {
  @override
  Widget build(BuildContext context) {
   
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Icon(
          Icons.edit,
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
                "Editing...",
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
