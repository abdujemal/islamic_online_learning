import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/auth/view/pages/certificates_page.dart';
import 'package:islamic_online_learning/features/auth/view/pages/confusions_page.dart';
import 'package:islamic_online_learning/features/auth/view/pages/data_management_page.dart';
import 'package:islamic_online_learning/features/auth/view/pages/edit_profile_page.dart';
import 'package:islamic_online_learning/features/auth/view/widget/hijri_streak_calender_dialog.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/aboutus.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/payments/view/pages/payments_page.dart';
import 'package:islamic_online_learning/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountTab extends ConsumerStatefulWidget {
  const AccountTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountTabState();
}

class _AccountTabState extends ConsumerState<AccountTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    if (authState.user == null) {
      return SizedBox();
    }

    final currentUser = authState.user!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),

            // ⭐ Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: userIdToColor(currentUser.name),
                    child: Text(
                      currentUser.name[0].toUpperCase(),
                      style: const TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentUser.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser.phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildStreakCard(theme, currentUser),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ⭐ Section Title
            Text(
              "Account Settings",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // ⭐ Settings Cards
            _buildSettingItem(
              icon: Icons.account_circle,
              title: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.question_answer,
              title: "Confusion Messages",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfusionsPage(),
                  ),
                );
              },
            ),

            _buildSettingItem(
              icon: Icons.payment,
              title: "Payments",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentsPage(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.card_membership_rounded,
              title: "My Certificates",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CertificatesPage(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.security,
              title: "Privacy Policy",
              onTap: () async {
                try {
                  await launchUrl(Uri.parse(privacyPolicyUrl));
                } catch (e) {
                  toast("የግላዊነት ፖሊሲን መክፈት አልተቻለም", ToastType.error, context);
                }
              },
            ),
            _buildSettingItem(
              icon: Icons.analytics_rounded,
              title: "Data Management",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DataManagementPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ⭐ Support Section
            Text(
              "Support",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // _buildSettingItem(
            //   icon: Icons.question_mark,
            //   title: "Help Center",
            //   onTap: () {},
            // ),
            _buildSettingItem(
              icon: Icons.info,
              title: "About",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AboutUs(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // ⭐ Logout button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logout();
                ref.read(menuIndexProvider.notifier).update((state) => 1);
              },
              child: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(ThemeData theme, User currentUser) {
    return FutureBuilder(
        future: ref.read(authServiceProvider).getUsersStreakNum(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.data != null) {
              currentUser = currentUser.copyWith(numOfStreaks: snap.data);
              print(snap.data);
            }
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ⭐ Islamic Lottie Streak Animation
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Lottie.asset(
                        'assets/animations/Streak.json',
                        repeat: true,
                        animate: currentUser.numOfStreaks == 0 ? false : true,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Streak",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${currentUser.numOfStreaks} Days",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    // final rests =
                    //     ref.read(assignedCoursesNotifierProvider).rests;
                    // showDialog(
                    //   context: context,
                    //   builder: (_) => HijriStreakCalenderDialog(
                    //     rests: rests,
                    //     discussionWDay:
                    //         getWeekDayFromText(currentUser.group.discussionDay),
                    //   ),
                    // );
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: primaryColor,
                    size: 40,
                  ),
                )
              ],
            ),
          );
        });
  }

  int getWeekDayFromText(String text) {
    switch (text) {
      case "Friday":
        return 5;
      case "Saturday":
        return 6;
      default:
        return 7;
      // throw Exception("no days");
    }
  }

  // Reusable Setting Tile
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, size: 26),
        title: Text(title),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
