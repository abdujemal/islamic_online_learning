import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class IslamicIntroPage extends ConsumerStatefulWidget {
  const IslamicIntroPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IslamicIntroPageState();
}

class _IslamicIntroPageState extends ConsumerState<IslamicIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // =========================
              // HERO (Avatar + Lottie)
              // =========================
              IslamicHeroSection(),

              SizedBox(height: 32),

              // =========================
              // FEATURE INTRO
              // =========================
              IslamicTitleSection(
                title: 'Why Structured Learning?',
                subtitle:
                    'A guided system designed to help you learn with clarity and consistency',
              ),

              SizedBox(height: 16),

              // =========================
              // AUTO-SCROLLING CAROUSEL
              // =========================
              IslamicFeatureCarousel(),

              SizedBox(height: 40),

              // =========================
              // BENEFITS SECTION
              // =========================
              IslamicTitleSection(
                title: 'What You Will Gain',
                subtitle:
                    'Everything you need to stay motivated and complete your learning journey',
              ),

              SizedBox(height: 16),

              // (Uses your existing benefit widgets / lists)
              // _BenefitsList(),

              SizedBox(height: 40),

              // =========================
              // FREE VS STRUCTURED
              // =========================
              IslamicTitleSection(
                title: 'Free vs Structured Learning',
                subtitle:
                    'Your free library stays forever — structured learning adds guidance',
              ),

              SizedBox(height: 16),

              // ComparisonCard(),

              SizedBox(height: 36),

              // =========================
              // TRIAL INFO
              // =========================
              // TrialExplanation(),

              SizedBox(height: 120), // space for bottom CTA
            ],
          ),
        ),
      ),

      // =========================
      // STICKY CTA
      // =========================
      bottomNavigationBar: _BottomCTA(),
    );
  }
}

class IslamicHeroSection extends StatelessWidget {
  const IslamicHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0E7A57),
            const Color(0xFF1E9E74),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Avatar + Lottie
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              Lottie.asset(
                'assets/lottie/islamic_book.json',
                height: 140,
                repeat: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Learn Islam\nWith Clarity & Consistency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Guided courses • Daily lessons • Certificates',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.85),
            ),
          ),

          const SizedBox(height: 14),

          _TrialBadgeIslamic(),
        ],
      ),
    );
  }
}

class _TrialBadgeIslamic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '☪ 7-Day Free Trial • No Payment Required',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B4E16),
        ),
      ),
    );
  }
}

class IslamicFeatureCarousel extends StatelessWidget {
  const IslamicFeatureCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureCarousel(
      items: const [
        IslamicCarouselItem(
          lottie: 'assets/animations/learning_path.json',
          title: 'የተዋቀሩ ደርሶች',
          description: 'በክፍል የተከፋፈለ፣ ደረጃ በደረጃ መማር የሚያስችሎ።',
        ),
        IslamicCarouselItem(
          lottie: 'assets/animations/audio_lessons.json',
          title: 'የእለታዊ የድምፅ ትምህርቶች እና ኪታብ',
          description: 'ግልጽ በሆነ የድምጽ ማብራሪያ እና ኪታብ በማንኛውም ጊዜ መማር የሚያስችሎ።',
        ),
        IslamicCarouselItem(
          lottie: 'assets/animations/quiz.json',
          title: 'ዕለታዊ ጥያቄዎች',
          description: 'ከእያንዳንዱ ትምህርት በኋላ በአጭር ጥያቄዎች መማሮን የሚያጠናክሩበት።',
        ),
        IslamicCarouselItem(
          lottie: 'assets/animations/Questions.json',
          title: 'ሳምንታዊ እና ወርሃዊ ፈተናዎች',
          description: 'በሳምንታዊ ጥየቄዎች እና የመጨረሻ ፈተናዎች እድገትዎን የሚከታተሉበት።',
        ),
        IslamicCarouselItem(
          lottie: 'assets/animations/winnerBadge.json',
          title: 'የምስክር ወረቀቶች',
          description: 'ደርሶቹን ከጨረሱ በኋላ የምስክር ወረቀት የሚያገኙበት።',
        ),
        IslamicCarouselItem(
          lottie: 'assets/animations/Streak.json',
          title: 'ኢስቲቃማ ወይም ፅናት',
          description: 'በየቀኑ በፅናት እንደማሩ የሚያስችሎ።',
        ),
        IslamicCarouselItem(
          lottie: 'assets/animations/confusion.json',
          title: 'ጥያቄና መልስ',
          description: 'ከደርሱ ግር ያሎትን የሚጠይቁበት፣ ምላሽ የሚያገኙበት።',
        ),
      ],
    );
  }
}

class IslamicCarouselCard extends StatelessWidget {
  final IslamicCarouselItem item;

  const IslamicCarouselCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                item.lottie,
                height: 80,
                repeat: true,
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withAlpha(200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IslamicCarouselItem {
  final String lottie;
  final String title;
  final String description;

  const IslamicCarouselItem({
    required this.lottie,
    required this.title,
    required this.description,
  });
}

class IslamicTitleSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const IslamicTitleSection({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF0E7A57),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class FeatureCarousel extends StatefulWidget {
  final List<IslamicCarouselItem> items;
  const FeatureCarousel({super.key, required this.items});

  @override
  State<FeatureCarousel> createState() => _FeatureCarouselState();
}

class _FeatureCarouselState extends State<FeatureCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _currentIndex = (_currentIndex + 1) % widget.items.length;
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }

  void onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), () {
      _currentIndex = (_currentIndex + 1) % widget.items.length;
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, index) {
              final item = widget.items[index];
              return IslamicCarouselCard(item: item);
            },
          ),
        ),
        const SizedBox(height: 12),
        _CarouselIndicators(
          count: widget.items.length,
          activeIndex: _currentIndex,
        ),
      ],
    );
  }
}

class _CarouselIndicators extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _CarouselIndicators({
    required this.count,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: index == activeIndex ? 22 : 6,
          decoration: BoxDecoration(
            color: index == activeIndex ? Colors.green : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              // width: double.infinity,
              // height: 48,
              child: BouncyElevatedButton(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Navigate to subscription / trial flow
                  },
                  child: const Text(
                    'Start 7-Day Free Trial',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Continue with free library
              },
              child: const Text('Continue with Free Library'),
            ),
          ],
        ),
      ),
    );
  }
}
