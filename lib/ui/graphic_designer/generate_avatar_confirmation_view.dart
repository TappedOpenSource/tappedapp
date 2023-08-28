import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';

class GenerateAvatarConfirmationView extends StatelessWidget {
  const GenerateAvatarConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Text('avatar being generated...'),
          Text('wait a few seconds'),
          SizedBox(height: 16),
          LogoWave(),
        ],
      ),
    );
  }
}
