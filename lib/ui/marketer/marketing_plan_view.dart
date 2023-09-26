import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/domains/models/marketing_plan.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class MarketingPlanView extends StatelessWidget {
  const MarketingPlanView({
    required this.marketingPlan,
    super.key,
  });

  final MarketingPlan marketingPlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity),
        Text(marketingPlan.content),
        CupertinoButton.filled(
          onPressed: () => context.pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
