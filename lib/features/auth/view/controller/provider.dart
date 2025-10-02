
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
import 'package:islamic_online_learning/features/auth/view/controller/register_notifier.dart';
import 'package:islamic_online_learning/features/auth/view/controller/register_state.dart';
import 'package:islamic_online_learning/features/auth/view/controller/sign_in_notifier.dart';
import 'package:islamic_online_learning/features/auth/view/controller/sign_in_state.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final signInNotifierProvider =
    StateNotifierProvider<SignInNotifier, SignInState>((ref) {
  return SignInNotifier(ref.read(authServiceProvider), ref);
});

final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref.read(authServiceProvider), ref);
});