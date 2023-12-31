import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  final String title;
  const ListTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(
        right: 15.0,
        left: 15.0,
        top: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}