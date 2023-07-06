import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/search/components/by_location_results_list.dart';
import 'package:intheloopapp/ui/search/components/by_loop_results_list.dart';
import 'package:intheloopapp/ui/search/components/by_username_results_list.dart';
import 'package:intheloopapp/ui/search/components/cancel_icon.dart';
import 'package:intheloopapp/ui/search/components/tapped_search_bar.dart';
import 'package:intheloopapp/ui/themes.dart';

class SearchView extends StatefulWidget {
  SearchView({
    FocusNode? searchFocusNode,
    super.key,
  }): searchFocusNode = searchFocusNode ?? FocusNode();

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
      length: 3,
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
    context.read<SearchBloc>().add(
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: theme.colorScheme.background,
        title: TappedSearchBar(
          searchFocusNode: widget.searchFocusNode,
          searchController: _searchController,
        ),
        actions: _buildActions(),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: tappedAccent,
          labelColor: tappedAccent,
          tabs: const [
            Tab(child: Text('Username')),
            Tab(child: Text('Location')),
            Tab(child: Text('Loops')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ByUsernameResultsList(),
          ByLocationResultsList(),
          ByLoopResultsList(),
        ],
      ),
    );
  }
}
