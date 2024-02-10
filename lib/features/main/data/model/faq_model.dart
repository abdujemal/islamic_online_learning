// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: annotate_overrides, overridden_fields

import 'package:islamic_online_learning/features/main/domain/entity/faq_entity.dart';

class FAQModel extends FAQEntity {
  final int? id;
  final String question;
  final String answer;
  const FAQModel({
    required this.id,
    required this.question,
    required this.answer,
  }) : super(
          id: id,
          question: question,
          answer: answer,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  factory FAQModel.fromMap(Map map, String id) {
    return FAQModel(
      id: null,
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  FAQModel copyWith({
    int? id,
    String? question,
    String? answer,
  }) {
    return FAQModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}
