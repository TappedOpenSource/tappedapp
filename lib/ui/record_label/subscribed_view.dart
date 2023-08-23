import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/record_label/components/claim_chip.dart';

class SubscribedView extends StatelessWidget {
  const SubscribedView({
    required this.claim,
    super.key,
  });

  final String claim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'your AI team',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            ClaimChip(
              claim: claim,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          const Text('avatars'),
          const SizedBox(height: 16),
          CupertinoButton.filled(
            onPressed: () {
              context.read<GenerationBloc>().add(
                    const ResetGeneration(),
                  );
              context.push(
                GenerateAvatarPage(),
              );
            },
            child: const Text('generate avatar'),
          ),
        ],
      ),
    );
  }
}
