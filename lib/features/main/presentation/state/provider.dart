import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/beginner_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/faq_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/faq_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/fav_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/started_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/started_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/main_repo_impl.dart';
import 'beginner_list_state.dart';
import 'fav_list_notifier.dart';

final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

final fontScaleProvider = StateProvider<double>((ref) {
  return 1.0;
});

final showGuideProvider = StateProvider<List<bool>>((ref) {
  return [false, false];
});



// final isSubedProvider = StateProvider<bool>((ref) {
//   return false;
// });

final showBeginnerProvider = StateProvider<bool>((ref) {
  return true;
});

final sharedPrefProvider = Provider<Future<SharedPreferences>>((ref) {
  return SharedPreferences.getInstance();
});

final menuIndexProvider = StateProvider<int>((ref) => 0);

final queryProvider = StateProvider<String>((ref) => "");

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final mainDataSrcProvider = Provider<MainDataSrc>((ref) {
  return IMainDataSrc(ref.read(firebaseFirestoreProvider));
});

final mainRepoProvider = Provider<MainRepo>((ref) {
  return IMainRepo(ref.read(mainDataSrcProvider));
});

final mainNotifierProvider =
    StateNotifierProvider<MainListNotifier, MainListState>((ref) {
  return MainListNotifier(ref.read(mainRepoProvider), ref);
});

final favNotifierProvider =
    StateNotifierProvider<FavListNotifier, FavListState>((ref) {
  return FavListNotifier(ref.read(mainRepoProvider), ref);
});

final categoryNotifierProvider =
    StateNotifierProvider<CategoryListNotifier, CategoryListState>((ref) {
  return CategoryListNotifier(ref.read(mainRepoProvider));
});

final ustazNotifierProvider =
    StateNotifierProvider<UstazListNotifier, UstazListState>((ref) {
  return UstazListNotifier(ref.read(mainRepoProvider));
});

final faqNotifierProvider =
    StateNotifierProvider<FaqListNotifier, FAQListState>((ref) {
  return FaqListNotifier(ref.read(mainRepoProvider));
});

final startedNotifierProvider =
    StateNotifierProvider<StartedListNotifier, StartedListState>((ref) {
  return StartedListNotifier(ref.read(mainRepoProvider), ref);
});

final beginnerListProvider =
    StateNotifierProvider<BeginnerListNotifier, BeginnerListState>((ref) {
  return BeginnerListNotifier(ref.read(mainRepoProvider));
});
