import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/search/components/by_username_results_list.dart';
import 'package:intheloopapp/ui/search/components/cancel_icon.dart';
import 'package:intheloopapp/ui/search/components/tapped_search_bar.dart';

class SearchView extends StatefulWidget {
  SearchView({
    FocusNode? searchFocusNode,
    super.key,
  }) : searchFocusNode = searchFocusNode ?? FocusNode();

  final FocusNode searchFocusNode;

  @override
  // ignore: library_private_types_in_public_api
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }


  List<Widget> _buildActions() {
    return [
      CancelIcon(
        focusNode: widget.searchFocusNode,
        searchController: _searchController,
      ),
    ];
  }

  late final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.transparent,
        title: TappedSearchBar(
          searchFocusNode: widget.searchFocusNode,
          searchController: _searchController,
        ),
        actions: _buildActions(),
      ),
      body: const ByUsernameResultsList(),
    );
  }
}
