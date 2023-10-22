import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/tagging/search/components/discover_view.dart';
import 'package:intheloopapp/ui/tagging/search/components/user_tile.dart';

class ByUsernameResultsList extends StatelessWidget {
  const ByUsernameResultsList({super.key, required this.tagController, required VoidCallback this.onClear});
  final TextEditingController tagController;
  final VoidCallback onClear; 

  BlocBuilder returnThis(){
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.loading || state.isNotSearching) {
          return const Center(
            child: LogoWave(),
          );
        }

        //if (state.isNotSearching) {return const DiscoverView();}

        return state.searchResults.isEmpty
            ? const Center(child: Text('No users found'))
            : ListView.builder(
                itemCount: state.searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = state.searchResults[index];
                  return UserTile(
                    onClear: onClear,
                    tagController: tagController,
                    userId: user.id,
                    user: Some(user),
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return returnThis();
  }
}


