import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import "../widget/otp_field.dart";
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

class VerifyOtpPage extends ConsumerStatefulWidget {
  final String phone;
  const VerifyOtpPage({
    super.key,
    required this.phone,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  // InputDecoration _inputDecoration(String label) {
  //   return InputDecoration(
  //     labelText: label,
  //     filled: true,
  //     fillColor: Colors.grey.shade100,
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide.none,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("ኮዱን ያረጋግጡ", ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              "ኮዱን ያስገቡ",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "ወደ ${emailBlopper(widget.phone)} ባለ 6 አሃዝ ኮድ ልከናል።",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            OtpField(
              length: 6,
              onCompleted: (v) {
                _otpController.text = v;
              },
            ),
            // TextField(
            //   controller: _otpController,
            //   decoration: _inputDecoration("ኮድ"),
            //   keyboardType: TextInputType.number,
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(signInNotifierProvider.notifier).verifyOtp(
                      widget.phone,
                      _otpController.text,
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
                  : const Text("አረጋግጥ"),
            ),
          ],
        ),
      ),
    );
  }
}
