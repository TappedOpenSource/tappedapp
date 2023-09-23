import 'package:flutter/material.dart';

class MarketingOption extends StatelessWidget {
  const MarketingOption({
    required this.title,
    this.disabled = false,
    this.onTap,
    super.key,
  });

  final String title;
  final void Function()? onTap;
  final bool disabled;

  Widget get _buildMarketingOption => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 48,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return switch (disabled) {
      false => _buildMarketingOption,
      true => Stack(
          children: [
              _buildMarketingOption,
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
    };
  }
}
