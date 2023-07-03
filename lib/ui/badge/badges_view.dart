import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge;
import 'package:intheloopapp/ui/badge/components/badge_card.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';

class BadgesView extends StatelessWidget {
  const BadgesView({
    required this.badges,
    super.key,
  });

  final List<badge.Badge> badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Badges',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: badges.length,
              itemBuilder: (context, index) {
                return BadgeCard(
                  badge: badges[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
