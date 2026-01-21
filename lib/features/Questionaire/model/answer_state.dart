class AnswerState {
  String? selectedValue;
  List<String> selectedValues = [];
  String? text;
  int? rating;
  int? price;
  int? priceMin;
  int? priceMax;

  Map<String, dynamic> toApi(String questionId) {
    return {
      "questionId": questionId,
      "selectedValue": selectedValue,
      "answerOptions": selectedValues,
      "answerText": text,
      "rating": rating,
      "priceValue": price,
      "priceMin": priceMin,
      "priceMax": priceMax,
    }..removeWhere((_, v) => v == null || (v is List && v.isEmpty));
  }
}
