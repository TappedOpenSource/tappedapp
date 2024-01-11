import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:uuid/uuid.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    required this.opportunity,
    super.key,
  });

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 56;
    return FutureBuilder(
      future: getOpImage(context, opportunity),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: cardWidth,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CupertinoActivityIndicator(),
          );
        }

        final provider = snapshot.data!;
        final uuid = const Uuid().v4();
        final heroImageTag = 'op-image-${opportunity.id}-$uuid';
        final heroTitleTag = 'op-title-${opportunity.id}-$uuid';
        return InkWell(
          onTap: () => context.push(
            OpportunityPage(
              opportunity: opportunity,
              heroImage: HeroImage(
                imageProvider: provider,
                heroTag: heroImageTag,
              ),
              titleHeroTag: heroTitleTag,
              onApply: () => context.pop(),
              onDislike: () => context.pop(),
              onDismiss: () => context.pop(),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: heroImageTag,
                child: Container(
                  width: cardWidth,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Hero(
                tag: heroTitleTag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    opportunity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
