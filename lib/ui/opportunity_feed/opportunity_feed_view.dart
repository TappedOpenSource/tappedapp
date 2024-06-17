import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_feed.dart';
import 'package:intheloopapp/ui/opportunity_feed/cubit/opportunity_feed_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class OpportunityFeedView extends StatelessWidget {
  const OpportunityFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opBloc = context.opportunities;
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocProvider(
          create: (context) => OpportunityFeedCubit(
            currentUserId: currentUser.id,
            opBloc: opBloc,
            database: database,
          )..initOpportunities(),
          child: Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: const OpportunityFeed(),
          ),
        );
      },
    );
  }
}
