import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

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
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SearchBar(
          controller: searchController,
          focusNode: searchFocusNode,
          hintText: 'Search...',
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          trailing: [
            IconButton(
              onPressed: () {
                context.push(
                  AdvancedSearchPage(),
                );
              },
              icon: const Icon(CupertinoIcons.doc_text_search),
              color: theme.colorScheme.onSurface,
            ),
          ],
          onChanged: (input) {
            context.search.add(Search(query: input));
          },
        );
      },
    );
  }
}
