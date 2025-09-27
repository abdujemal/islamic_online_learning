import 'package:flutter/material.dart';

class UstazListState {
  final bool isLoading;
  final List<String> ustazs;
  final String? error;

  UstazListState({
    this.isLoading = false,
    this.ustazs = const [],
    this.error,
  });

  Widget map({
    required Widget Function(UstazListState _) loading,
    required Widget Function(UstazListState _) loaded,
    required Widget Function(UstazListState _) empty,
    required Widget Function(UstazListState _) error,
  }) {
    if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && ustazs.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && ustazs.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  UstazListState copyWith({
    bool? isLoading,
    List<String>? ustazs,
    String? error,
  }) {
    return UstazListState(
      isLoading: isLoading ?? this.isLoading,
      ustazs: ustazs ?? this.ustazs,
      error: error,
    );
  }
}
