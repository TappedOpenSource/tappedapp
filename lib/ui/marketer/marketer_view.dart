import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/app/app.dart';
import 'package:intheloopapp/ui/marketer/components/marketing_option.dart';

class MarketerView extends StatelessWidget {
  const MarketerView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Text(
                  'what do you want to market?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              MarketingOption(
                title: 'new single',
                onTap: () => context.push(CreateSingleMarketingPlanPage()),
              ),
              const MarketingOption(
                title: 'new album',
                disabled: true,
              ),
              const MarketingOption(
                title: 'new music video',
                disabled: true,
              ),
              const MarketingOption(
                title: 'merch',
                disabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
