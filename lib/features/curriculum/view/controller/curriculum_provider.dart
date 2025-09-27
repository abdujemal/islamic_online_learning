import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/service/curriculum_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/curriculum_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/curriculum_state.dart';

// Provide the service instance
final curriculumServiceProvider = Provider<CurriculumService>((ref) {
  return CurriculumService();
});

// Provide the state notifier
final curriculumNotifierProvider =
    StateNotifierProvider<CurriculumNotifier, CurriculumState>((ref) {
  final service = ref.watch(curriculumServiceProvider);
  return CurriculumNotifier(service);
});
