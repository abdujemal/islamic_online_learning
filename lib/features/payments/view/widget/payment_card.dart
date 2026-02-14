import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/features/payments/models/payment.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({
    super.key,
    required this.payment,
  });

  Color _statusColor() {
    switch (payment.status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon() {
    switch (payment.status.toLowerCase()) {
      case "completed":
        return Icons.check_circle;
      case "pending":
        return Icons.hourglass_top;
      case "failed":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = payment.createdAt;
    return GestureDetector(
      onTap: () {
        // open details
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: _statusColor().withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_statusIcon(), color: _statusColor(), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.paymentProvider,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ref: ${payment.txnId}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat("dd/MM/yy • h:mm a").format(date),
                    // "${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  if (payment.status == "FAILED") const SizedBox(height: 4),
                  if (payment.status == "FAILED")
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        border: Border.all(
                          color: Colors.red,
                        ),
                      ),
                      child: Text(
                        "Reason: ${payment.failedReason}",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  if (payment.status == "FAILED" && payment.failedReason == "Amount mismatch")
                    Text(
                      "Paid Amount: ETB ${payment.paidAmount?.toStringAsFixed(2)}",
                      style: const TextStyle(
                        // fontSize: 17,
                        // fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "ETB ${payment.expectedAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment.status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
