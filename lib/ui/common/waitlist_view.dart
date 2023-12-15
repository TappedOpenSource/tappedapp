import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/easter_egg_placeholder.dart';

class WaitlistView extends StatelessWidget {
  const WaitlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            const EasterEggPlaceholder(
              text: "you've reached your daily application quota",
            ),
            const SizedBox(height: 12),
            const Text(
              'join the waitlist to get unlimited daily opportunities!',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                // apply for the waitlist
                context.pop();
              },
              child: const Text('sign me up'),
            ),
          ],
        ),
      ),
    );
  }
}
