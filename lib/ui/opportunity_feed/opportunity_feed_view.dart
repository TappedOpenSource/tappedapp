import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
// import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_feed.dart';
import 'package:intheloopapp/ui/opportunity_feed/cubit/opportunity_feed_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class OpportunityFeedView extends StatelessWidget {
  const OpportunityFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocProvider(
          create: (context) => OpportunityFeedCubit(
            currentUserId: currentUser.id,
            database: context.read<DatabaseRepository>(),
          )..initOpportunities(),
          child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            // appBar: TappedAppBar(
            //   title: '',
            // ),
            body: const OpportunityFeed(),
          ),
        );
      },
    );
  }
}
