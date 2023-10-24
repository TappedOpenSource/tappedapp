import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/user_model.dart';


class SearchBarWidget extends StatefulWidget {
  final List<UserModel> users;

  SearchBarWidget({required this.users});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<UserModel> _searchResults = [];

  void _onSearch(String searchTerm) {
    setState(() {
      _searchResults = widget.users.where((user) =>
          user.username.username.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TappedSearchBar(onSearch: _onSearch),
        Expanded(
          child: ByUsernameResultsList(users: _searchResults),
        ),
      ],
    );
  }
}

class TappedSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  TappedSearchBar({required this.onSearch});

  @override
  _TappedSearchBarState createState() => _TappedSearchBarState();
}

class _TappedSearchBarState extends State<TappedSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    widget.onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by username',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
        ),
        onSubmitted: (_) => _onSearch(),
      ),
    );
  }
}

class ByUsernameResultsList extends StatelessWidget {
  final List<UserModel> users;

  ByUsernameResultsList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.username.username),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
