import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/common/opportunity_card.dart';

class OpportunitiesList extends StatelessWidget {
  const OpportunitiesList({
    required this.opportunities,
    super.key,
  });

  final List<Opportunity> opportunities;

  @override
  Widget build(BuildContext context) {
    final sortedOpportunities = opportunities
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return Column(
      children: [
        ...sortedOpportunities.map(
          (opportunity) => OpportunityCard(
            opportunity: opportunity,
            onOpportunityDeleted: () => opportunities.remove(opportunity),
          ),
        ),
      ],
    );
  }
}
