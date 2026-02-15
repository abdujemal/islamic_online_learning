import 'dart:async';

import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';


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