import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TelegramWaveform extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final double barWidth;
  final double barSpacing;
  final int barCount;
  final double maxHeight;

  /// Smaller = slower (recommended: 80–180 ms)
  final int updateSpeedMs;

  const TelegramWaveform({
    super.key,
    required this.isPlaying,
    this.color = Colors.blue,
    this.barWidth = 3,
    this.barSpacing = 2,
    this.barCount = 20,
    this.maxHeight = 30,
    this.updateSpeedMs = 120, // << control speed here
  });

  @override
  State<TelegramWaveform> createState() => _TelegramWaveformState();
}

class _TelegramWaveformState extends State<TelegramWaveform>
    with SingleTickerProviderStateMixin {
  List<double> heights = [];
  Ticker? _ticker;
  int _lastUpdateTime = 0;

  @override
  void initState() {
    super.initState();

    heights = List.generate(
        widget.barCount, (_) => Random().nextDouble() * widget.maxHeight);

    _ticker = Ticker(_tick);

    if (widget.isPlaying) _ticker!.start();
  }

  void _tick(Duration elapsed) {
    final now = elapsed.inMilliseconds;

    // Only update when updateSpeedMs passed
    if (now - _lastUpdateTime < widget.updateSpeedMs) return;
    _lastUpdateTime = now;

    if (widget.isPlaying) {
      setState(() {
        heights = List.generate(widget.barCount,
            (_) => Random().nextDouble() * widget.maxHeight);
      });
    }
  }

  @override
  void didUpdateWidget(TelegramWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying) {
      if (!_ticker!.isActive) _ticker!.start();
    } else {
      _ticker!.stop();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.barSpacing / 2),
            child: AnimatedContainer(
              duration: Duration(milliseconds: widget.updateSpeedMs),
              curve: Curves.easeOut,
              width: widget.barWidth,
              height: heights[i].clamp(4, widget.maxHeight),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }),
      ),
    );
  }
}
