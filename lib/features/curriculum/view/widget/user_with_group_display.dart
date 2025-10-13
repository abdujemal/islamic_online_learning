import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/utils.dart';

class UserWithGroupDisplay extends ConsumerStatefulWidget {
  final User user;
  const UserWithGroupDisplay({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserWithGroupDisplayState();
}

class _UserWithGroupDisplayState extends ConsumerState<UserWithGroupDisplay> {
  @override
  Widget build(BuildContext context) {
    final members = widget.user.group.members!;
    final remaining = (5 - members.length).clamp(0, 5);
    final themeMode = ref.watch(themeProvider);

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  ref
                      .read(authNotifierProvider.notifier)
                      .checkIfTheCourseStarted(ref);
                },
                icon: Icon(Icons.refresh),
              ),
            ),
            // const SizedBox(height: 10),
            // Cute icon
            CircleAvatar(
              radius: 45,
              backgroundColor: primaryColor[50],
              child: const Icon(
                Icons.groups_rounded,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              "ቂርአት በቅርቡ ይጀምራል!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeMode == ThemeMode.light
                      ? primaryColor[900]
                      : whiteColor),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Text(
              "ቡድንዎን እያዘጋጀን ነው።\nእባክዎ 5 አባላት እስክንደርስ ይጠብቁ።",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: //Theme.of(context).chipTheme.backgroundColor ??
                    themeMode == ThemeMode.light
                        ? Colors.grey[700]
                        : Color.fromARGB(255, 196, 196, 196),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            // Progress bar
            LinearProgressIndicator(
              value: members.length / 5,
              backgroundColor: Colors.grey[300],
              color: primaryColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text(
              "${members.length}/5 ተቀላቅሏል • $remaining እየጠበቅን ነው።",
              style: TextStyle(
                color: themeMode == ThemeMode.light
                    ? Colors.grey[600]
                    : Color.fromARGB(255, 196, 196, 196),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // Members list
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          child: Text(
                            "የቡድን ስም፡ ${widget.user.group.name}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 4,
                          ),
                          itemCount: members.length,
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).cardColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    userIdToColor(members[index].id),
                                child: Text(
                                  members[index].name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                members[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Polite closing message
            Text(
              "ለትዕግስትዎ እናመሰግናለን \n5 አባላት እንደሞላ እንጀምራለን።",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeMode == ThemeMode.light
                    ? Colors.grey[600]
                    : Color.fromARGB(255, 196, 196, 196),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
