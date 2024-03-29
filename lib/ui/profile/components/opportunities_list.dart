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
    final sortedOpportunities = opportunities
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            // selectedItemAnchor: SelectedItemAnchor.START,
            // onItemFocus: (index) {},
            // itemSize: MediaQuery.of(context).size.width - (96 - 8 * 2),
            scrollDirection: Axis.horizontal,
            itemCount: sortedOpportunities.length,
            itemBuilder: (context, index) {

              final opportunity = sortedOpportunities[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: OpportunityCard(
                  opportunity: opportunity,
                  onOpportunityDeleted: () => sortedOpportunities.removeAt(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
