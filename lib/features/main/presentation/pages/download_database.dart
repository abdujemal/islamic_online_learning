import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/core/update_checker.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/main_btn.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants.dart';

class DownloadDatabase extends ConsumerStatefulWidget {
  const DownloadDatabase({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DownloadDatabaseState();
}

class _DownloadDatabaseState extends ConsumerState<DownloadDatabase> {
  double progress = 0;
  bool isDownloading = false;
  CancelToken cancelToken = CancelToken();

  int? dbSize;

  Future<void> downloadDb() async {
    if (dbSize == null) return;

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      isDownloading = false;
      setState(() {});
      toast("እባክዎ ኢንተርኔት ያብሩ!", ToastType.error, context);
      return;
    }

    isDownloading = true;
    setState(() {});

    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}$dbPath';

    await resumableDownload(
      url: databaseUrl,
      savePath: path,
      cancelToken: cancelToken,
      onProgress: (received, total) {
        progress = (received / total) * 100;
        setState(() {});
      },
      onDone: () async {
        isDownloading = false;
        setState(() {});
        toast("በተሳካ ሁኒታ ዳውንሎድ ተደርጓል!", ToastType.success, context);

        await DatabaseHelper().initializeDatabase();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
            (route) => false,
          );
        }
      },
      onError: (e) async {
        isDownloading = false;
        setState(() {});
        toast(e.toString(), ToastType.error, context);
        print(e);
      },
    );
  }

  Future<int?> getFileSize(String url) async {
    final request = await HttpClient().headUrl(Uri.parse(url));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      final contentLength = response.contentLength;
      return contentLength;
    }
    throw Exception('Failed to get audio file size');
  }

  @override
  void initState() {
    super.initState();

    getFileSize(databaseUrl).then((value) {
      setState(() {
        dbSize = value;
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    cancelToken.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return UpdateChecker(
      child: PopScope(
        canPop: !isDownloading,
        onPopInvoked: (v) {
          if (!v) {
            cancelToken.cancel();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ዳታዎችን ዳውንሎድ ማድረግያ"),
          ),
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg1.png'),
                  fit: BoxFit.fill,
                  opacity: 0.6,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ሁሉንም ደርሶች መጠቀም እንዲያስችሎ የሁሉም ደርሶች ዳታዎች ማውረድ ይኖርቦታል።",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    dbSize == null
                        ? const Text("...")
                        : Text("የዳታዎቹ መጠን: ${formatFileSize(dbSize!)}"),
                    const SizedBox(
                      height: 15,
                    ),
                    isDownloading
                        ? Column(
                            children: [
                              LinearProgressIndicator(
                                value: progress / 100,
                                color: primaryColor,
                                backgroundColor: primaryColor.withOpacity(0.2),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${progress.toStringAsFixed(2)}% "),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  progress = 0;
                                  setState(() {});
                                  cancelToken.cancel();
                                },
                                child: const Text(
                                  "አቁም",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          )
                        : MainBtn(
                            icon: Icons.download,
                            title: "ዳውንሎድ",
                            onTap: () async {
                              cancelToken = CancelToken();
                              await downloadDb();
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
