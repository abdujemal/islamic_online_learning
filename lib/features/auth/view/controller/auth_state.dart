import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

class AuthState {
  final bool isLoading, initial, courseStarted;
  final User? user;
  final List<Score>? scores;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.initial = true,
    this.courseStarted = false,
    this.scores,
    this.user,
    this.error,
  });

  Widget map({
    required Widget Function(AuthState _) loading,
    required Widget Function(AuthState _) loaded,
    required Widget Function(AuthState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && user != null) {
      return loaded(this);
    } else {
      return SizedBox();
    }
  }

  AuthState copyWith({
    bool? isLoading,
    bool? courseStarted,
    User? user,
    List<Score>? scores,
    String? error,
  }) {
    return AuthState(
      initial: false,
      courseStarted: courseStarted ?? this.courseStarted,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      scores: scores ?? this.scores,
      error: error,
    );
  }
}
