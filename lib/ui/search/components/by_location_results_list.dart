import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/search/location_discover_view.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class ByLocationResultsList extends StatelessWidget {
  const ByLocationResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: LogoWave(),
          );
        }

        if (state.isNotSearching) {
          return const LocationDiscoverView();
        }

        if (state.searchTerm.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 200,
                  color: Color(0xFF757575),
                ),
                Text(
                  'Search Location',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          );
        } else if (state.searchResultsByLocation.isEmpty) {
          if (state.locationResults.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: state.locationResults.length,
            itemBuilder: (BuildContext context, int index) {
              final prediction = state.locationResults[index];
              // print('PRED $prediction');
              return ListTile(
                onTap: () {
                  context
                      .read<SearchBloc>()
                      .add(SearchUsersByPrediction(prediction: prediction));
                },
                leading: const Icon(CupertinoIcons.location_fill),
                title: Text(prediction.primaryText),
                subtitle: Text(prediction.secondaryText),
              );
            },
          );
        } else {
          return ListView.builder(
            itemCount: state.searchResultsByLocation.length,
            itemBuilder: (BuildContext context, int index) {
              final user = state.searchResultsByLocation[index];
              return UserTile(
                userId: user.id,
                user: Some(user),
              );
            },
          );
        }
      },
    );
  }
}
