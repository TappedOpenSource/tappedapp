import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class TaggableOverlay extends StatelessWidget {
  final TextEditingController textEditingController;

  const TaggableOverlay({Key? key, required this.textEditingController})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {

        //if ( !state.loading
        // || 
        //!state.isNotSearching
        //) {
          //print('avsz RIGHT Container, searching for ${state.searchTerm} ,  ${state.searchResults.length} results');
          final returnThis = [
              OverlayEntry(
                builder: (BuildContext context) {
                  final boxDecoration = BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      );
                  return 
                    Container(
                      decoration: boxDecoration,
                      child: Column(
                        children: [
                          SearchBar(
                            controller: textEditingController,
                             onChanged: (input) {
                              print('avsz text changed, input: $input');
                              context.read<SearchBloc>().add(Search(query: input));
                              },
                              ),
                          
                           ListView.builder(
                          //shrinkWrap: true,
                          //itemCount: state.searchResults.length,
                          itemBuilder: (context, index) {
                            final UserModel user = state.searchResults[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profilePicture ??
                                        'assets/default_avatar.png'),
                              ),
                              title: Text(user.username.username),
                              onTap: () {
                                textEditingController.text = user.username.username;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                        ],
                      ),
                    );
                },
              ),
            ];
          return Overlay(
            initialEntries: returnThis,
          );
        
      },
    );
  }
}