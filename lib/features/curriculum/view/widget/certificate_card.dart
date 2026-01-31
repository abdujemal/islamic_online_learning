import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/curriculum_score.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificateCard extends ConsumerStatefulWidget {
  final CurriculumScore? curriculumScore;
  const CertificateCard({
    super.key,
    required this.curriculumScore,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CertificateCardState();
}

class _CertificateCardState extends ConsumerState<CertificateCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ሰርተፍኬት",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (widget.curriculumScore == null)
                        Text(
                          "ደርሶቹን ሙሉ ለሙሉ ይጨርሱና ሰርተፍኬትዎን ይውሰዱ!",
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              // fontSize: 18,
                              ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 7,
                ),
                child: Image.asset(
                  "assets/certificate2.png",
                  fit: BoxFit.fill,
                ),
              ),
              if (widget.curriculumScore != null &&
                  widget.curriculumScore!.certificateUrl != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final uri =
                            Uri.parse(widget.curriculumScore!.certificateUrl!);
                        // if (await canLaunchUrl(uri)) {
                        try {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } catch (err) {
                          toast(
                            "could not launch. e: $err",
                            ToastType.error,
                            context,
                          );
                          print("could not launch. e: $err");
                        }
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                      ),
                      child: Text("ዳውንሎድ"),
                    ),
                  ),
                ),
              if (widget.curriculumScore != null &&
                  widget.curriculumScore!.certificateUrl == null)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: .5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "እየተዘጋጀ ነው...",
                      style: TextStyle(
                        // fontSize: 14,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.curriculumScore == null)
            Positioned(
              right: 10,
              top: 7,
              child: Icon(Icons.lock_outline),
            ),
          if (widget.curriculumScore == null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme == ThemeMode.light
                      ? Colors.white60
                      : Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
