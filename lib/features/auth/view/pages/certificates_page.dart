import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificatesPage extends ConsumerStatefulWidget {
  const CertificatesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CertificatesPageState();
}

class _CertificatesPageState extends ConsumerState<CertificatesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(certificatesNotifierProvider.notifier).getCertificates(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("My Certificates"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ref.watch(certificatesNotifierProvider).map(
              loading: (_) => Center(
                child: CircularProgressIndicator(),
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(certificatesNotifierProvider.notifier)
                      .getCertificates(context);
                },
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _.curriculumScores.length,
                  itemBuilder: (context, i) {
                    final curriculumScore = _.curriculumScores[i];
                    return Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              color: primaryColor.withAlpha(90),
                              blurRadius: 5,
                              spreadRadius: 0.1,
                            )
                          ]),
                      child: ListTile(
                        leading: Image.asset(
                          "assets/certificate_icon.png",
                          width: 40,
                          height: 40,
                        ),
                        title: Text(curriculumScore.curriculumTitle),
                        subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: .5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "${curriculumScore.score}/${curriculumScore.outOf} ነጥብ",
                              style:
                                  TextStyle(fontSize: 10, color: primaryColor),
                            ),
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: curriculumScore.certificateUrl == null
                              ? Container(
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
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    final uri = Uri.parse(
                                        curriculumScore.certificateUrl!);
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
                    );
                  },
                ),
              ),
              empty: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("ምንም የለም"),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(certificatesNotifierProvider.notifier)
                            .getCertificates(context);
                      },
                      icon: Icon(
                        Icons.refresh,
                      ),
                    )
                  ],
                ),
              ),
              error: (_) => Center(
                child: Text(
                  _.error ?? "_",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
      ),
    );
  }
}
