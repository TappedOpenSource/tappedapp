import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/marketing_plan.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/marketer/cubit/marketer_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class MarketingPlansList extends StatelessWidget {
  const MarketingPlansList({super.key});

  Widget _buildList(List<MarketingPlan> marketingPlans) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: marketingPlans.length,
        itemBuilder: (context, index) {
          final marketingPlan = marketingPlans[index];
          return InkWell(
            onTap: () => context.push(
              MarketingPlanPage(marketingPlan: marketingPlan),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      EnumToString.convertToString(marketingPlan.type),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeago.format(
                        marketingPlan.timestamp,
                        locale: 'en',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketerCubit, MarketerState>(
      builder: (context, state) {
        if (state.marketingPlans.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Text(
                'saved market plans',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: _buildList(state.marketingPlans),
            ),
          ],
        );
      },
    );
  }
}
