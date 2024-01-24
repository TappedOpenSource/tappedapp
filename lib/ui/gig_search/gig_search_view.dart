import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';

class GigSearchView extends StatelessWidget {
  const GigSearchView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<GigSearchCubit>(
      create: (context) => GigSearchCubit(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: const TappedAppBar(
          title: 'Opportunities',
        ),
        body: const Column(
          children: [
            Text('cities'),
            Text('genres'),
          ],
        ),
      ),
    );
  }
}
