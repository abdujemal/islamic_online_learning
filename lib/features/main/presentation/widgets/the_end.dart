import 'package:flutter/material.dart';

class TheEnd extends StatelessWidget {
  final String? text;
  const TheEnd({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
        bottom: 0,
        top: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              height: 10,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
          Text(text ?? "አለቀ"),
          Expanded(
            child: Divider(
              height: 10,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
        ],
      ),
    );
  }
}
