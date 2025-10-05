import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// extension StateExt<T extends StatefulWidget> on State<T> {
//   void toast(String message, {Key? textKey}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, key: textKey),
//         duration: const Duration(milliseconds: 250),
//       ),
//     );
//   }
// }

// extension PlayerStateIcon on PlayerState {
//   IconData getIcon() {
//     return this == PlayerState.
//         ? Icons.play_arrow
//         : (this == PlayerState.paused
//             ? Icons.pause
//             : (this == PlayerState.stopped ? Icons.stop : Icons.stop_circle));
//   }
// }

Color userIdToColor(String id) {
  int hash = 0;
  for (int i = 0; i < id.length; i++) {
    hash = id.codeUnitAt(i) + ((hash << 5) - hash);
  }

  // Map hash to a hue value between 0–360
  final double hue = (hash % 360).toDouble();

  // Fixed saturation & lightness
  const double saturation = 70.0; // %
  const double lightness = 50.0; // %

  // Dart’s HSLColor uses [0–1] for s & l, so convert
  return HSLColor.fromAHSL(
    1.0, // alpha
    hue,
    saturation / 100,
    lightness / 100,
  ).toColor();
}
