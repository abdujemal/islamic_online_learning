import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatCardShimmer extends StatelessWidget {
  final bool isMine;

  const ChatCardShimmer({
    super.key,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleWidth = MediaQuery.of(context).size.width * 0.55;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMine)
            Shimmer.fromColors(
              baseColor:
              Theme.of(context).chipTheme.backgroundColor!.withAlpha(150),
          highlightColor: Theme.of(context).chipTheme.backgroundColor!,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),

          if (!isMine)
            const SizedBox(width: 8),

          Shimmer.fromColors(
            baseColor:
              Theme.of(context).chipTheme.backgroundColor!.withAlpha(150),
          highlightColor: Theme.of(context).chipTheme.backgroundColor!,
            child: Container(
              width: bubbleWidth,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isMine ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isMine ? const Radius.circular(4) : const Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isMine)
                    Container(
                      height: 12,
                      width: bubbleWidth * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                  if (!isMine) const SizedBox(height: 8),

                  Container(
                    height: 12,
                    width: bubbleWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    height: 12,
                    width: bubbleWidth * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment:
                        isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      height: 10,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
