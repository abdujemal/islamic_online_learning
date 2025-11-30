// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';

import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

enum CourseStarted {
  INITIAL,
  STARTED,
  NOTSTARTED,
  LOADING,
}

class AuthState {
  final bool isLoading, isUpdating, initial, tokenIsNull;
  final User? user;
  final CourseStarted courseStarted;
  final CourseRelatedData? courseRelatedData;
  final List<ConstScore>? scores;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isUpdating = false,
    this.initial = true,
    this.courseStarted = CourseStarted.INITIAL,
    this.tokenIsNull = true,
    this.scores,
    this.user,
    this.error,
    this.courseRelatedData,
  });

  Widget map({
    required Widget Function(AuthState _) loading,
    required Widget Function(AuthState _) loaded,
    required Widget Function(AuthState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (courseStarted == CourseStarted.LOADING) {
      return loading(this);
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
    bool? isUpdating,
    CourseStarted? courseStarted,
    bool? tokenIsNull,
    User? user,
    List<ConstScore>? scores,
    String? error,
    CourseRelatedData? courseRelatedData,
  }) {
    return AuthState(
      initial: false,
      courseStarted: courseStarted ?? this.courseStarted,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      user: user ?? this.user,
      scores: scores ?? this.scores,
      error: error,
      tokenIsNull: tokenIsNull ?? false,
      courseRelatedData: courseRelatedData ?? this.courseRelatedData,
    );
  }
}
