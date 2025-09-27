import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_state.dart';

class CategoryListNotifier extends StateNotifier<CategoryListState> {
  final MainRepo mainRepo;
  CategoryListNotifier(this.mainRepo) : super(CategoryListState());

  Future<void> getCategories() async {
    state = state.copyWith(isLoading: true);

    final res = await mainRepo.getCategories();

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        if (r.isEmpty) {
          state = state.copyWith(isLoading: false, categories: r);

          return;
        }
        state = state.copyWith(isLoading: false, categories: r);
      },
    );
  }
}
