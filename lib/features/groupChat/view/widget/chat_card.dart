import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/group.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';
import 'package:islamic_online_learning/utils.dart';

class ChatCard extends StatelessWidget {
  final String senderName;
  final String message;
  final Chat? replyTo;
  final DateTime time;
  final bool isMine;
  final bool isAdmin;
  final String? avatarUrl;
  final VoidCallback onReply;
  final List<Member> members;

  const ChatCard({
    super.key,
    required this.senderName,
    required this.message,
    required this.time,
    required this.replyTo,
    this.isMine = false,
    this.isAdmin = false,
    required this.onReply,
    required this.members,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg =
        isMine ? theme.colorScheme.primary.withOpacity(0.15) : theme.cardColor;

    final replyName = replyTo?.senderId == null
        ? "Admin"
        : members.where((e) => e.id == replyTo!.senderId).first.name;

    final border = RoundedRectangleBorder(
      side: isAdmin ? BorderSide(color: primaryColor) : BorderSide.none,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft:
            isMine ? const Radius.circular(18) : const Radius.circular(4),
        bottomRight:
            isMine ? const Radius.circular(4) : const Radius.circular(18),
      ),
    );

    return GestureDetector(
      onLongPress: () {
        onReply();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMine)
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: userIdToColor(senderName),
                  child: Text(
                    senderName[0].toUpperCase(),
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
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (replyTo != null)
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
                              replyTo!.message,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    if (!isMine)
                      Row(
                        children: [
                          if (isAdmin)
                            Icon(
                              Icons.security_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          Text(
                            senderName,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    if (!isMine) const SizedBox(height: 4),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat("dd/MM/yy h:mm a").format(time),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.hintColor,
                            fontSize: 11,
                          ),
                        ),
                        if (isMine)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.done_all,
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
