import 'dart:convert';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/subscription.dart';
import 'package:islamic_online_learning/features/payments/models/payment_provider.dart';
import 'package:islamic_online_learning/features/payments/models/tier.dart';

class PaymentService {
  Future<List<PaymentProvider>> getProviders() async {
    final response = await customGetRequest(
      paymentProvidersApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      return PaymentProvider.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load payment providers: ${response.body}');
    }
  }

  Future<List<Tier>> getPriceTiers() async {
    final response = await customGetRequest(
      paymentPricesApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      return Tier.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load tiers: ${response.body}');
    }
  }

  Future<Subscription?> submitPayment(
      String type, String tnxId, String provider) async {
    final response = await customPostRequest(
      paymentApi,
      {
        "paymentType": type,
        "txnId": tnxId,
        "paymentProvider": provider,
        "plan": "Basic"
      },
      authorized: true,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['subscription'] != null) {
        return Subscription.fromMap(
            data['subscription'] as Map<String, dynamic>);
      } else {
        return null;
      }

      // return PaymentProvider.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to submit payment: ${response.body}');
    }
  }
}
