import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/search/components/by_username_results_list.dart';
import 'package:intheloopapp/ui/search/components/cancel_icon.dart';
import 'package:intheloopapp/ui/search/components/tapped_search_bar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

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
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _searchController = TextEditingController();
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
  }

  void _handleTabChange() {
    context.search.add(
      ChangeSearchTab(index: _tabController.index),
    );
  }

  List<Widget> _buildActions() {
    return [
      CancelIcon(
        focusNode: widget.searchFocusNode,
        searchController: _searchController,
      ),
    ];
  }

  late final TabController _tabController;
  late final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // appBar: AppBar(
      //   centerTitle: true,
      //   elevation: 0.5,
      //   backgroundColor: theme.colorScheme.background,
      //   title: TappedSearchBar(
      //     searchFocusNode: widget.searchFocusNode,
      //     searchController: _searchController,
      //   ),
      //   actions: _buildActions(),
      // ),
      // body: const ByUsernameResultsList(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.background,
            floating: true,
            title: TappedSearchBar(
              searchFocusNode: widget.searchFocusNode,
              searchController: _searchController,
            ),
            actions: _buildActions(),
          ),
          const SliverToBoxAdapter(
            child: ByUsernameResultsList(),
          ),
        ],
      ),
    );
  }
}
