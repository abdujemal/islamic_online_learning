import 'package:flutter/material.dart';

class TheEnd extends StatelessWidget {
  const TheEnd({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
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
          Text("አለቀ"),
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
