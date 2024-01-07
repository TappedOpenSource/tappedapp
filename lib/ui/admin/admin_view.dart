import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/admin/create_opportunity_cubit.dart';
import 'package:intheloopapp/ui/admin/create_opportunity_form.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class AdminView extends StatelessWidget {
  const AdminView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocProvider(
          create: (context) => CreateOpportunityCubit(
            database: context.database,
            storage: context.storage,
            currentUserId: currentUser.id,
          ),
          child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            appBar: const TappedAppBar(
              title: 'Admin',
            ),
            body: const CreateOpportunityForm(),
          ),
        );
      },
    );
  }
}
