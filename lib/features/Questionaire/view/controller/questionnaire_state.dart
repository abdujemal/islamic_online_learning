// ignore_for_file: public_member_api_docs, sort_constructors_first
class QuestionnaireState {
  final bool isSubmitting;
  QuestionnaireState({
    this.isSubmitting = false,
  });
  

  QuestionnaireState copyWith({
    bool? isSubmitting,
  }) {
    return QuestionnaireState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
