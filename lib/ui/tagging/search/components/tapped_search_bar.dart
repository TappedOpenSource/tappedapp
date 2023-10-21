import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';

class TappedSearchBar extends StatelessWidget {
  const TappedSearchBar({
    required this.searchFocusNode,
    required this.searchController,
    super.key,
  });

  final FocusNode searchFocusNode;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
      var searchBarHero = SearchBar(
          controller: searchController,
          focusNode: searchFocusNode,
          hintText: 'Search...',
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          onChanged: (input) {
            context.read<SearchBloc>().add(Search(query: input));
          },
        );
      var returnThis = BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return searchBarHero;
      },
    );
WidgetsBinding.instance.addPostFrameCallback((_) {context.read<SearchBloc>().add(Search(query: searchController.text));});

    
    return returnThis;
    searchController.addListener(() {
  context.read<SearchBloc>().add(Search(query: searchController.text));
});
  }
}
