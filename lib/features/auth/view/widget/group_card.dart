import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/translations.dart';
import 'package:islamic_online_learning/features/auth/model/group.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

class GroupCard extends ConsumerStatefulWidget {
  final Group group;
  final VoidCallback onJoin;
  const GroupCard({super.key, required this.group, required this.onJoin});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupCardState();
}

class _GroupCardState extends ConsumerState<GroupCard> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerNotifierProvider);
    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).chipTheme.backgroundColor ?? Colors.grey,
          ),
        ),
      ),
      child: Row(
        spacing: 20,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(13),
            child: Icon(
              Icons.group,
              size: 30,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ስም: ${widget.group.name}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "ሙጣለዓ ቀን፡ ${Translations.get(widget.group.discussionDay)}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "ሙጣለዓ ሰአት፡ ${Translations.get(widget.group.discussionTime)}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "አባላት፡ ${widget.group.members}",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.onJoin,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              // minimumSize: const Size(80, 56),
            ),
            child: state.isSaving
                ? CircularProgressIndicator(
                    color: whiteColor,
                  )
                : const Text("ተቀላቀል"),
          ),
        ],
      ),
    );
  }
}
