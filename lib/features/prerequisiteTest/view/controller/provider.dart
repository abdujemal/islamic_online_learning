import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/service/prerequisite_test_service.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/view/controller/prerequisite_test_notifier.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/view/controller/prerequisite_test_state.dart';

final prerequisiteTestServiceProvider =
    Provider<PrerequisiteTestService>((ref) {
  return PrerequisiteTestService();
});

final prerequisiteTestNotifierProvider =
    StateNotifierProvider<PrerequisiteTestNotifier, PrerequisiteTestState>(
        (ref) {
  return PrerequisiteTestNotifier(ref.read(prerequisiteTestServiceProvider));
});