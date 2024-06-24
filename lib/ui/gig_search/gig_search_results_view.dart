import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
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
          backgroundColor: theme.colorScheme.surface,
          floatingActionButton: state.selectedResults.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () {
                    context.push(
                      RequestToPerformPage(
                        venues: state.selectedResults,
                        collaborators: state.collaborators,
                      ),
                    );
                  },
                  label: const Text('confirm'),
                  icon: const Icon(Icons.check),
                )
              : null,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<GigSearchCubit>().resetForm();
              },
            ),
            actions: const [],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: state.allSelected,
                          onChanged: (selected) {
                            context.read<GigSearchCubit>().selectAll(
                                  selected ?? false,
                                );
                          },
                        ),
                        const SizedBox(width: 4),
                        const Text('select all'),
                      ],
                    ),
                    Text(
                      'found ${state.results.length} venues',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: switch (state.results.isEmpty) {
            true => const Center(
                child: Text('No results'),
              ),
            false => ListView.builder(
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final selectableResult = state.results[index];
                  final venue = selectableResult.user;
                  return UserTile(
                    userId: venue.id,
                    user: Option.of(venue),
                    trailing: Checkbox(
                      value: selectableResult.selected,
                      onChanged: (selected) {
                        context.read<GigSearchCubit>().updateSelected(
                              venue.id,
                              selected ?? false,
                            );
                      },
                    ),
                  );
                },
              ),
          },
        );
      },
    );
  }
}
