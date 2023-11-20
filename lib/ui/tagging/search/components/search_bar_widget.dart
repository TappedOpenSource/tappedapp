  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:intheloopapp/domains/models/user_model.dart';
  import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
  import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
  import 'package:intheloopapp/ui/user_avatar.dart';

  class SearchBarWidget extends StatefulWidget {
    final Function close;
    final TextEditingController controller;

    SearchBarWidget(this.controller, this.close, {Key? key}) : super(key: key);

    @override
    _SearchBarWidgetState createState() => _SearchBarWidgetState();
  }

  class _SearchBarWidgetState extends State<SearchBarWidget> {
    
    @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    widget.controller.addListener(_onTextChanged);
  });
}

    @override
    void dispose() {
      widget.controller.removeListener(_onTextChanged);
      super.dispose();
    }

    void _onTextChanged() {
      final searchText = widget.controller.text;
      final searchBloc = context.read<SearchBloc>();
      searchBloc.add(Search(query: searchText));
    }

    @override
    Widget build(BuildContext context) {

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 500,
          color: Colors.purple,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Scaffold(
                body: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = state.searchResults[index];
                    return ListTile(
                      onTap: () {
                        widget.controller.text = '@${user.username.username}';
                        widget.close();
                      },
                      title: UserAvatar(
                        imageUrl: user.profilePicture,
                        radius: 14,
                      ),
                      subtitle: Text(user.username.username),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  }
