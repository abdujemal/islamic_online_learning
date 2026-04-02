// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:islamic_online_learning/core/constants.dart';
// // import 'package:islamic_online_learning/core/lib/translations.dart';
// // import 'package:islamic_online_learning/features/auth/model/user.dart';
// import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

// class EditProfilePage extends ConsumerStatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _EditProfilePageState();
// }

// class _EditProfilePageState extends ConsumerState<EditProfilePage> {
//   final _nameController = TextEditingController();
//   // final _ageController = TextEditingController();
//   final _emailController = TextEditingController();
//   // String? _ageRange;

//   Future saveProfile() async {
//     if (_nameController.text.trim().isEmpty) {
//       toast(
//         "ስምዎን ያስገቡ",
//         ToastType.error,
//         context,
//       );
//       return;
//     }
//     // if (_ageRange == null) {
//     //   toast(
//     //     "እድሜዎን ያስገቡ",
//     //     ToastType.error,
//     //     context,
//     //   );
//     //   return;
//     // }

//     ref.read(authNotifierProvider.notifier).updateMyInfo(
//           context,
//           _nameController.text.trim(),
//         );
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       final user = ref.read(authNotifierProvider).user;
//       if (user != null) {
//         _nameController.text = user.name;
//         _emailController.text = user.phone;
//         // _ageRange = user.ageRange;
//         setState(() {
          
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ፕሮፋይሎን መቀየሪያ"),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 30),

//               TextFormField(
//                 controller: _nameController,
//                 // focusNode: _nameFocusNode,
//                 decoration: const InputDecoration(
//                   labelText: "ስም",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "ስምዎን ያስገቡ" : null,
//               ),

//               const SizedBox(height: 15),

//               TextFormField(
//                 controller: _emailController,
//                 // focusNode: _nameFocusNode,
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   labelText: "ኢሜል",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "ኢሜል ያስገቡ" : null,
//               ),

//               const SizedBox(height: 15),

//               // DropdownButtonFormField<String>(
//               //   value: _ageRange,
//               //   decoration: const InputDecoration(
//               //     labelText: "እድሜ",
//               //     border: OutlineInputBorder(),
//               //   ),
//               //   items: AgeRange.values
//               //       .toList()
//               //       .map(
//               //         (age) => DropdownMenuItem(
//               //           value: age.name,
//               //           child: Text(Translations.get(age.name)),
//               //         ),
//               //       )
//               //       .toList(),
//               //   onChanged: (value) => setState(() => _ageRange = value),
//               //   validator: (value) => value == null ? "እድሜ ይምረጡ" : null,
//               // ),

//               // const SizedBox(height: 15),

//               const SizedBox(height: 30),

//               // 💾 Save Button
//               SizedBox(
//                 width: double.infinity,
//                 child: Consumer(builder: (context, ref, _) {
//                   final isSaving = ref.watch(authNotifierProvider).isUpdating;
//                   return ElevatedButton(
//                     onPressed: isSaving ? null : saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       backgroundColor: primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: isSaving
//                         ? const CircularProgressIndicator(
//                             color: Colors.white,
//                           )
//                         : const Text(
//                             "መዝግብ",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
