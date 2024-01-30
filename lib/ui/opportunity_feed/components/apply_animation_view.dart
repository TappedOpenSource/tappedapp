import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class ApplyAnimationView extends StatelessWidget {
  const ApplyAnimationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          const LogoWave(
            height: 100,
            width: 100,
          ),
          PremiumBuilder(
            builder: (context, claim) {
              return switch (claim) {
                None() => const Text(
                    'we just received your application, thank you for applying',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                Some() => const Text(
                    "adding your application to the top of the promoter's list as a premium user",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
