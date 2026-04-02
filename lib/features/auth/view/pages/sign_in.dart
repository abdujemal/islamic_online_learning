// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl_phone_field/country_picker_dialog.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:islamic_online_learning/core/constants.dart';
// import 'package:islamic_online_learning/core/lib/translations.dart';
// import 'package:islamic_online_learning/features/auth/model/user.dart';
// import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
// import 'package:islamic_online_learning/features/curriculum/view/pages/intro_page.dart';
// // import 'package:islamic_online_learning/features/main/presentation/widgets/the_end.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SignIn extends ConsumerStatefulWidget {
//   final String? curriculumId;
//   const SignIn({super.key, this.curriculumId});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
// }

// class _SignInState extends ConsumerState<SignIn> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   String? _ageRange;
//   bool _isPrivacyPolicyAccepted = false;
//   String? curriculumId;

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       // filled: true,
//       // labelStyle: TextStyle(
//       //   color: primaryColor,
//       // ),
//       // fillColor:
//       //     Theme.of(context).chipTheme.backgroundColor ?? Colors.grey.shade100,
//       border: OutlineInputBorder(
//           // borderRadius: BorderRadius.circular(12),
//           // borderSide: BorderSide.none,
//           ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.curriculumId != null) {
//       curriculumId = widget.curriculumId;
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(signInNotifierProvider);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40),
//                 Text(
//                   "እንኳን ደህና መጡ 👋",
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   state.isPhoneMode
//                       ? "${curriculumId == null ? "ለመግባት" : "ለመመዝገብ"} ስልክ ቁጥርዎን ያስገቡ"
//                       : "${curriculumId == null ? "ለመግባት" : "ለመመዝገብ"} ኢሜልዎን ያስገቡ",
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 32),
//                 if (state.isPhoneMode) ...[
//                   IntlPhoneField(
//                     controller: _phoneController,
//                     decoration: InputDecoration(
//                         labelText: "ስልክ ቁጥር",
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         fillColor: Theme.of(context).chipTheme.backgroundColor ??
//                             Colors.grey.shade100),
          
//                     pickerDialogStyle: PickerDialogStyle(
//                         listTileDivider: Divider(color: whiteColor)),
//                     initialCountryCode: 'ET', // Ethiopia default
//                     validator: (phone) {
//                       if (phone == null || phone.number.isEmpty) {
//                         return "ስልክ ቁጥር ይፃፉ";
//                       }
//                       if (phone.number.length < 9) {
//                         return "ሙሉ ቁጥሩን ይፃፉ";
//                       }
//                       return null;
//                     },
//                   ),
//                   // Align(
//                   //   alignment: Alignment.bottomRight,
//                   //   child: GestureDetector(
//                   //     onTap: () {
//                   //       ref.read(signInNotifierProvider.notifier).toggleMode();
//                   //     },
//                   //     child: Padding(
//                   //       padding: const EdgeInsets.all(8.0),
//                   //       child: Text(
//                   //         "በኢሜል ይሁንልኝ",
//                   //         style: TextStyle(
//                   //           color: primaryColor,
//                   //           decoration: TextDecoration.underline,
//                   //           decorationColor: primaryColor,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 20),
//                 ] else ...[
//                   if (curriculumId != null)
//                     DropdownButtonFormField<String>(
//                       value: _ageRange,
//                       decoration: const InputDecoration(
//                         labelText: "እድሜ",
//                         border: OutlineInputBorder(),
//                       ),
//                       items: AgeRange.values
//                           .toList()
//                           .map(
//                             (age) => DropdownMenuItem(
//                               value: age.name,
//                               child: Text(Translations.get(age.name)),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) => setState(() => _ageRange = value),
//                       validator: (value) => value == null ? "እድሜ ይምረጡ" : null,
//                     ),
//                   if (curriculumId != null)
//                     SizedBox(
//                       height: 15,
//                     ),
//                   if (_ageRange != "Under_13")
//                     TextField(
//                       controller: _emailController,
//                       decoration: _inputDecoration("ኢሜል"),
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                   //privacy policy and terms of use link and checkbox
//                   if (_ageRange != "Under_13")
//                     Row(
//                       children: [
//                         Checkbox(
//                             value: _isPrivacyPolicyAccepted,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isPrivacyPolicyAccepted = value ?? false;
//                               });
//                             }),
//                         GestureDetector(
//                           onTap: () {
//                             // open privacy policy link
//                             // you can replace this with your own privacy policy link
//                             try {
//                               launchUrl(Uri.parse(privacyPolicyUrl));
//                             } catch (e) {
//                               toast("የግላዊነት ፖሊሲን መክፈት አልተቻለም", ToastType.error,
//                                   context);
//                             }
//                           },
//                           child: Text(
//                             "የግላዊነት ፖሊሲን",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.blue,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.blue,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           " አንብቤ ተስማምቻለሁ።",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   // Align(
//                   //   alignment: Alignment.bottomRight,
//                   //   child: GestureDetector(
//                   //     onTap: () {
//                   //       ref.read(signInNotifierProvider.notifier).toggleMode();
//                   //     },
//                   //     child: Padding(
//                   //       padding: const EdgeInsets.all(8.0),
//                   //       child: Text(
//                   //         "በስልክ ይሁንልኝ",
//                   //         style: TextStyle(
//                   //           color: primaryColor,
//                   //           decoration: TextDecoration.underline,
//                   //           decorationColor: primaryColor,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 20),
//                 ],
//                 if (_ageRange != "Under_13")
//                   ElevatedButton(
//                     onPressed: () {
//                       if (state.isLoading) {
//                         return;
//                       }
          
