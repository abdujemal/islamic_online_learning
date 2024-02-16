import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../../core/Audio Feature/playlist_helper.dart';

class AboutUs extends ConsumerStatefulWidget {
  const AboutUs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends ConsumerState<AboutUs> {
  bool showTopAudio = false;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = PlaylistHelper.audioPlayer;
    return StreamBuilder(
        stream: myAudioStream(audioPlayer),
        builder: (context, snap) {
          final state = snap.data?.sequenceState;
          final process = snap.data?.processingState;

          if (state?.sequence.isEmpty ?? true) {
            showTopAudio = false;
          }
          MediaItem? metaData = state?.currentSource?.tag;

          if (metaData != null) {
            showTopAudio = true;
          }
          if (process == ProcessingState.idle) {
            showTopAudio = false;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("ስለ መተግበሪያው"),
              bottom: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  showTopAudio ? 40 : 0,
                ),
                child: showTopAudio
                    ? CurrentAudioView(metaData as MediaItem)
                    : const SizedBox(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "ዒልም ፈላጊ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            "v 1.0.0",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                          "بـــسم اللهِ الرَّحمنِ الرَّحـيم وبـه نَستعين عونَك يا كريم"),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("""
ይህ የሞባይል መተግበሪያ፦
  - ከ40 በላይ የሱና ኡስታዞችን ደርሶች፣
  - ዘርፈ ብዙ ፈኖችን: የዐቂዳ፣ የተውሒድ፣ የመንሀጅ፣ የተፍሲር፣ የሲራ፣ የአደብ፣ የተርቢያ፣ የሐዲሥ፣ የፊቅህ፣ የነሕው፣ የሶርፍ እና የተጅዊድ ኪታቦችን፣
  - እያንዳንዱ የድምፅ ቅጂ ከሶፍት ኮፒ ጋር
  - ከ150 በላይ የኪታብ ቅጅዎችን፣ በአንድ ላይ አካቶ ይዟል።

አፑን ለአጠቃቀም ምቹ ከሚያደርጉት ነገራቶች፦
  - የፈለጉትን ደርስ በቀላሉ ለማግኘት ምልክት ማድረግ የሚያስችል፣
  - ከቅጅዎቹ መካከል መርጠው ለሌሎች ማጋራት የሚያስችል፣
  - ለእይታ አመቺ ይሆን ዘንድ የቀንና የማታ ገፅታ ያካተተ፣
  - የፅሁፍ መጠን መጨመርና መቀነስ የሚያስችል፣
  - የፈለጉትን ደርስ ‘ሰርች’ ማድረጊያ ያለው፣
  - የጀማሪ ኪታቦችን ለብቻ የሚያሳይ፣
  - የደርስ ሰአት እና ቀን አስታዋሽ (alarm) ያለው፣
  - ደርሱን አቋርጠን በሌላ ጊዜ ማዳመጥ ብንፈልግ ካቆመበት የሚጀምር፣
  - አድስ ደርስ ሲጫን መልእክት የሚቀበል ነው።

በመጨረሻም፦
  ይህ ስራችን የላቀው አላህን ፊት ብቻ ተፈልጎበት የተሰራ እንዲሆን፣ ደርሶችን ከተለያዩ የቴሌግራም ቻናሎች ላሰባሰበው፣ አፑን ላዘጋጀው፣ በዚህ ስራ ለተባበሩ፣ ይህንን ስራ ለሚያሰራጩትም፣ ለሁላችንም - አላህ: "ከኋለኞቹ ህዝቦች ዘንድ መልካም ዝናን እንዲያደርግልን" እማፀነዋለሁ። ረበና ተቀበል ሚና!!
"""),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Center(
                    child: Text("ለማንኛውም አስተያየት ወይም ጥቆማ"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final url = Uri.parse('https://t.me/AbduJKA');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        icon: const Icon(
                          Icons.telegram,
                          size: 45,
                          color: primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final url = Uri.parse('mailto:ilmfelagi@gmail.com');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        icon: const Icon(
                          Icons.email,
                          size: 45,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          );
        });
  }
}
