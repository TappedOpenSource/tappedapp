import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';

class TappedSearchBar extends StatefulWidget {
  const TappedSearchBar({
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onTap,
    this.trailing,
    super.key,
  });

  final FocusNode? focusNode;
  final SearchController? controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final List<Widget>? trailing;

  @override
  State<TappedSearchBar> createState() => _TappedSearchBarState();
}

class _TappedSearchBarState extends State<TappedSearchBar> {
  late final FocusNode _searchFocusNode;
  late final SearchController _searchController;
  final List<UserModel> _searchResults = [];

  void search() {
    final query = _searchController.text;
    context.search.add(Search(query: query));
    widget.onChanged?.call(query);
  }

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? SearchController();
    _searchFocusNode = widget.focusNode ?? FocusNode();

    _searchController.addListener(search);
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.removeListener(search);
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchRepo = context.read<SearchRepository>();
    return SearchAnchor(
      searchController: _searchController,
      viewBackgroundColor: theme.colorScheme.background,
      builder: (context, searchController) {
        return Hero(
          tag: 'searchBar',
          child: SearchBar(
            // elevation: const MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(
              theme.colorScheme.background,
            ),
            elevation: const MaterialStatePropertyAll(0),
            controller: searchController,
            focusNode: _searchFocusNode,
            hintText: 'search...',
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            trailing: widget.trailing ??
                [
                  CustomClaimsBuilder(
                    builder: (context, claims) {
                      final hasClaim = claims.isNotEmpty;
                      return IconButton(
                        onPressed: () {
                          return switch (hasClaim) {
                            true => context.push(
                                AdvancedSearchPage(),
                              ),
                            false => context.push(
                                PaywallPage(),
                              ),
                          };
                        },
                        icon: const Icon(CupertinoIcons.doc_text_search),
                        color: theme.colorScheme.onSurface,
                      );
                    },
                  ),
                ],
            onChanged: (_) {
              if (searchController.isOpen) {
                return;
              }
              searchController.openView();
            },
            onTap: () {
              searchController.openView();
              widget.onTap?.call();
            },
          ),
        );
      },
      viewBuilder: (suggestions) {
        return BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (suggestions.isNotEmpty && state.searchResults.isEmpty) {
              final sugList = suggestions.toList();
              return ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final userWidget = sugList[index];
                  return userWidget;
                },
              );
            }

            if (state.loading) {
              return const Center(
                child: LogoWave(),
              );
            }

            return state.searchResults.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = state.searchResults[index];
                      return UserTile(
                        userId: user.id,
                        user: Option.of(user),
                      );
                    },
                  );
          },
        );
      },
      suggestionsBuilder: (context, searchController) async {
        final suggestedUsers = await searchRepo.queryUsers('');
        return suggestedUsers.map(
          (user) => UserTile(
            userId: user.id,
            user: Option.of(user),
          ),
        );
      },
    );
  }
}
