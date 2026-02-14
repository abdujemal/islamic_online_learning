import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/curriculum/service/curriculum_service.dart';
import 'curriculum_state.dart';

class CurriculumNotifier extends StateNotifier<CurriculumState> {
  final CurriculumService service;

  CurriculumNotifier(this.service) : super(CurriculumState());

  Future<void> getCurriculums() async {
    try {
      state = state.copyWith(isLoading: true);
      final curriculums = await service.fetchCurriculums();
      print(curriculums);
      state = state.copyWith(isLoading: false, curriculums: curriculums);
    } on ConnectivityException catch (err) {
      // toast(err.message, ToastType.error, context)
      state = state.copyWith(
        isLoading: false,
        error: err.message,
      );
    } catch (e) {
      print("Error: $e");
      state = state.copyWith(isLoading: false, error: "ክፍሎች ማግኘት አልተቻለም።");
    }
  }

  
}
