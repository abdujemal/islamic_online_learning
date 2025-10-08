// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';

import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

class AuthState {
  final bool isLoading, initial, courseStarted;
  final User? user;
  final CourseRelatedData? courseRelatedData;
  final List<Score>? scores;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.initial = true,
    this.courseStarted = false,
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
    CourseRelatedData? courseRelatedData,
  }) {
    return AuthState(
      initial: false,
      courseStarted: courseStarted ?? this.courseStarted,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      scores: scores ?? this.scores,
      error: error,
      courseRelatedData: courseRelatedData ?? this.courseRelatedData,
    );
  }
}

