import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

class DataManagementPage extends ConsumerStatefulWidget {
  const DataManagementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DataManagementPageState();
}

class _DataManagementPageState extends ConsumerState<DataManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Data Management"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm Deletion"),
                      content: const Text(
                          "Are you sure you want to delete your account and all associated data? This action cannot be undone."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final isLoading = ref.watch(authNotifierProvider).isDeleting;
                            return
                            
                             ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                              
                                ref
                                    .read(authNotifierProvider.notifier)
                                    .deleteProfile(context);
                              },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    )
                                  : const Text("Delete"),
                            );
                          }
                        ),
                      ],
                    ),
                  );
                },
                child: Text("Delete account & data"),
              )
            ],
          ),
        ));
  }
}
