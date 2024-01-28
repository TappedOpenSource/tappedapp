import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/search/components/by_username_results_list.dart';
import 'package:intheloopapp/ui/search/components/cancel_icon.dart';
import 'package:intheloopapp/ui/search/components/tapped_search_bar.dart';

class SearchView extends StatefulWidget {
  SearchView({
    FocusNode? focusNode,
    super.key,
  }) {
    searchFocusNode = focusNode ?? FocusNode();
  }

  late final FocusNode searchFocusNode;

  @override
  // ignore: library_private_types_in_public_api
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    if (!_searchFocusNode.hasFocus) {
      _searchFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  late final TextEditingController _searchController;

  FocusNode get _searchFocusNode => widget.searchFocusNode;

  List<Widget> _buildActions() {
    return [
      CancelIcon(
        focusNode: _searchFocusNode,
        searchController: _searchController,
        onTap: context.pop,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.transparent,
        title: const TappedSearchBar(),
        actions: _buildActions(),
      ),
      body: const ByUsernameResultsList(),
    );
  }
}
