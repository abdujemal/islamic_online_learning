// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/payments/models/payment_provider.dart';
import 'package:islamic_online_learning/features/payments/models/tier.dart';

class PaymentState {
  final bool providersLoading, tierInitial, tierLoading, submitting, providersInitial;
  final String? providersError, tierError;
  final int? selectedTier;
  final List<Tier> tiers;
  final List<PaymentProvider> providers;
  PaymentState({
    //provider state
    this.providersInitial = true,
    this.providersLoading = false,
    this.providersError,
    this.providers = const [],
    //tier state
    this.tierInitial = true,
    this.tierLoading = false,
    this.tierError,
    this.tiers = const [],
    //submission state
    this.submitting = false,
    //payment type
    this.selectedTier,
  });

  Widget providerMap({
    required Widget Function(PaymentState _) loading,
    required Widget Function(PaymentState _) loaded,
    required Widget Function(PaymentState _) empty,
    required Widget Function(PaymentState _) error,
  }) {
    if (providersInitial) {
      return SizedBox();
    } else if (providersLoading) {
      return loading(this);
    } else if (!providersLoading && providersError != null) {
      return error(this);
    } else if (!providersLoading && providers.isNotEmpty) {
      return loaded(this);
    } else if (!providersLoading && providers.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  Widget tierMap({
    required Widget Function(PaymentState _) loading,
    required Widget Function(PaymentState _) loaded,
    required Widget Function(PaymentState _) empty,
    required Widget Function(PaymentState _) error,
  }) {
    if (tierInitial) {
      return SizedBox();
    } else if (tierLoading) {
      return loading(this);
    } else if (!tierLoading && tierError != null) {
      return error(this);
    } else if (!tierLoading && tiers.isNotEmpty) {
      return loaded(this);
    } else if (!tierLoading && tiers.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  PaymentState copyWith({
    bool? providersLoading,
    String? providersError,
    List<PaymentProvider>? providers,
    bool? submitting,
    int? selectedTier,
    //tier state
    bool? tierLoading,
    String? tierError,
    List<Tier>? tiers,
  }) {
    return PaymentState(
      providersInitial: false,
      providersLoading: providersLoading ?? this.providersLoading,
      providers: providers ?? this.providers,
      providersError: providersError,
      //
      tierInitial: false,
      tierLoading: tierLoading ?? this.tierLoading,
      tiers: tiers ?? this.tiers,
      tierError: tierError ?? this.tierError,
      //
      submitting: submitting ?? this.submitting,
      selectedTier: selectedTier ?? this.selectedTier,
    );
  }
}
