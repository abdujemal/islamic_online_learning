// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: annotate_overrides, overridden_fields


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_online_learning/features/main/domain/entity/faq_entity.dart';

class FAQModel extends FAQEntity {
  final String id;
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

  factory FAQModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map;
    return FAQModel(
      id: doc.id,
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  FAQModel copyWith({
    String? id,
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
