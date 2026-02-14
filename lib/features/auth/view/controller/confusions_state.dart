import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';

class ConfusionsState {
  final bool isLoading, isLoadingMore, hasNoMore, initial;
  final int page;
  final List<Confusion> confusions;
  final String? error;

  ConfusionsState({
    this.initial = true,
    this.page = 1,
    this.isLoading = false,
    this.hasNoMore = false,
    this.isLoadingMore = false,
    this.confusions = const [],
    this.error,
  });

  Widget map({
    required Widget Function(ConfusionsState _) loading,
    required Widget Function(ConfusionsState _) loaded,
    required Widget Function(ConfusionsState _) empty,
    required Widget Function(ConfusionsState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && confusions.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && confusions.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  ConfusionsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNoMore,
    int? page,
    List<Confusion>? confusions,
    String? error,
  }) {
    return ConfusionsState(
      initial: false,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNoMore: hasNoMore ?? this.hasNoMore,
      isLoading: isLoading ?? this.isLoading,
      confusions: confusions ?? this.confusions,
      page: page ?? this.page,
      error: error,
    );
  }
}
