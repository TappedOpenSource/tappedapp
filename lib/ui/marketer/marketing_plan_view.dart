import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
            EnumToString.convertToString(marketingPlan.type),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              Text(
                marketingPlan.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
