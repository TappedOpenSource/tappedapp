import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LogoWave extends StatelessWidget {
  const LogoWave({
    this.height = 200,
    this.width = 200,
    super.key,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: const RiveAnimation.asset(
        'assets/loading_logo.riv',
      ),
    );
  }
}
