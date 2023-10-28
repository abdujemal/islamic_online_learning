// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';

class DownloadIcon extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final double progress;
  const DownloadIcon({
    super.key,
    required this.onTap,
    required this.isLoading,
    required this.progress,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadIconState();
}

class _DownloadIconState extends ConsumerState<DownloadIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? () {} : widget.onTap,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(1),
        child: widget.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: widget.progress / 100,
                    color: Colors.white,
                  ),
                ),
              )
            : const Icon(
                Icons.download,
                size: 20,
                color: whiteColor,
              ),
      ),
    );
  }
}
