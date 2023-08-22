import 'package:flutter/material.dart';
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
      body: const Placeholder(),
    );
  }
}
