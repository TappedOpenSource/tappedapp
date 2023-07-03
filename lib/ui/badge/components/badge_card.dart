import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;

class BadgeCard extends StatelessWidget {
  const BadgeCard({
    required this.badge,
    required this.index,
    super.key,
  });

  final badge_model.Badge badge;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          Hero(
            tag: '${badge.imageUrl}-$index',
            child: CachedNetworkImage(
              imageUrl: badge.imageUrl,
              width: 300,
              height: 300,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            badge.name,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 24,
            ),
          ),
          Text(
            badge.description,
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
