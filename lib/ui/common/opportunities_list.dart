import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/common/opportunity_card.dart';
import 'package:intheloopapp/ui/opportunities/opportunities_results_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OpportunitiesList extends StatelessWidget {
  const OpportunitiesList({
    required this.opportunities,
    super.key,
  });

  final List<Opportunity> opportunities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedOpportunities = opportunities
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return Column(
      children: [
        ...sortedOpportunities.take(3).map(
              (opportunity) => OpportunityCard(
                opportunity: opportunity,
                onOpportunityDeleted: () => opportunities.remove(opportunity),
              ),
            ),
        if (sortedOpportunities.length > 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => showCupertinoModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return OpportunitiesResultsView(
                      ops: sortedOpportunities,
                    );
                  },
                ),
                child: Text(
                  'view all',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
