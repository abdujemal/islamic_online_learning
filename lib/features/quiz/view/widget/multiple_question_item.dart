import 'package:flutter/material.dart';

class QuestionOption {
  final String id;
  final String text;
  final bool isCorrect; // optional for local checking; backend may provide this
  QuestionOption(
      {required this.id, required this.text, this.isCorrect = false});
}

class MultipleQuestionItem extends StatefulWidget {
  final String question;
  final List<QuestionOption> options;
  final bool allowMultiple;
  final String? explanation;
  final void Function(List<String> selectedIds)? onSubmit;
  final Duration animationDuration;

  const MultipleQuestionItem({
    super.key,
    required this.question,
    required this.options,
    this.allowMultiple = false,
    this.explanation,
    this.onSubmit,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<MultipleQuestionItem> createState() => _MultipleQuestionItemState();
}

class _MultipleQuestionItemState extends State<MultipleQuestionItem>
    with SingleTickerProviderStateMixin {
  final Set<String> _selected = {};
  bool _submitted = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _toggleSelect(String id) {
    if (_submitted) return; // no changes after submit
    setState(() {
      if (widget.allowMultiple) {
        if (_selected.contains(id))
          _selected.remove(id);
        else
          _selected.add(id);
      } else {
        if (_selected.contains(id))
          _selected.clear();
        else {
          _selected
            ..clear()
            ..add(id);
        }
      }
    });
  }

  void _submit() {
    if (_selected.isEmpty) {
      // shake as feedback for empty submission
      _shakeController.forward(from: 0);
      return;
    }
    setState(() => _submitted = true);
    widget.onSubmit?.call(_selected.toList(growable: false));
  }

  Color? _optionBgColor(QuestionOption opt) {
    // if (!_submitted) return Colors.white;
    // // after submit show correct/incorrect states when isCorrect is set
    // if (opt.isCorrect && _selected.contains(opt.id)) return Colors.green.shade50;
    // if (opt.isCorrect) return Colors.green.shade50.withOpacity(0.9);
    // if (_selected.contains(opt.id) && !opt.isCorrect) return Colors.red.shade50;
    return null; //Colors.white;
  }

  Widget _buildOption(QuestionOption option) {
    final selected = _selected.contains(option.id);
    final showCorrectness = _submitted && option.isCorrect;
    final showWrong = _submitted && selected && !option.isCorrect;

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _optionBgColor(option),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? (showCorrectness
                  ? Colors.green
                  : (showWrong ? Colors.red : Colors.blueAccent))
              : Colors.grey.shade300,
          width: selected ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (!selected)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: InkWell(
        onTap: () => _toggleSelect(option.id),
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            // Left indicator (checkbox-like)
            AnimatedContainer(
              duration: widget.animationDuration,
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? (showCorrectness
                        ? Colors.green
                        : (showWrong ? Colors.red : Colors.blueAccent))
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? Colors.transparent : Colors.grey.shade300,
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: widget.animationDuration,
                  transitionBuilder: (w, a) =>
                      ScaleTransition(scale: a, child: w),
                  child: selected
                      ? Icon(
                          showCorrectness
                              ? Icons.check_circle
                              : (showWrong ? Icons.close : Icons.check),
                          key: ValueKey(option.id +
                              (showCorrectness
                                  ? 'c'
                                  : showWrong
                                      ? 'w'
                                      : 's')),
                          color: Colors.white,
                          size: 22,
                        )
                      : Icon(
                          widget.allowMultiple
                              ? Icons.circle_outlined
                              : Icons.radio_button_unchecked,
                          key: ValueKey(option.id + 'u'),
                          color: Colors.grey,
                          size: 20,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Text and explanation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _submitted && showWrong
                          ? Colors.red.shade700
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedOpacity(
                    opacity: (_submitted && option.isCorrect) ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    child: (_submitted && option.isCorrect)
                        ? Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.green.shade700, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'እርስዎ ይህን ትክክለኛ አገኙ',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.green.shade700),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shakeAnim =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.02, 0))
            .chain(
              CurveTween(curve: Curves.elasticIn),
            )
            .animate(_shakeController);

    return SlideTransition(
      position: shakeAnim,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // question header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.help_outline, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // options
            ...widget.options.map(_buildOption).toList(),

            const SizedBox(height: 10),
            AnimatedCrossFade(
              firstChild: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _submitted
                          ? null
                          : () {
                              setState(() => _selected.clear());
                            },
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitted ? null : _submit,
                      child: Text(_submitted
                          ? 'Submitted'
                          : (widget.allowMultiple ? 'Submit' : 'Submit')),
                    ),
                  ),
                ],
              ),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.explanation != null) ...[
                    const Divider(),
                    Text(
                      'Explanation',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 6),
                    Text(widget.explanation!,
                        style: const TextStyle(fontSize: 14)),
                  ],
                ],
              ),
              crossFadeState: _submitted
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: widget.animationDuration,
            ),
          ],
        ),
      ),
    );
  }
}
