import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LogoWave extends StatelessWidget {
  const LogoWave({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      width: 200,
      child: RiveAnimation.asset(
        'assets/loading_logo.riv',
      ),
    );
  }
}
