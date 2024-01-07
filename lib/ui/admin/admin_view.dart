import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/admin/create_opportunity_cubit.dart';
import 'package:intheloopapp/ui/admin/create_opportunity_form.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';

class AdminView extends StatelessWidget {
  const AdminView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => CreateOpportunityCubit(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: const TappedAppBar(
          title: 'Admin',
        ),
        body: const CreateOpportunityForm(),
      ),
    );
  }
}
