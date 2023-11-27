import 'package:flutter/material.dart';

class Shdl extends StatefulWidget {
  const Shdl({super.key});

  @override
  State<Shdl> createState() => _ShdlState();
}

class _ShdlState extends State<Shdl> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text("Schedule")),
        body: Column(
          children: [
            Text("The Scheduler is working...."),
            const Center(
              child: Text("It worked congratulation."),
            ),
          ],
        ),
      ),
    );
  }
}
