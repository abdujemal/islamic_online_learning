import 'dart:convert';

enum QuestionType {
  SHORT_TEXT,
  LONG_TEXT,
  SINGLE_CHOICE,
  MULTI_CHOICE,
  RATING,
  PRICE_INPUT,
  PRICE_RANGE
}

class QuestionOption {
  final String id;
  final String label;
  final String value;
  final int? priceMin;
  final int? priceMax;

  QuestionOption({
    required this.id,
    required this.label,
    required this.value,
    required this.priceMin,
    required this.priceMax,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      label: json['label'],
      value: json['value'],
      priceMin: json['priceMin'],
      priceMax: json['priceMax'],
    );
  }
}

class QuestionCondition {
  final String sourceQuestionId;
  final String triggerValue;
  final String targetQuestionId;

  QuestionCondition({
    required this.sourceQuestionId,
    required this.triggerValue,
    required this.targetQuestionId,
  });

  factory QuestionCondition.fromJson(Map<String, dynamic> json) {
    return QuestionCondition(
      sourceQuestionId: json['sourceQuestionId'],
      triggerValue: json['triggerValue'],
      targetQuestionId: json['targetQuestionId'],
    );
  }
}

class QuestionnaireQuestion {
  final String id;
  final String questionnaireId;
  final String text;
  final QuestionType type;
  final bool required;
  final String? currency;
  final String? priceUnit;
  final List<QuestionOption> options;
  final List<QuestionCondition> triggers;

  QuestionnaireQuestion({
    required this.id,
    required this.questionnaireId,
    required this.text,
    required this.type,
    required this.required,
    required this.currency,
    required this.priceUnit,
    this.options = const [],
    this.triggers = const [],
  });

  factory QuestionnaireQuestion.fromJson(Map<String, dynamic> json) {
    return QuestionnaireQuestion(
      id: json['id'],
      questionnaireId: json["questionnaireId"],
      text: json['text'],
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      currency: json["currency"],
      priceUnit: json["priceUnit"],
      required: json['required'] ?? false,
      options: (json['options'] as List)
          .map((e) => QuestionOption.fromJson(e))
          .toList(),
      triggers: (json['triggers'] as List)
          .map((e) => QuestionCondition.fromJson(e))
          .toList(),
    );
  }
}

class Questionnaire {
  final String id;
  final String title;
  final String description;
  final String type;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionnaireQuestion> questions;

  Questionnaire({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      questions: (json['questions'] as List)
          .map((e) => QuestionnaireQuestion.fromJson(e))
          .toList(),
    );
  }

  static List<Questionnaire> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Questionnaire.fromJson(json)).toList();
  }

  factory Questionnaire.fromMap(String jsonString) {
    final map = jsonDecode(jsonString);
    return Questionnaire.fromJson(map);
  }
}
