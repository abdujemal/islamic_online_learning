import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
// import 'package:islamic_online_learning/features/curriculum/view/widget/curriculum_list.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  @override
  Widget build(BuildContext context) {
    // final showCurriculumList = ref.watch(showCurriculumProvider);
    // if (showCurriculumList) {
    //   return CurriculumList(onBack: () {
    //     ref.read(showCurriculumProvider.notifier).update((state) => false);
    //   });
    // }
    return Expanded(
      child: Scaffold(
        // backgroundColor: Colors.white,
        bottomNavigationBar: _BottomCTA(
          onStartTrial: () {
            ref.read(showCurriculumProvider.notifier).update((state) => true);
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSection(),
                const SizedBox(height: 24),
                _TrustSection(),
                const SizedBox(height: 32),
                _TitleSection(title: 'ከደርሶች ስብስብ ወደ ተዋቀሩ ደርሶች'),
                const SizedBox(height: 12),
                const Text(
                  'የእኛ መተግበሪያ ሲጀመር የደርሶች ቤተ-መፅሃፍት ነበር። '
                  'አሁን እርስዎን ለመርዳት የተዋቀሩ የመማሪያ መንገዶችን ስናስተዋውቅ በደስታ ነው።'
                  '\nበፅናት ይማሩ፣ እውቀትዎን ይፈትሹ እና ደረጃ በደረጃ ያሳድጉ።',
                  // 'Our app began as a rich Islamic library. '
                  // 'Now, we’ve introduced structured learning paths to help you '
                  // 'stay consistent, test your knowledge, and grow step by step.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 32),
                _TitleSection(title: 'ከድሮው በምን ይለያል'),
                const SizedBox(height: 16),
                IslamicFeatureCarousel(),
                
                const SizedBox(height: 32),
                _TitleSection(title: 'ነፃ vs የተዋቀሩ ደርሶች'),
                const SizedBox(height: 16),
                _ComparisonCard(),
                const SizedBox(height: 32),
                _TrialInfo(),
                const SizedBox(height: 80), // space for CTA
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final String title;
  // final String? subtitle;

  const _TitleSection({
    required this.title,
    // this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        // if (subtitle != null) ...[
        //   const SizedBox(height: 6),
        //   Text(
        //     subtitle!,
        //     style: const TextStyle(
        //       fontSize: 14,
        //       color: Colors.black87,
        //     ),
        //   ),
        // ],
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "ዒልምን ደረጃ በደረጃና በቀላሉ ይማሩ",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12),
        HadithMotivationCard(),
        SizedBox(height: 12),
        Text(
          'የተዋቀሩ ደርሶች፣ ዕለታዊ ትምህርቶች፣ ጥያቄዎች እና የምስክር ወረቀቶች'
          ' ያለማቋረጥ እና ግልጽነት ባለው መልኩ እንዲማሩ ለመርዳት የተነደፈ።',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
        _TrialBadge(),
      ],
    );
  }
}

class _TrialBadge extends StatelessWidget {
  const _TrialBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '🎁 የ7-ቀን ነጻ ሙከራ • ምንም ክፍያ አያስፈልግም',
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TrustSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.verified, color: Colors.green),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'በ80,000+ ተማሪዎች የታመነ • 1,200+ ነፃ ኮርሶች',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

final showCurriculumProvider = StateProvider<bool>((ref) {
  return false;
});

class _ComparisonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      // color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ሁሌ ነፃ የሆነው',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text('• 1,200+ ያልተዋቀሩ ኮርሶች\n• ኪታብ እና ኦዲዮ ትምህርቶች\n• ለሁሉም ከፍት የሆነ'),
            Divider(height: 24),
            Text(
              'የተዋቀሩ ደርሶች ያለው',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              '• ለፅናት የሚያግዞ\n• የተዋቀሩ ደርሶች\n• ጥያቄዎች & ፈተናዎች\n• የምስክር ወረቀቶች\n• ጥያቄዎ የሚመለስበት',
            ),
          ],
        ),
      ),
    );
  }
}

class _TrialInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'ለ7 ቀናት በነጻ የተዋቀሩ ደርሶችን መማር ይሞክሩ። '
      'ሁሉንም ነፃ ኮርሶች መጠቀም ይችላሉ '
      'ለደንበኝነት ባይመዘገቡም።',
      style: TextStyle(fontSize: 14),
    );
  }
}

class _BottomCTA extends ConsumerStatefulWidget {
  final VoidCallback onStartTrial;
  const _BottomCTA({required this.onStartTrial});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomCTAState();
}

class _BottomCTAState extends ConsumerState<_BottomCTA> {
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
                  onPressed: widget.onStartTrial,
                  child: const Text(
                    'የ7-ቀን ነጻ ሙከራ ይጀምሩ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(menuIndexProvider.notifier).update((state) => 1);
              },
              child: const Text('በነጻው የደርስ ቤተ-መጽሐፍት ይቀጥሉ'),
            ),
          ],
        ),
      ),
    );
  }
}

class HadithMotivationCard extends StatelessWidget {
  const HadithMotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0E7A57).withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative icon
          Row(
            children: const [
              Icon(
                Icons.auto_stories,
                color: Color(0xFF0E7A57),
              ),
              SizedBox(width: 8),
              Text(
                'ሐዲስ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Hadith text
          const Text(
            '“እውቀትን ፍለጋ መንገድን የተጓዘ ሰው '
            "አላህ ወደ ጀነት የሚወስደውን መንገድ ያቅልለታል።”",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          // Source
          Text(
            '— ሶሂህ ሙስሊም',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
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