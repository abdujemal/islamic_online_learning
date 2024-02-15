import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RateUsDailog extends ConsumerStatefulWidget {
  const RateUsDailog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RateUsDailogState();
}

class _RateUsDailogState extends ConsumerState<RateUsDailog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("ደረጃ ይስጡን"),
      content: const Text(
          "⭐️⭐️⭐️⭐️⭐️ ዒልም ፈላጊ አፕ ከተመቾት፣ እባክዎ ትንሽ ደቂቃ ወስደው ደረጃ እና አስተያየት ይስጡን።"),
      alignment: Alignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text(
            "ሌላ ጊዜ",
          ),
        ),
        TextButton(
          onPressed: () async {
            final pref = await ref.read(sharedPrefProvider);
            pref.setBool("wantToRate", false);
            if (mounted) {
              Navigator.pop(context, true);
            }
          },
          child: const Text(
            "ይቅርብኝ",
          ),
        ),
        TextButton(
          onPressed: () async {
            final pref = await ref.read(sharedPrefProvider);
            pref.setBool("wantToRate", false);
            final url = Uri.parse(playStoreUrl);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            }
            if (mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            "እሺ!",
          ),
        ),
      ],
    );
  }
}
