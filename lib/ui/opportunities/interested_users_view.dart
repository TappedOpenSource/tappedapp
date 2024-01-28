import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class InterestedUsersView extends StatelessWidget {
  const InterestedUsersView({
    required this.opportunity,
    super.key,
  });

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,      
      appBar: AppBar(
        title: Text(opportunity.title),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: database.getInterestedUsers(opportunity),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingView();
          }

          final interestedUsers = snapshot.data!;
          return ListView.builder(
            itemCount: interestedUsers.length,
            itemBuilder: (context, index) {
              final interest = interestedUsers[index];
              return UserTile(
                userId: interest.id,
                user: Option.of(interest),
              );
            },
          );
        },
      ),
    );
  }
}
