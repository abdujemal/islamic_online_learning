import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  Future saveProfile() async {
    ref.read(authNotifierProvider.notifier).updateMyInfo(
          context,
          _nameController.text.trim(),
          int.parse(_ageController.text.trim()),
        );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(authNotifierProvider).user;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.phone;
        _ageController.text =
            "${(DateTime.now().difference(user.dob).inDays / 365).floor()}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
      
              TextFormField(
                controller: _nameController,
                // focusNode: _nameFocusNode,
                decoration: const InputDecoration(
                  labelText: "ስም",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "ስምዎን ያስገቡ" : null,
              ),
      
              const SizedBox(height: 15),
      
              TextFormField(
                controller: _emailController,
                // focusNode: _nameFocusNode,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "ኢሜል",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "ኢሜል ያስገቡ" : null,
              ),
      
              const SizedBox(height: 15),
      
              TextFormField(
                controller: _ageController,
                // focusNode: _ageFocusNode,
                decoration: const InputDecoration(
                  labelText: "እድሜ",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "እድሜዎን ያስገቡ";
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0) {
                    return "ትክክለኛ እድሜዎን ያስገቡ";
                  }
                  return null;
                },
              ),
      
              const SizedBox(height: 15),
      
              const SizedBox(height: 30),
      
              // 💾 Save Button
              SizedBox(
                width: double.infinity,
                child: Consumer(builder: (context, ref, _) {
                  final isSaving = ref.watch(authNotifierProvider).isUpdating;
                  return ElevatedButton(
                    onPressed: isSaving ? null : saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
