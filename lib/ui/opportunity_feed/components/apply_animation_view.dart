import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/utils/user_claim_builder.dart';

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
          UserClaimBuilder(
            builder: (context, claim) {
              return switch (claim) {
                None() => const Text(
                    'easy applying with tappedai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                Some() => const Text(
                    "adding your info to the top of the promoter's list as a premium user",
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
