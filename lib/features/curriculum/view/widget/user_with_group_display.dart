import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

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
            const SizedBox(height: 40),
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
                  ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              "ቡድንዎን እያዘጋጀን ነው።\nእባክዎ 5 አባላት እስክንደርስ ይጠብቁ።",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: //Theme.of(context).chipTheme.backgroundColor ??
                    Colors.grey,
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
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            // Members list
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 4),
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
                            backgroundColor: primaryColor[100],
                            child: Text(
                              members[index].name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            members[index].name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )

                    // ListView.separated(
                    //   itemCount: members.length,
                    //   separatorBuilder: (_, __) => const Divider(height: 1),
                    //   itemBuilder: (context, index) {
                    //     return ListTile(
                    //       leading: CircleAvatar(
                    //         backgroundColor: primaryColor[100],
                    //         child: Text(
                    //           members[index][0].toUpperCase(),
                    //           style: const TextStyle(
                    //             color: Colors.black87,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //       title: Text(
                    //         members[index],
                    //         style: const TextStyle(fontWeight: FontWeight.w600),
                    //       ),
                    //     );
                    //   },
                    // ),
                    ),
              ),
            ),

            const SizedBox(height: 20),

            // Polite closing message
            Text(
              "ለትዕግስትዎ እናመሰግናለን \n5 አባላት እንደሞላ እንጀምራለን።",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: //Theme.of(context).chipTheme.backgroundColor ??
                    Colors.grey,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
