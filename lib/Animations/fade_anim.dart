import 'package:flutter/material.dart';

class SlideFadeAnimation extends StatelessWidget {
  final double animationValue;
  final Widget child;

  const SlideFadeAnimation({
    required this.animationValue,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 1, end: animationValue),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * MediaQuery.of(context).size.height),
          child: Opacity(
            opacity: 1 - value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
