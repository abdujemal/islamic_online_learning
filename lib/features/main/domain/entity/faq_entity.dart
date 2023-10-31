// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class FAQEntity extends Equatable {
  final String id;
  final String question;
  final String answer;
  const FAQEntity({
    required this.id,
    required this.question,
    required this.answer,
  });

  @override
  List<Object?> get props => [
        id,
        question,
        answer,
      ];
}
