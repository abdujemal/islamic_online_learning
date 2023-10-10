import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_state.dart';

class CategoryListNotifier extends StateNotifier<CategoryListState> {
  final MainRepo mainRepo;
  CategoryListNotifier(this.mainRepo)
      : super(const CategoryListState.initial());

  Future<void> getCategories() async {
    state = const CategoryListState.loading();

    final res = await mainRepo.getCategories();

    res.fold(
      (l) {
        state = CategoryListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = CategoryListState.empty(courses: r);
          return;
        }
        state = CategoryListState.loaded(categories: r);
      },
    );
  }
}
