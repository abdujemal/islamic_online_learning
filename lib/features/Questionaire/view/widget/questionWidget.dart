import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_online_learning/features/Questionaire/model/answer_state.dart';
import 'package:islamic_online_learning/features/Questionaire/model/questionnaire.dart';

class QuestionWidget extends StatefulWidget {
  final QuestionnaireQuestion question;
  final ValueChanged<AnswerState> onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final AnswerState state = AnswerState();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.text,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    switch (widget.question.type) {
      case QuestionType.SHORT_TEXT:
      case QuestionType.LONG_TEXT:
        return TextField(
          maxLines: widget.question.type == QuestionType.LONG_TEXT ? 4 : 1,
          onChanged: (v) {
            state.text = v;
            widget.onChanged(state);
          },
        );

      case QuestionType.SINGLE_CHOICE:
        return Column(
          children: widget.question.options.map((o) {
            return RadioListTile<String>(
              value: o.value,
              groupValue: state.selectedValue,
              title: Text(o.label),
              onChanged: (v) {
                setState(() => state.selectedValue = v);
                widget.onChanged(state);
              },
            );
          }).toList(),
        );

      case QuestionType.PRICE_RANGE:
        return Column(
          children: widget.question.options.map((o) {
            return RadioListTile<String>(
              value: o.value,
              groupValue: state.selectedValue,
              title: Text(o.label),
              onChanged: (v) {
                setState(() {
                  state.selectedValue = v;
                  state.priceMax = o.priceMax;
                  state.priceMin = o.priceMin;
                });
                widget.onChanged(state);
              },
            );
          }).toList(),
        );

      case QuestionType.MULTI_CHOICE:
        return Column(
          children: widget.question.options.map((o) {
            return CheckboxListTile(
              value: state.selectedValues.contains(o.value),
              title: Text(o.label),
              onChanged: (v) {
                setState(() {
                  v!
                      ? state.selectedValues.add(o.value)
                      : state.selectedValues.remove(o.value);
                });
                widget.onChanged(state);
              },
            );
          }).toList(),
        );

      case QuestionType.RATING:
        return Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: (state.rating ?? 3).toDouble(),
          onChanged: (v) {
            setState(() => state.rating = v.toInt());
            widget.onChanged(state);
          },
        );

      case QuestionType.PRICE_INPUT:
        return TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (v) {
            state.price = int.tryParse(v);
            state.text = v;
            widget.onChanged(state);
          },
        );

      // default:
      //   return const SizedBox.shrink();
    }
  }
}
