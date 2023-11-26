import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/profile/components/opportunity_card.dart';

class OpportunitiesList extends StatelessWidget {
  const OpportunitiesList({
    required this.opportunities,
    super.key,
  });

  final List<Opportunity> opportunities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opportunity = opportunities[index];
              return OpportunityCard(
                opportunity: opportunity,
              );
            },
          ),
        ),
      ],
    );
  }
}
