import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/user_avatar.dart';

class SearchBarWidget extends StatefulWidget {
  //final FirestoreDatabaseImpl database;
  Function close;
  SearchBarWidget(this.controller,  this.close, {super.key}); 
  

 TextEditingController controller;
 // Q: I need to declare a function passed in by the parent widget. How do I do that? 
  // A: Declare a function type, then pass in the function as a parameter.

 


  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
      resizeToAvoidBottomInset: false,  
        body: Container(
          color: Colors.purple,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state){
            return Column(
              children: [ 
                Container(
                color: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBar(
                  controller: controller,
                  onChanged: (value) {
                    context.read<SearchBloc>().add(Search(query: value));
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state.loading) { print('avsz search loading');
                      return Center(child: CircularProgressIndicator());
                    } else if (state.isNotSearching || state.searchResults.length > 0) { print('avsz search not searching');
                      final users = state.searchResults;
                      print('avsz users: ${users.length}');
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(      onTap: () {controller.text = ('@${user.username.username}'); print('avsz search onTap'); widget.close();},
                            title: Text(user.username.username),
                            subtitle: UserAvatar(
                              imageUrl: user.profilePicture,
                              radius: 14,
                              ),
                          );
                        },
                      );
                    } else {print('avsz search else');
                      return Container();
                    }
                  },
                ),
              ),
            ],
            ); print('avsz wierd third choice'); return Container();
          },
          
          ),
        ),
      ),
    );
  }
}

