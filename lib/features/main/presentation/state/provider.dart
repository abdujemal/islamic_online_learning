import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/fav_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_state.dart';

import '../../data/main_repo_impl.dart';
import 'fav_list_notifier.dart';

final menuIndexProvider = StateProvider<int>((ref) => 0);

final queryProvider = StateProvider<String>((ref) => "");

final firebaseDatabaseProvider =
    Provider<FirebaseDatabase>((ref) => FirebaseDatabase.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final mainDataSrcProvider = Provider<MainDataSrc>((ref) {
  return IMainDataSrc(
      ref.read(firebaseDatabaseProvider), ref.read(firebaseFirestoreProvider));
});

final mainRepoProvider = Provider<MainRepo>((ref) {
  return IMainRepo(ref.read(mainDataSrcProvider));
});

final mainNotifierProvider =
    StateNotifierProvider<MainListNotifier, MainListState>((ref) {
  return MainListNotifier(ref.read(mainRepoProvider));
});

final favNotifierProvider =
    StateNotifierProvider<FavListNotifier, FavListState>((ref) {
  return FavListNotifier(ref.read(mainRepoProvider));
});

final categoryNotifierProvider =
    StateNotifierProvider<CategoryListNotifier, CategoryListState>((ref) {
  return CategoryListNotifier(ref.read(mainRepoProvider));
});

final ustazNotifierProvider =
    StateNotifierProvider<UstazListNotifier, UstazListState>((ref) {
  return UstazListNotifier(ref.read(mainRepoProvider));
});
