import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/payments/service/payment_service.dart';
import 'package:islamic_online_learning/features/payments/view/controller/payment_notifier.dart';
import 'package:islamic_online_learning/features/payments/view/controller/payment_state.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(
    ref,
    ref.read(paymentServiceProvider),
  );
});
