import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/state/ustaz_list_notifier.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';
import '../state/provider.dart';
import 'filtered_courses.dart';

class Ustazs extends ConsumerStatefulWidget {
  const Ustazs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UstazsState();
}

class _UstazsState extends ConsumerState<Ustazs> {
  late UstazListNotifier ustazListNotifier;
  @override
  initState() {
    super.initState();
    ustazListNotifier = ref.read(ustazNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      ustazListNotifier.getUstaz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("የኡስታዞች ዝርዝር"),
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            currentAudio != null ? 40 : 0,
          ),
          child: currentAudio != null
              ? CurrentAudioView(currentAudio)
              : const SizedBox(),
        ),
      ),
      body: ref.watch(ustazNotifierProvider).map(
            initial: (_) => const SizedBox(),
            loading: (_) => ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context)
                      .chipTheme
                      .backgroundColor!
                      .withAlpha(150),
                  highlightColor: Theme.of(context).chipTheme.backgroundColor!,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Container(
                          height: 10,
                          width: 150,
                          margin: const EdgeInsets.only(right: 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            loaded: (_) => RefreshIndicator(
              onRefresh: () async {
                await ustazListNotifier.getUstaz();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _.ustazs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilteredCourses(
                              "ustaz",
                              _.ustazs[index],
                            ),
                          ),
                        );
                      },
                      title: Text(
                        _.ustazs[index],
                      ),
                      leading: Image.asset(
                        'assets/teacher_1.png',
                        height: 35,
                        width: 35,
                        color: DefaultTextStyle.of(context).style.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            empty: (_) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("ምንም የለም"),
                  IconButton(
                    onPressed: () async {
                      await ustazListNotifier.getUstaz();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  )
                ],
              ),
            ),
            error: (_) => Center(
              child: Text(_.error.messege),
            ),
          ),
    );
  }
}
