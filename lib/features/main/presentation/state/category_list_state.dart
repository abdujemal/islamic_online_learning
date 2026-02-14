import 'package:flutter/material.dart';

class CategoryListState {
  final bool isLoading;
  final List<String> categories;
  final String? error;

  CategoryListState({
    this.isLoading = false,
    this.categories = const [],
    this.error,
  });

  Widget map({
    required Widget Function(CategoryListState _) loading,
    required Widget Function(CategoryListState _) loaded,
    required Widget Function(CategoryListState _) empty,
    required Widget Function(CategoryListState _) error,
  }) {
    if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && categories.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && categories.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  CategoryListState copyWith({
    bool? isLoading,
    List<String>? categories,
    String? error,
  }) {
    return CategoryListState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      error: error,
    );
  }
}
