import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
import 'package:islamic_online_learning/features/curriculum/view/pages/islamic_intro_page.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        // backgroundColor: Colors.white,
        bottomNavigationBar: _BottomCTA(),
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
                  style: TextStyle(fontSize: 15, ),
                ),
                const SizedBox(height: 32),
                _TitleSection(title: 'ከድሮው በምን ይለያል'),
                const SizedBox(height: 16),
                IslamicFeatureCarousel(),
                // _FeatureItem(
                //   icon: Icons.menu_book_outlined,
                //   title: 'Structured Courses',
                //   description:
                //       'Guided programs (5–10 lessons) organized by levels.',
                // ),
                // _FeatureItem(
                //   icon: Icons.headphones_outlined,
                //   title: 'Daily Audio Lessons & PDFs',
                //   description:
                //       'Learn anytime with clear audio explanations and reading material.',
                // ),
                // _FeatureItem(
                //   icon: Icons.quiz_outlined,
                //   title: 'Daily Quizzes',
                //   description:
                //       'Reinforce understanding with short quizzes after each lesson.',
                // ),
                // _FeatureItem(
                //   icon: Icons.event_note_outlined,
                //   title: 'Weekly & Monthly Exams',
                //   description:
                //       'Track progress through regular assessments and final exams.',
                // ),
                // _FeatureItem(
                //   icon: Icons.workspace_premium_outlined,
                //   title: 'Certificates',
                //   description:
                //       'Receive a certificate after completing each structured course.',
                // ),
                // _FeatureItem(
                //   icon: Icons.local_fire_department_outlined,
                //   title: 'Daily Streaks',
                //   description:
                //       'Build consistency with streaks that motivate daily learning.',
                // ),
                // _FeatureItem(
                //   icon: Icons.question_answer_outlined,
                //   title: 'Ask Questions',
                //   description: 'Ask about any lesson and receive clear guidance.',
                // ),
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
          style: TextStyle(fontSize: 16,),
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
            style: TextStyle(fontSize: 14, ),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style:  TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                    'የ7-ቀን ነጻ ሙከራ ይጀምሩ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Continue with free library
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