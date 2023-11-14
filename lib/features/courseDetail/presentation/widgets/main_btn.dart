// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';

class MainBtn extends ConsumerStatefulWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  const MainBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainBtnState();
}

class _MainBtnState extends ConsumerState<MainBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: 250,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(160),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon != null
                ? Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 30,
                  )
                : const SizedBox(),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
