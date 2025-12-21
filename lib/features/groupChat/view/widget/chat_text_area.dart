import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/provider.dart';
import 'package:islamic_online_learning/features/groupChat/view/widget/reply_chat_card.dart';

class ChatTextArea extends ConsumerStatefulWidget {
  final Future<bool> Function(String val) onSend;
  final String? replyToId;
  final VoidCallback onRemove;

  const ChatTextArea({
    super.key,
    this.replyToId,
    required this.onRemove,
    required this.onSend,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatTextAreaState();
}

class _ChatTextAreaState extends ConsumerState<ChatTextArea> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupChatNotifierProvider);
    final replyChat = widget.replyToId == null
        ? null
        : state.groupChats.where((e) => e.id == widget.replyToId).first;
    return Container(
      width: double.infinity,
      height: replyChat != null ? 62 + 48 : 62,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: replyChat != null
            ? BorderRadius.circular(15)
            : BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(40),
            blurRadius: 8,
            spreadRadius: 4,
            // offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (replyChat != null)
            ReplyChatCard(
              chat: replyChat,
              onRemove: widget.onRemove,
            ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hint: Text("Message..."),
                  ),
                ),
              ),
              // state.chatAdding
              //     ? CircularProgressIndicator()
              //     :
              IconButton(
                onPressed: () async {
                  if (state.chatAdding) return;
                  if (_controller.text.trim().isNotEmpty) {
                    final v = await widget.onSend(_controller.text.trim());
                    if (v) {
                      _controller.text = "";
                      widget.onRemove();
                    }
                  }
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: state.chatAdding ? Colors.grey : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
