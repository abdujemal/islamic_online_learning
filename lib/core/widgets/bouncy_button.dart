import 'package:flutter/material.dart';

class BouncyElevatedButton extends StatefulWidget {
  final Widget child;
  final double scale;
  const BouncyElevatedButton({
    super.key,
    required this.child,
    this.scale =  1.03,
  });

  @override
  State<BouncyElevatedButton> createState() => _BouncyElevatedButtonState();
}

class _BouncyElevatedButtonState extends State<BouncyElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 0.96, end: widget.scale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _controller.repeat(reverse: true); // 🔥 keeps bouncing forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
