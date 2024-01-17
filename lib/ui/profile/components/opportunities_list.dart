import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/profile/components/opportunity_card.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

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
          height: 250,
          child: ScrollSnapList(
            onItemFocus: (index) {},
            itemSize: MediaQuery.of(context).size.width - 40,
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              // if (index == opportunities.length) {
              //   return Container(
              //     width: MediaQuery.of(context).size.width - 40,
              //     color: Colors.transparent,
              //   );
              // }

              final opportunity = opportunities[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: OpportunityCard(
                  opportunity: opportunity,
                  onOpportunityDeleted: () => opportunities.removeAt(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
