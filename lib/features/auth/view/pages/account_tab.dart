import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/utils.dart';

class AccountTab extends ConsumerStatefulWidget {
  const AccountTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountTabState();
}

class _AccountTabState extends ConsumerState<AccountTab>
    with AutomaticKeepAliveClientMixin<AccountTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final authState = ref.watch(authNotifierProvider);
    if (authState.user == null) {
      return SizedBox();
    }
    final currentUser = authState.user!;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              backgroundColor: userIdToColor(currentUser.name),
              radius: 40,
              child: Text(
                currentUser.name[0].toUpperCase(),
                style: const TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              currentUser.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () async {
                // final pref = await ref.read(sharedPrefProvider);
                // pref.remove(PrefConsts.token);
                ref.read(authNotifierProvider.notifier).logout();
                ref.read(menuIndexProvider.notifier).update((state) => 1);
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => MainPage(),
                //   ),
                //   (v) => false,
                // );
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
