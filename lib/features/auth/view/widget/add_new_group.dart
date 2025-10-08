import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/static_datas.dart';
import 'package:islamic_online_learning/core/lib/translations.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

class AddNewGroup extends ConsumerStatefulWidget {
  final Map<String, dynamic>? userData;
  const AddNewGroup({
    super.key,
    required this.userData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewGroupState();
}

class _AddNewGroupState extends ConsumerState<AddNewGroup> {
  String? _discussionDay, _discussionTime;
  final GlobalKey<FormState> _groupKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(registerNotifierProvider);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Form(
        key: _groupKey,
        child: Column(
          spacing: 15,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "አድስ ቡድን",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(registerNotifierProvider.notifier)
                        .toggleAddingGroup();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 23,
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _discussionDay,
              decoration: const InputDecoration(
                labelText: "የሙጣለዓ ቀን",
                border: OutlineInputBorder(),
              ),
              items: StaticDatas.discussionDay
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        Translations.get(e),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _discussionDay = value),
              validator: (value) => value == null ? "የሙጣለዓ ቀን ይምረጡ" : null,
            ),
            DropdownButtonFormField<String>(
              value: _discussionTime,
              decoration: const InputDecoration(
                labelText: "የሙጣለዓ ሰዓት",
                border: OutlineInputBorder(),
              ),
              items: StaticDatas.discussionTime
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        Translations.get(e),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _discussionTime = value),
              validator: (value) => value == null ? "የሙጣለዓ ሰዓት ይምረጡ" : null,
            ),
            ElevatedButton(
              onPressed: () {
                if (_groupKey.currentState!.validate()) {
                  if (widget.userData == null) {
                    ref.read(registerNotifierProvider.notifier).setToDefault();
                  }
                  ref.read(registerNotifierProvider.notifier).register(
                        widget.userData!["age"],
                        widget.userData!["name"],
                        widget.userData!["gender"],
                        _discussionTime!,
                        _discussionDay!,
                        null,
                        widget.userData!["_previousLearnings"],
                        context,
                        ref,
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                // minimumSize: const Size(80, 56),
              ),
              child: const Text("መዝግብ"),
            ),
          ],
        ),
      ),
    );
  }
}
