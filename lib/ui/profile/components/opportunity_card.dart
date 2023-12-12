import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/ui/profile/components/apply_button.dart';
import 'package:intheloopapp/ui/profile/components/location_chip.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:skeletons/skeletons.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    required this.opportunity,
    super.key,
  });

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 1200,
            width: double.infinity,
            child: OpportunityView(
              opportunity: opportunity,
            ),
          );
        },
      ),
      child: FutureBuilder<ImageProvider>(
        future: getOpImage(context, opportunity),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SkeletonAvatar();
          }

          final provider = snapshot.data!;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
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
              ],
            ),
          );
        },
      ),
    );
  }
}