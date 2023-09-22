import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

extension StateExt<T extends StatefulWidget> on State<T> {
  void toast(String message, {Key? textKey}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, key: textKey),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}

extension PlayerStateIcon on PlayerState {
  IconData getIcon() {
    return this == PlayerState.playing
        ? Icons.play_arrow
        : (this == PlayerState.paused
            ? Icons.pause
            : (this == PlayerState.stopped ? Icons.stop : Icons.stop_circle));
  }
}
