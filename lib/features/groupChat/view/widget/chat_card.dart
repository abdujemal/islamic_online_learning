import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/group.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';
import 'package:islamic_online_learning/utils.dart';

class ChatCard extends StatefulWidget {
  final String senderName;
  final String message;
  final Chat? replyTo;
  final DateTime time;
  final bool isMine;
  final bool isAdmin;
  final bool isViewed;
  final String? avatarUrl;
  final VoidCallback onReply;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;
  final List<Member> members;

  const ChatCard({
    super.key,
    required this.senderName,
    required this.message,
    required this.time,
    required this.replyTo,
    this.isMine = false,
    this.isAdmin = false,
    required this.onEdit,
    required this.onReply,
    required this.onDelete,
    required this.onView,
    required this.members,
    required this.isViewed,
    this.avatarUrl,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  void initState() {
    super.initState();
    widget.onView();
  }

  void _showOptionMenu(BuildContext context, Offset position) async {
    final selected = await showMenu<String>(
      context: context,
      color: Theme.of(context).cardColor,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, 0),
      items: [
        "Reply",
        if (widget.isMine) ...[
          "Edit",
          "Delete",
        ],
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

    if (selected == "Edit") {
      widget.onEdit();
    } else if (selected == "Reply") {
      widget.onReply();
    } else if (selected == "Delete") {
      widget.onDelete();
    } else {
      print("non");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = widget.isMine
        ? theme.colorScheme.primary.withOpacity(0.15)
        : theme.cardColor;

    final replyName = widget.replyTo?.senderId == null
        ? "Admin"
        : widget.members
            .where((e) => e.id == widget.replyTo!.senderId)
            .first
            .name;

    final border = RoundedRectangleBorder(
      side: widget.isAdmin ? BorderSide(color: primaryColor) : BorderSide.none,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: widget.isMine
            ? const Radius.circular(18)
            : const Radius.circular(4),
        bottomRight: widget.isMine
            ? const Radius.circular(4)
            : const Radius.circular(18),
      ),
    );

    return GestureDetector(
      onTapDown: (td) {
        final x = td.globalPosition.dx;
        // -50;
        final y = td.globalPosition.dy;
        // -330;
        _showOptionMenu(context, Offset(x, y));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!widget.isMine)
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: userIdToColor(widget.senderName),
                  child: Text(
                    widget.senderName[0].toUpperCase(),
                    style: const TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      // fontSize: 25,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: ShapeDecoration(
                  color: bg,
                  shape: border,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: widget.isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (widget.replyTo != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withAlpha(100),
                          borderRadius: BorderRadius.circular(5),
                          border: Border(
                            left: BorderSide(
                              color: whiteColor,
                              width: 4,
                            ),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              replyName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.replyTo!.message,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    if (!widget.isMine)
                      Row(
                        children: [
                          if (widget.isAdmin)
                            Icon(
                              Icons.security_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          Text(
                            widget.senderName,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    if (!widget.isMine) const SizedBox(height: 4),
                    Text(
                      widget.message,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat("h:mm a").format(widget.time),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.hintColor,
                            fontSize: 11,
                          ),
                        ),
                        if (widget.isMine)
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              widget.isViewed ? Icons.done_all : Icons.done,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
