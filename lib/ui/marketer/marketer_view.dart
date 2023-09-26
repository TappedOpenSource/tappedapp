import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/marketer/components/marketing_option.dart';
import 'package:intheloopapp/ui/marketer/components/marketing_plans_list.dart';
import 'package:intheloopapp/ui/marketer/cubit/marketer_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class MarketerView extends StatelessWidget {
  const MarketerView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocProvider(
          create: (context) => MarketerCubit(
            currentUserId: currentUser.id,
            database: context.read<NavigationBloc>().database,
          )
          ..initMarketingPlans(),
          child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            appBar: AppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: double.infinity),
                    const MarketingPlansList(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
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
                      onTap: () =>
                          context.push(CreateSingleMarketingPlanPage()),
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
          ),
        );
      },
    );
  }
}
