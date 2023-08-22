import 'package:flutter/material.dart';

class ClaimChip extends StatelessWidget {
  const ClaimChip({
    required this.claim,
    super.key,
  });

  final String claim;
  Color get color => switch (claim) {
        'basic' || 'starter' => Colors.red,
        'pro' || 'premium' => Colors.green,
        'business' => Colors.blue,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        claim,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
