import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

class SignIn extends ConsumerStatefulWidget {
  final String? curriculumId;
  const SignIn({super.key, this.curriculumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      // labelStyle: TextStyle(
      //   color: primaryColor,
      // ),
      fillColor:
          Theme.of(context).chipTheme.backgroundColor ?? Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInNotifierProvider);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "እንኳን ደህና መጡ 👋",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                state.isPhoneMode ? "ለመግባት ስልክ ቁጥርዎን ያስገቡ" : "ለመግባት ኢሜልዎን ያስገቡ",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              if (state.isPhoneMode) ...[
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: "ስልክ ቁጥር",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Theme.of(context).chipTheme.backgroundColor ??
                          Colors.grey.shade100),
              
                  pickerDialogStyle: PickerDialogStyle(
                      listTileDivider: Divider(color: whiteColor)),
                  initialCountryCode: 'ET', // Ethiopia default
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return "ስልክ ቁጥር ይፃፉ";
                    }
                    if (phone.number.length < 9) {
                      return "ሙሉ ቁጥሩን ይፃፉ";
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(signInNotifierProvider.notifier).toggleMode();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "በኢሜል ይሁንልኝ",
                        style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration("ኢሜል"),
                  keyboardType: TextInputType.emailAddress,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(signInNotifierProvider.notifier).toggleMode();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "በስልክ ይሁንልኝ",
                        style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () {
                  if (state.isLoading) {
                    return;
                  }
              
                  ref.read(signInNotifierProvider.notifier).sendOtp(
                        _emailController.text,
                        widget.curriculumId,
                        context,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: state.isLoading
                    ? CircularProgressIndicator(
                        color: whiteColor,
                      )
                    : const Text("ቀጥል"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
