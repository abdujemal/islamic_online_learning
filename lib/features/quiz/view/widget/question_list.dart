import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/view/pages/islamic_streak_page.dart';
// import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_notifier.dart';
import 'package:lottie/lottie.dart';

class QuestionOption {
  final String id;
  final String text;
  final bool isCorrect;
  QuestionOption({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });
}

class QuestionModel {
  final String id;
  final String question;
  final List<QuestionOption> options;
  final bool allowMultiple;
  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    this.allowMultiple = false,
  });
}

class MultipleQuestionQuiz extends ConsumerStatefulWidget {
  final List<QuestionModel> questions;
  final bool fromDiscussion;
  final bool isPrerequisite;
  final Future<bool> Function(int score, Map<String, List<String>> answers)
      onFinish;
  final Function(Map<String, String> qa)? onSubmit;

  const MultipleQuestionQuiz({
    super.key,
    required this.questions,
    required this.onFinish,
    this.onSubmit,
    this.fromDiscussion = false,
    this.isPrerequisite = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MultipleQuestionQuizState();
}

class _MultipleQuestionQuizState extends ConsumerState<MultipleQuestionQuiz>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final Map<String, List<String>> _answers = {};
  int _score = 0;
  bool _showReview = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    if (widget.fromDiscussion) {
      initAnswers();
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  void initAnswers() {
    final quizAnses = ref.read(quizAnsStateProvider);
    for (QuizAns q in quizAnses) {
      _answers[q.quizId] = ["${q.answer}"];
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _calculateScore() {
    int score = 0;
    for (var q in widget.questions) {
      final correct =
          q.options.where((o) => o.isCorrect).map((e) => e.id).toList();
      final selected = _answers[q.id] ?? [];
      if (ListEquality().equals(correct, selected)) score++;
    }
    setState(() => _score = score);
  }

  Future<void> _goNext() async {
    if (_currentIndex < widget.questions.length - 1) {
      _controller.reverse().then((_) {
        setState(() {
          _currentIndex++;
        });
        _controller.forward();
      });
    } else {
      _calculateScore();
      final go = await widget.onFinish(_score, _answers);
      if (go) {
        if (widget.fromDiscussion || widget.isPrerequisite) return;
        setState(() => _showReview = true);
      }
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      _controller.reverse().then((_) {
        setState(() {
          _currentIndex--;
        });
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showReview) return _buildReviewPage();

    final current = widget.questions[_currentIndex];
    final selectedAnswers = _answers[current.id] ?? [];

    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.08),
          //     blurRadius: 12,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.fromDiscussion)
              Consumer(builder: (context, ref, _) {
                final remainingSec = ref.watch(remainingSecondsProvider);
                final voiceRoomState = ref.read(voiceRoomNotifierProvider);
                final remainingMsec = remainingSec -
                    (voiceRoomState.givenTime?.segments.assignment ?? 0);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(formatTime(remainingMsec)),
                );
              }),
            LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.questions.length,
              color: Colors.blueAccent,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            Text(
              "ጥያቄ ${_currentIndex + 1} / ${widget.questions.length}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                // color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              current.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                // color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ...current.options.map((option) {
              final selected = selectedAnswers.contains(option.id);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? Colors.blueAccent.withOpacity(0.08) : null,
                  border: Border.all(
                    color: selected
                        ? Colors.blueAccent
                        : Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.grey,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      if (current.allowMultiple) {
                        if (selectedAnswers.contains(option.id)) {
                          selectedAnswers.remove(option.id);
                        } else {
                          selectedAnswers.add(option.id);
                        }
                      } else {
                        selectedAnswers
                          ..clear()
                          ..add(option.id);
                      }
                      _answers[current.id] = List.from(selectedAnswers);
                      if (widget.onSubmit != null) {
                        widget.onSubmit!({
                          "qid": current.id,
                          "answer": option.id,
                        });
                      }
                    });
                  },
                  title: Text(
                    option.text,
                    style: TextStyle(
                      color: selected ? Colors.blueAccent.shade700 : null,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: selected
                        ? const Icon(Icons.check_circle,
                            color: Colors.blueAccent)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                if (_currentIndex > 0)
                  OutlinedButton(
                    onPressed: _goPrevious,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.blueAccent),
                    ),
                    child: const Text(
                      "ቀዳሚ",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Consumer(builder: (context, ref, _) {
                    final state = ref.watch(quizNotifierProvider);
                    return state.isSubmitting
                        ? CircularProgressIndicator(
                            color: whiteColor,
                          )
                        : Text(
                            _currentIndex == widget.questions.length - 1
                                ? "አስረክብ"
                                : "ቀጣይ",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewPage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Lottie.asset(
                  'assets/animations/success.json',
                  height: 160,
                  repeat: false,
                ),
                Text(
                  "🎉 ጥያቄዎቹን አጠናቀዋል!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "ያገኙት ነጥብ: ${_score} / ${widget.questions.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    // color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).chipTheme.backgroundColor ??
                            Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: Text(
                    _getMotivationalMessage(
                      ((_score) / widget.questions.length) * 100,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      // color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...widget.questions.map((q) {
                  final selected = _answers[q.id] ?? [];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).chipTheme.backgroundColor ??
                            Colors.transparent,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        ...q.options.map((o) {
                          final isSelected = selected.contains(o.id);
                          final isCorrect = o.isCorrect;
                          final color = isCorrect
                              ? Colors.green.shade600
                              : (isSelected ? Colors.red.shade600 : null);
                          return Row(
                            children: [
                              Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : (isSelected
                                        ? Icons.cancel
                                        : Icons.circle_outlined),
                                color: color,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  o.text,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 15,
                                    fontWeight: isCorrect
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
          ),
          child: ElevatedButton(
            onPressed: () {
              // final streakWNo = ref.read(currentStreakProvider);
              // print("streak: $streakWNo");
              Navigator.pushReplacement(
                ref.context,
                MaterialPageRoute(
                  builder: (_) => IslamicStreakPage(type: "Lesson"),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                color: whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getMotivationalMessage(double percent) {
    if (percent >= 90) {
      return "🌟ማሻአላህ! ጥሩ ስራ ሰርተዋል።\nለአላህ ብለው እውቀት መሻታትዎን ይቀጥሉ 'እውቀትን ለመፈለግ መንገድን የተከተለ አላህ የጀነት መንገድን ያቀልለት' (ሙስሊም)";
      //return "🌟 مَا شَاءَ اللهُ! You’ve done excellently.\nKeep seeking knowledge for the sake of Allah, for 'Whoever follows a path to seek knowledge, Allah will make easy for him a path to Paradise.' (Muslim)";
    } else if (percent >= 70) {
      return "💪 አልሀምዱሊላህ! ጥሩ እየሰሩ ነው።\nያስታውሱ፡- 'ከእናንተ መካከል ምርጦች እውቀትን የሚማሩ እና የሚያስተምሩ ናቸው።' (ቡኻሪ)";
      // return "💪 Alhamdulillah! You’re doing great.\nRemember: 'The best among you are those who learn and teach knowledge.' (Bukhari)";
    } else if (percent >= 50) {
      return "🌱 ጥሩ ጥረዋል! ደረጃ በደረጃ መማርዎን ይቀጥል።\nአላህ ለበጎ ነገር የሚተጉትን ይወዳል - እያንዳንዱ ጥረት ትልቅ ዋጋ አለው ኢንሻአላህ።";
      // return "🌱 Good effort! Keep learning step by step.\nAllah loves those who strive for goodness — every bit of effort counts, insha’Allah.";
    } else {
      return "📖 ተስፋ አይቁረጡ! እውቀትን ለመሻት ትንሽ እርምጃዎች እንኳን ያሸለማሉ።\nነብዩ (ሶ.ዐ.ወ) እንዲህ ብለዋል፡- 'እውቀትን ፍለጋ መንገድን የያዘ ሰው አላህ የጀነትን መንገድ ያቀልለታል። (ቲርሚዚ)";
      // return "📖 Don’t give up! Even small steps in seeking knowledge are rewarded.\nThe Prophet ﷺ said: 'Whoever takes a path in search of knowledge, Allah will make easy for him the path to Paradise.' (Tirmidhi)";
    }
  }
}

class ListEquality {
  bool equals(List a, List b) {
    if (a.length != b.length) return false;
    for (var e in a) {
      if (!b.contains(e)) return false;
    }
    return true;
  }
}
