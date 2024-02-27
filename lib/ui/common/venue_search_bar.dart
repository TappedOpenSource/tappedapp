import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/debouncer.dart';

class VenueSearchBar extends StatefulWidget {
  const VenueSearchBar({
    this.searchController,
    this.onSelected,
    super.key,
  });

  final SearchController? searchController;
  final void Function(UserModel)? onSelected;

  @override
  State<VenueSearchBar> createState() => _VenueSearchBarState();
}

class _VenueSearchBarState extends State<VenueSearchBar> {
  late final SearchController _searchController;
  final List<UserModel> _searchResults = [];
  final _debouncer = Debouncer(
    const Duration(milliseconds: 150),
    executionInterval: const Duration(milliseconds: 500),
  );

  Future<void> search() async {
    _debouncer.run(() async {
      final query = _searchController.text;
      final hits = await context.searchRepo.queryUsers(
        query,
        occupations: ['venue', 'Venue'],
      );

      setState(() {
        _searchResults
          ..clear()
          ..addAll(hits);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? SearchController();
    _searchController.addListener(search);
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, searchController) {
        return Hero(
          tag: 'searchBar',
          child: SearchBar(
            hintText: 'Search Venues...',
            controller: searchController,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            onTap: () {
              searchController.openView();
            },
          ),
        );
      },
      viewBuilder: (suggestions) {
        return _searchResults.isEmpty
            ? const Center(child: Text('No venues found'))
            : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return UserTile(
                    userId: user.id,
                    user: Option.of(user),
                    onTap: () {
                      widget.onSelected?.call(user);
                      _searchController.closeView(null);
                    },
                  );
                },
              );
      },
      suggestionsBuilder: (context, searchController) {
        return _searchResults.map(
          (user) => UserTile(
            userId: user.id,
            user: Option.of(user),
            onTap: () {
              widget.onSelected?.call(user);
              _searchController.closeView(null);
            },
          ),
        );
      },
    );
  }
}
