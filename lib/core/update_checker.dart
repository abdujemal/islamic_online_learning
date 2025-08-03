import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker extends StatefulWidget {
  final Widget child;

  const UpdateChecker({super.key, required this.child});

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  @override
  void initState() {
    super.initState();
    checkForCustomUpdate();
  }

  Future<void> checkForCustomUpdate() async {
    try {
      // Replace with your actual API endpoint
      final response =
          await http.get(Uri.parse('https://ilmfelagi.com/api/app-version'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['latest_version'];
        final forceUpdate = data['force_update'];
        final playstoreUrl = data['playstore_url'];

        final PackageInfo info = await PackageInfo.fromPlatform();
        final currentVersion = info.version;

        if (_isVersionLower(currentVersion, latestVersion) &&
            forceUpdate == true) {
          showUpdateDialog(playstoreUrl);
        }
      }
    } catch (e) {
      print("Update check failed: $e");
    }
  }

  bool _isVersionLower(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || currentParts[i] < latestParts[i])
        return true;
      if (currentParts[i] > latestParts[i]) return false;
    }

    return false;
  }

  void showUpdateDialog(String playstoreUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, // force update

      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text("Update Required"),
          content: const Text(
              "A new version of the app is available. Please update to continue."),
          actions: [
            TextButton(
              child: const Text("Update Now"),
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(playstoreUrl))) {
                  launchUrl(Uri.parse(playstoreUrl),
                      mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
