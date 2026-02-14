import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/core/constants.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final DateTime time;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final String? actionLabel;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    this.icon = Icons.notifications,
    this.onTap,
    this.onActionTap,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Islamic soft green/cream tone
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
          // border: Border.all(
          //   color: const Color(0xFFDCE5C3), // subtle islamic border
          //   width: 1,
          // ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor, // muted Islamic green
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),

            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      // color: Color(0xFF2F3A23),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Body
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 14,
                      // color: Color(0xFF4E5A35),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Time + Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("dd/MM/yy h:mm a").format(time),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      if (actionLabel != null)
                        TextButton(
                          onPressed: onActionTap,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            actionLabel!,
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
