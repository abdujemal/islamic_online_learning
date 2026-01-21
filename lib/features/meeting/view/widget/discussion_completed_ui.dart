import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
// import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_notifier.dart';

class DiscussionCompletedUi extends ConsumerStatefulWidget {
  // final ExamData? examData;
  const DiscussionCompletedUi({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscussionCompletedUiState();
}

class _DiscussionCompletedUiState extends ConsumerState<DiscussionCompletedUi> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F2027) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Circle
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : const Color(0xFFE3F6ED),
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.1),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ],
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: primaryColor,
                    // isDark
                    //     ? Colors.greenAccent.shade100
                    //     : Colors.green.shade600,
                    size: 90,
                  ),
                ),

                const SizedBox(height: 35),

                // Title
                Text(
                  "ውይይቱ ተጠናቀቀ",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.grey.shade900,
                  ),
                ),

                const SizedBox(height: 16),

                // Quote
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    isDark
                        ? "“እውቀትን ለመፈለግ የሚወስዳቸው እያንዳንዱ እርምጃ ወደ አላህ ብርሃን ያቃርብዎታል።”"
                        : "“እውቀትን መፈለግ ወደ ጀነት የሚወስድ መንገድ ነው።”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Divider
                Container(
                  width: 130,
                  height: 2,
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                ),

                const SizedBox(height: 25),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "የዛሬው የቡድን ውይይት ተጠናቋል።\n"
                    "ጀዛከላሁ ኸይረን በቅንነት ለመሳተፍዎ።",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: isDark
                          ? Colors.white.withOpacity(0.85)
                          : Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "የሰሩትን በሙሉ ማስረከብ እንዳይረሱ!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: isDark
                          ? Colors.white.withOpacity(0.85)
                          : Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Button
                Consumer(builder: (context, ref, _) {
                  final isSubmitting = ref.watch(isSubmittingProvider);
                  if (isSubmitting) {
                    return CircularProgressIndicator(
                      color: primaryColor,
                    );
                  }
                  return BouncyElevatedButton(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isDark ? 0 : 2,
                      ),
                      onPressed: () async {
                        await ref
                            .read(voiceRoomNotifierProvider.notifier)
                            .submitDiscussionTask(ref);
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => MainPage(),
                        //   ),
                        //   (_) => false,
                        // );
                      },
                      child: const Text(
                        "አስረክብ ና ውጣ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
