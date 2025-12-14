import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/payments/models/payment_provider.dart';
import 'package:islamic_online_learning/features/payments/models/tier.dart';
import 'package:islamic_online_learning/features/payments/service/payment_service.dart';
import 'package:islamic_online_learning/features/payments/view/controller/payment_state.dart';
import 'package:islamic_online_learning/features/payments/view/pages/payment_pending_page.dart';
import 'package:islamic_online_learning/features/payments/view/pages/payment_success_page.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentService paymentService;
  Ref ref;
  PaymentNotifier(this.ref, this.paymentService) : super(PaymentState());

  Future<void> getProviders(BuildContext context) async {
    state = state.copyWith(providersLoading: true, providersError: null);
    try {
      // Simulate network call

      // Assume we fetched the following providers
      List<PaymentProvider> fetchedProviders =
          await paymentService.getProviders();

      state = state.copyWith(
        providersLoading: false,
        providers: fetchedProviders,
      );
    } catch (e) {
      handleError(e.toString(), context, ref, () {
        state = state.copyWith(
          providersLoading: false,
          providersError: "ማግኘት አልተቻለም! ${e.toString()}",
        );
      });
    }
  }

  void toggleTier(int i) {
    state = state.copyWith(selectedTier: i);
  }

  Future<void> getPriceTiers(BuildContext context) async {
    state = state.copyWith(tierLoading: true, tierError: null);
    try {
      // Simulate network call

      // Assume we fetched the following providers
      List<Tier> fetchedTiers = await paymentService.getPriceTiers();
      fetchedTiers.sort((a, b) => b.price.compareTo(a.price));

      state = state.copyWith(
        tierLoading: false,
        tiers: fetchedTiers,
        selectedTier: fetchedTiers.isNotEmpty ? 0 : null,
      );
    } catch (e) {
      handleError(e.toString(), context, ref, () {
        state = state.copyWith(
          tierLoading: false,
          tierError: "ማግኘት አልተቻለም! ${e.toString()}",
        );
      });
    }
  }

  Future<void> submitPayment(
      String tnxId, String provider, BuildContext context) async {
    state = state.copyWith(submitting: true);
    try {
      final subscription = await paymentService.submitPayment(
          state.tiers[state.selectedTier!].duration, tnxId, provider);
      state = state.copyWith(submitting: false);

      if (subscription == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentPendingPage(
              amount: state.tiers[state.selectedTier!].price.toString(),
              reference: tnxId,
              bank: provider,
            ),
          ),
        );
      } else {
        ref.read(authNotifierProvider.notifier).setSubscription(subscription);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessPage(
              amount: state.tiers[state.selectedTier!].price.toString(),
              reference: tnxId,
              bank: provider,
            ),
          ),
        );
      }
    } catch (e) {
      handleError(
        e.toString(),
        context,
        ref,
        () {
          state = state.copyWith(submitting: false);
          toast(
              "ክፍያውን ማስተላለፍ አልተቻለም! ${e.toString()}", ToastType.error, context);
        },
      );
    }
  }
}
