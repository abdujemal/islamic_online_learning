import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
import 'package:islamic_online_learning/features/auth/view/controller/certificates_state.dart';

class CertificatesNotifier extends StateNotifier<CertificatesState> {
  final Ref ref;
  final AuthService service;
  CertificatesNotifier(this.service, this.ref) : super(CertificatesState());

  Future<void> getCertificates(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      final certificates = await service.getCertificates();
      // print(certificates);

      state = state.copyWith(
        isLoading: false,
        curriculumScores: certificates,
      );
    } on ConnectivityException catch (err) {
      // toast(err.message, ToastType.error, context)

      state = state.copyWith(
        isLoading: false,
        error: err.message,
      );
    } catch (e) {
      final errorMsg = getErrorMsg(
        e.toString(),
        "ሰርተፍኬቶቹን ማግኘት አልተቻለም።",
      );
      handleError(
        e.toString(),
        context,
        ref,
        () async {
          print("Error: $e");

          state = state.copyWith(
            isLoading: false,
            error: errorMsg,
          );
        },
      );
    }
  }
}
