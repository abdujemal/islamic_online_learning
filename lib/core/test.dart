import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/zigzag.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 300,
              // color: Colors.amber,
              child: CustomPaint(
                foregroundPainter: RPSCustomPainter(),
                size: Size(1280, 720),
                child: Container(child: Text("askfjnf")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