//                       if (!_isPrivacyPolicyAccepted) {
//                         toast("እባክዎ የግላዊነት ፖሊሲን ያንብቡና ይስማሙ!", ToastType.error,
//                             context);
//                         return;
//                       }
          
//                       if (_emailController.text.isEmpty) {
//                         toast("እባክዎ ሁሉንም መረጃዎችን ያስገቡ", ToastType.error, context);
//                         return;
//                       }

//                       if(_ageRange == null && curriculumId != null){
//                         toast("እባክዎ ሁሉንም መረጃዎችን ያስገቡ", ToastType.error, context);
//                         return;
//                       }
          
//                       ref.read(signInNotifierProvider.notifier).sendOtp(
//                             _emailController.text,
//                             curriculumId,
//                             _ageRange,
//                             context,
//                           );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       minimumSize: const Size(double.infinity, 56),
//                     ),
//                     child: state.isLoading
//                         ? CircularProgressIndicator(
//                             color: whiteColor,
//                           )
//                         : const Text("ቀጥል"),
//                   ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Row(
//                   //already have an account? sign in link
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       curriculumId == null ? "አዲስ ኖት?" : "ከዚህ በፊት ተመዝግበው ነበር?",
//                       style: TextStyle(
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyMedium
//                             ?.color
//                             ?.withAlpha(200),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         if (curriculumId != null) {
//                           setState(() {
//                             curriculumId = null;
//                           });
//                         } else {
//                           ref
//                               .read(showCurriculumProvider.notifier)
//                               .update((state) => true);
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Text(
//                         curriculumId == null ? "ይመዝገቡ" : "ይግቡ",
//                         style: TextStyle(
//                           color: primaryColor,
//                           decoration: TextDecoration.underline,
//                           decorationColor: primaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//                 // TheEnd(
//                 //   text: "OR",
//                 // ),
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 // Align(
//                 //   child: ElevatedButton(
//                 //       onPressed: () {
//                 //         ref
//                 //             .read(signInNotifierProvider.notifier)
//                 //             .signWithGoogle(context);
//                 //       },
//                 //       style: ElevatedButton.styleFrom(
//                 //         side: BorderSide(color: primaryColor),
//                 //         padding:
//                 //             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 //         foregroundColor:
//                 //             Theme.of(context).textTheme.bodyMedium?.color,
//                 //       ),
//                 //       child: Row(
//                 //         mainAxisSize: MainAxisSize.min,
//                 //         children: [
//                 //           Image.asset(
//                 //             "assets/google2.png",
//                 //             // color:  Colors.grey,
//                 //             height: 30,
//                 //             width: 30,
//                 //           ),
//                 //           SizedBox(
//                 //             width: 15,
//                 //           ),
//                 //           state.isSigningWGoogle
//                 //               ? CircularProgressIndicator()
//                 //               : Text("Sign in with Google"),
//                 //         ],
//                 //       )),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
