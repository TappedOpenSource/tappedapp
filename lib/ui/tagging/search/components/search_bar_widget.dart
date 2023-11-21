  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:intheloopapp/domains/models/user_model.dart';
  import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
  import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/tagging/search/components/static_tag_tools.dart';
  import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:quiver/collection.dart';

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
      searchBloc.add(Search(query: TagTools.isItTaggable(searchText, widget.controller)));
    }

    @override
    Widget build(BuildContext context) {

      return Container(
          height: 300,
          color: Colors.purple,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                  width: 500,
                  height: 80,
                  color: Colors.amber,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = state.searchResults[index];
                      return Container(
                        width: 150,
                        color: Colors.cyan,
                        child: ListTile(
                          onTap: () {
                            // Q: how do I figure out where the cursor is at this controller?
                            String otherTextBefore = 
                            widget.controller.text.substring(0, widget.controller.selection.baseOffset).substring(0, widget.controller.text.lastIndexOf('@'));
                            String otherTextAfter = widget.controller.text.substring(widget.controller.selection.baseOffset, widget.controller.text.length);
                            widget.controller.text = '${otherTextBefore}@${user.username.username}${otherTextAfter}';
                            widget.close();
                          },
                          title: UserAvatar(
                            imageUrl: user.profilePicture,
                            radius: 20,
                          ),
                          subtitle: Text(user.username.username),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      
    }
  }
