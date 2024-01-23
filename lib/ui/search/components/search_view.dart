import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  late final TextEditingController _searchController;

  List<Widget> _buildActions() {
    return [
      CancelIcon(
        focusNode: widget.searchFocusNode,
        searchController: _searchController,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.searchFocusNode.requestFocus();
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
    // final database = context.database;
    // return SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: 16,
    //           horizontal: 8,
    //         ),
    //         child: Text(
    //           'Top Bookers',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       FutureBuilder(
    //         future: database.getBookerLeaders(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           }
    //
    //           final bookerLeaders = snapshot.data ?? [];
    //           return _userSlider(bookerLeaders);
    //         },
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: 16,
    //           horizontal: 8,
    //         ),
    //         child: Text(
    //           'Top Richmond Venues',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       FutureBuilder(
    //         future: database.getRichmondVenues(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           }
    //
    //           final richmondVenues = snapshot.data ?? [];
    //           return _venueSlider(richmondVenues);
    //         },
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: 16,
    //           horizontal: 8,
    //         ),
    //         child: Text(
    //           'Top DC Venues',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       FutureBuilder(
    //         future: database.getDCVenues(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           }
    //
    //           final dcVenues = snapshot.data ?? [];
    //           return _venueSlider(dcVenues);
    //         },
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: 16,
    //           horizontal: 8,
    //         ),
    //         child: Text(
    //           'Top NoVa Venues',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       FutureBuilder(
    //         future: database.getNovaVenues(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           }
    //
    //           final novaVenues = snapshot.data ?? [];
    //           return _venueSlider(novaVenues);
    //         },
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: 16,
    //           horizontal: 8,
    //         ),
    //         child: Text(
    //           'Top Maryland Venues',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       FutureBuilder(
    //         future: database.getMarylandVenues(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           }
    //
    //           final marylandVenues = snapshot.data ?? [];
    //           return _venueSlider(marylandVenues);
    //         },
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: 16,
    //           horizontal: 8,
    //         ),
    //         child: Text(
    //           'Top Performers',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       FutureBuilder(
    //         future: database.getBookingLeaders(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           }
    //
    //           final bookingLeaders = snapshot.data ?? [];
    //           return _userSlider(bookingLeaders);
    //         },
    //       ),
    //       const SizedBox(
    //         height: 100,
    //       ),
    //     ],
    //   ),
    // );
  }
}
