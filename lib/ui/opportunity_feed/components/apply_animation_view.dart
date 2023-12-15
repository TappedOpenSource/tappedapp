import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';

class ApplyAnimationView extends StatelessWidget {
  const ApplyAnimationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          LogoWave(
            height: 100,
            width: 100,
          ),
          Text(
            'easy applying with tappedai',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
