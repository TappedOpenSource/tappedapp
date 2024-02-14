import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class GigSearchResultsView extends StatelessWidget {
  const GigSearchResultsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<GigSearchCubit, GigSearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<GigSearchCubit>().resetForm();
              },
            ),
            actions: [],
          ),
          body: switch (state.results.isEmpty) {
            true => const Center(
                child: Text('No results'),
              ),
            false => ListView.builder(
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final venue = state.results[index];
                  return UserTile(
                    userId: venue.id,
                    user: Option.of(venue),
                  );
                },
              ),
          },
        );
      },
    );
  }
}
